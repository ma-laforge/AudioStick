#AudioStick.jl
#
#Copies/synchronizes a media playlist to an arbitrary folder/drive.

const __APPPATH__ = dirname(realpath(@__FILE__))
push!(LOAD_PATH, joinpath(__APPPATH__, "lib"))
using CmdLineTools
using EasyConf
using PlaylistTools


# Constants
################################################################################

const __APPNAME__ = "AudioStick"
const __CFGFILE__ = "AudioStick.cfg"
#Entries in config file:
	const CFGID_FSPLROOT = "FILESYSTEMPLAYLIST_ROOTFOLDER" 


# Usage
################################################################################

function showusage()
	cmd = basename(@__FILE__)
	println("$cmd")
	println()
	println("Usage:")
	println("   $cmd [playlist]")
	println()
	println("$__APPNAME__ creates/synchronizes a filesystem-based")
	println("media playlist from the specified playlist *file*.")
end


# Types
################################################################################

type ASOptions
	srcpath::String      #Input playlist file
	destrootpath::String #Root folder where filesystem-based playlists are stored
	destpath::String     #Folder of filesystem-based playlist
end
ASOptions() = ASOptions("", "", "")


# Helper functions
################################################################################

#-------------------------------------------------------------------------------
function validateargs(args, options)
	if length(args) < 1
		showusage()
		error("Insufficient arguments.")
	end

	options.srcpath = joinpath(pwd(), args[1])
	if !isfile(options.srcpath)
		error("Playlist not found: $(options.srcpath)")
	end
end


# Main entry point to the program
################################################################################

#-------------------------------------------------------------------------------
function main(apppath, args)
#Validate command-line arguments:
	options = ASOptions()
	validateargs(args, options)
	srcfilename = basename(options.srcpath)

	println_ul(__APPNAME__)
	println("\nSource playlist: $srcfilename\n\n")

#Read in settings from config file:
	cfgpath = joinpath(apppath, __CFGFILE__)
	cfg = read(EasyConfFile, cfgpath)
	default_fsplroot = getvalue(cfg, CFGID_FSPLROOT, "E:\\")

#Ask for destination path:
	prompt = "Root path of destination (exclude playlist subfolder)"
	options.destrootpath = input(ASCIIString, prompt, default_fsplroot)
	println()

	destfoldername = splitext(srcfilename)
	if length(destfoldername) < 1
		error("Playlist does not have a name.")
	end
	destfoldername = destfoldername[1]

#Create filesystem-based playlist:
	options.destpath = joinpath(options.destrootpath, destfoldername)
	playlist = read(M3UFile, options.srcpath)
	synchronize(playlist, options.destpath)

#Update config file:
	cfg[CFGID_FSPLROOT] = options.destrootpath
	write(EasyConfFile, cfgpath, cfg)
end

# Start program
#-------------------------------------------------------------------------------
try
	main(__APPPATH__, ARGS)
catch e
	@show e
	pause()
	rethrow(e)
end

pause()
:Done
