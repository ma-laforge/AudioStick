#PlaylistTools.jl
#Manipulates media playlists (reads in .m3u files, synchronizes folders...)

module PlaylistTools

export M3UFile
export synchronize

using FileTools


# Types
################################################################################

abstract PlaylistFile
type M3UFile <: PlaylistFile; end

typealias FileList Vector{String}
fileList() = String[]


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

#Generate names for the output files (file system playlist)
#-------------------------------------------------------------------------------
function filesystemplaylist(srclist::FileList)
	result = fileList()
	i = 1
	for src in srclist
		push!(result,  @sprintf("%03d-%s", i, cleannamme(basename(src))))
		i += 1
	end
	return result
end

#Test if given file is in playlist
#-------------------------------------------------------------------------------
elemof(list::FileList, filename::String) = (findfirst(list, filename) != 0)


# Read/Write functions
################################################################################

#-------------------------------------------------------------------------------
function Base.read(::Type{M3UFile}, path::String)
	result = fileList()
	prefix = realpath(path::String)
	f = open(path, "r")

	try
		for line in eachline(f)
			line = strip(line)
			if length(line) > 0 && line[1] != '#'
				push!(result, joinpath(prefix, line))
			end
		end
	finally
		close(f)
	end

	return result
end



# Main algorithms
################################################################################

#Synchronize all files in playlist to the destination directory.
#   psrc:   Source playlist
#   plpath: Path of filesystem-based playlist
#-------------------------------------------------------------------------------
function synchronize(psrc::FileList, plpath::String)
	println("Synchronizing playlist \"$plpath\"...")

	try
		mkpath(plpath)
	catch
		error("Could not create destination folder: $plpath.")
	end

	#Desired output (filesystem-based) playlist:
	pdest = filesystemplaylist(psrc)

	n_delete = 0
	filelist = readdir(plpath)
	for filename in filelist
		if !elemof(pdest, basename(filename))
			info("Delete \"$filename\"...")
			rm(joinpath(plpath, filename))
			n_delete += 1
		end
	end

	mapping = zip(psrc, pdest)
	n_sync = 0
	for (src, dest) in mapping
		info("Sync \"$(basename(dest))\"...")
		if fastsync_sourcefile(src, joinpath(plpath, dest))
			n_sync += 1
		end
	end

	missing = length(pdest) - n_sync
	print("\nDone. ")
	print("$n_sync files synchronized ($missing missing)")
	print(", $n_delete files deleted.\n")
end

end #PlaylistTools
