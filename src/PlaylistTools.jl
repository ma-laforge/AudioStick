#PlaylistTools.jl
#Manipulates media playlists (reads in .m3u files...)

module PlaylistTools

export M3UFile, FileList

using FileTools


# Types
################################################################################

abstract type PlaylistFile end
mutable struct M3UFile <: PlaylistFile; end

const FileList = Vector{String}


# Read/Write functions
################################################################################

#-------------------------------------------------------------------------------
function Base.read(::Type{M3UFile}, path::String)
	result = FileList()
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


end #PlaylistTools
