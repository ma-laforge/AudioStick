#console_app.jl: Simple command line interface for AudioStick package.


#==Constants
===============================================================================#
const APPNAME = "AudioStick"

#Entries in config file (currently not supported):
const CFGID_FSPLROOT = "FILESYSTEMPLAYLIST_ROOTFOLDER" 

const DFLT_TGTROOT = "Z:\\"


#==Types
===============================================================================#
mutable struct ASOptions
	srcpath::String #Input playlist file
	tgtroot::String #Target path (excluding playlist subfolder)
end
ASOptions(srcpath) = ASOptions(srcpath, DFLT_TGTROOT)


#==Helper functions
===============================================================================#

#Parse & validate command-line arguments:
function parseargs(args)
	if length(args) < 1
		@error("Must set source playlist in `ARGS`")
		error("Insufficient arguments.") #throws
	end

	options = ASOptions(joinpath(pwd(), strip(args[1])))
	if !isfile(options.srcpath)
		error("Playlist not found: $(options.srcpath)")
	end

	if length(args) >= 2
		options.tgtroot = strip(args[2])
	end

	return options
end


#==Main "console" entry point
===============================================================================#

function run_console(args)
	options = parseargs(args)
	srcfilename = basename(options.srcpath)

	println_ul(APPNAME)
	println("\nSource playlist: $srcfilename\n\n")

	#Ask for target path:
	prompt = "Target path (excluding playlist subfolder)"
	options.tgtroot = input(String, prompt, options.tgtroot)
	println()

	destfoldername = splitext(srcfilename)
	if length(destfoldername) < 1
		error("Playlist does not have a name.")
	end
	destfoldername = destfoldername[1]

	#Create filesystem-based playlist:
	destpath = joinpath(options.tgtroot, destfoldername)
	playlist = read_m3u(options.srcpath)
	synchronize(playlist, destpath)
end

"""`run_console()`

Create/synchronize a filesystem-based media playlist from the playlist *file*
specified in `ARGS`.
"""
run_console() = run_console(ARGS)

#Last line
