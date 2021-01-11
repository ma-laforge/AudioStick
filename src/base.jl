#base.jl: base type, constant & function definitions
#==Comments
Main algorithm always tries to keep existing files to avoid copying for no
reason. This also allows successive sync operations to progressively overwrite
corrupt files (there seems to be a file corruption issue).

Algorithm also renames old "destination folder" with temporary name, and
rebuilds a new folder (moving files into that folder). This is done in an
attempt to satisfy media players that sort by creation order instead of file
names.
===============================================================================#


#==Useful constants
===============================================================================#


#==Main types
===============================================================================#
struct Playlist
	origin::String
	filelist::Vector{String}
end
Playlist(origin::String) = Playlist(origin, [])


#==Accessors & helper functions
===============================================================================#
Base.length(p::Playlist) = length(p.filelist)
Base.push!(p::Playlist, args...) = push!(p.filelist, args...)
Base.iterate(p::Playlist, args...) = iterate(p.filelist, args...)
Base.in(v::String, p::Playlist) = Base.in(v, p.filelist)
tmp_folder_name(destfld::String) = destfld * "_AStmpfolder"


#==Read/write functions
===============================================================================#
function read_m3u(path::String)
	path = abspath(path)
	prefix = dirname(path)
	result = Playlist(path)

	open(path, "r") do f
		for line in eachline(f)
			line = strip(line)
			if length(line) > 0 && line[1] != '#'
				push!(result, joinpath(prefix, line))
			end
		end
	end

	return result
end


#==File/folder manipulations
===============================================================================#
function clean_playlistfolder(tgtlist::Playlist)
	destfld = tgtlist.origin
	n_delete = 0
	filelist = readdir(destfld)
	for filename in filelist
		if !(basename(filename) in tgtlist)
			@info("Deleting \"$filename\"...")
			rm(joinpath(destfld, filename))
			n_delete += 1
		end
	end
	return n_delete
end


#==Main algorithm
===============================================================================#
#Generate filesystem-based playlist (names for the output files)
function gen_fsplaylist(src::Playlist, destfld::String)
	result = Playlist(destfld)
	for (i, srcpath) in enumerate(src.filelist)
		push!(result,  @sprintf("%03d-%s", i, cleannamme(basename(srcpath))))
	end
	return result
end

"""`synchronize(src::Playlist, destfld::String)`

Synchronize all files in playlist to the destination directory.
# Inputs
 - src: Source Playlist
 - destfld: Destination folder (Path of filesystem-based playlist)
"""
function synchronize(src::Playlist, destfld::String)
	#Select file matching algorithm:
	filesmatch = filesmatch_SHA
	#filesmatch = filesmatch_fast

	@info("Synchronizing file-based playlist:\n$destfld...")
	println()

	destfld = abspath(destfld)
	tmpfld = tmp_folder_name(destfld)

	#Delete any files in playlist folder that are not in playlist.
	tgtlist = gen_fsplaylist(src, destfld)
	n_delete = clean_playlistfolder(tgtlist)

	#Move old playlist folder to tmpfld
	if isdir(tmpfld)
		rm(tmpfld)
	end
	if isdir(destfld)
		mv(destfld, tmpfld)
	else
		mkpath(tmpfld)
	end
	try
		mkpath(destfld)
	catch #Throw more useful error:
		error("Could not create destination folder: $destfld.")
	end

	n_missing = 0
	n_sync = 0
	n_sync_failed = 0
	for (srcpath, destfile) in zip(src, tgtlist)
		@info("Synchronizing \"$destfile\"\nto $srcpath")
		tmppath = joinpath(tmpfld, destfile) #Full path
		destpath = joinpath(destfld, destfile) #Full path

		if (!isfile(srcpath))
			@warn("Missing file: $srcpath")
			n_missing += 1
			continue
		end

		if !filesmatch(srcpath, tmppath)
			cp(srcpath, tmppath, force=true) #Won't preserve modified timestamps.
			#run(`cp -p $srcpath $destpath`) #No longer preserves timestamps either.
		end

		mv(tmppath, destpath)
		if !filesmatch(srcpath, destpath)
			@warn("Synchronization failed.")
			n_sync_failed += 1
		else
			n_sync += 1
		end
	end

	rm(tmpfld)
	missing = length(tgtlist) - n_sync
	print("\nDone. ")
	print("$n_sync files synchronized")
	print(", $n_sync_failed failed, $n_missing missing")
	print(", $n_delete files deleted.\n")
end

#Last line
