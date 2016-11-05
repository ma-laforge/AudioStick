#AudioStick.jl
#Copies/synchronizes playlist media files to a given drive/folder.

#Include library "modules":
include("lib/libinclude.jl")

module AudioStick

include("configure.jl")

export synchronize
using FileTools
using PlaylistTools


# Helper functions
################################################################################

#Generate output file name from source filename
#(Strip out numbers, spaces, -, & _ from source basename)
#-------------------------------------------------------------------------------
function cleannamme(src::String)
	const pat = r"^[0-9|\-|_| ]*(.*)$"

	#Get simplified filename:
	m = match(pat, src)
	result = strip(m.captures[1])
	if length(result) < 1
		result = src #Don't simplify
	end
	return result
end

#Test if given file is in playlist
#-------------------------------------------------------------------------------
elemof(list::FileList, filename::String) = (findfirst(list, filename) != 0)

#Generate names for the output files (filesystem-based playlist)
#-------------------------------------------------------------------------------
function filesystemplaylist(srclist::FileList)
	result = FileList()
	i = 1
	for src in srclist
		push!(result,  @sprintf("%03d-%s", i, cleannamme(basename(src))))
		i += 1
	end
	return result
end

# Main algorithms
################################################################################

function clean_playlistfolder(destfld::String, tgtlist::FileList)
	n_delete = 0
	filelist = readdir(destfld)
	for filename in filelist
		if !elemof(tgtlist, basename(filename))
			info("Delete \"$filename\"...")
			rm(joinpath(destfld, filename))
			n_delete += 1
		end
	end
	return n_delete
end

#Synchronize all files in playlist to the destination directory.
#   srcpl:   Source playlist
#   destfld: Destination folder (Path of filesystem-based playlist)
#-------------------------------------------------------------------------------
function synchronize(srcpl::FileList, destfld::String)
	println("Synchronizing playlist \"$destfld\"...")

	try
		mkpath(destfld)
	catch
		error("Could not create destination folder: $destfld.")
	end

	#Get list of target file names corresponding to source playlist.
	tgtlist = filesystemplaylist(srcpl)

	n_delete = clean_playlistfolder(destfld, tgtlist)
	n_missing = 0
	n_sync = 0
	n_sync_failed = 0
	mapping = zip(srcpl, tgtlist)
	for (src, destfile) in mapping
		println("$(destfile)...")
		destpath = joinpath(destfld, destfile) #Full path

		if (!isfile(src))
			warn("Missing file: $src")
			n_missing += 1
			continue
		elseif filesmatch(src, destpath)
			n_sync += 1
			continue
		end

		info("Synchronizing to $src.")
		cp(src, destpath, remove_destination=true) #Won't preserve modified timestamps.
#		run(`cp -p $src $destpath`) #No longer preserves timestamps either.

		if !filesmatch(src, destpath)
			warn("Synchronization failed.")
			n_sync_failed += 1
		else
			n_sync += 1
		end
	end

	missing = length(tgtlist) - n_sync
	print("\nDone. ")
	print("$n_sync files synchronized")
	print(", $n_sync_failed failed, $n_missing missing")
	print(", $n_delete files deleted.\n")
end

end
