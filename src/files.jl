#FileTools.jl
#Tools to help with file manipulations

module FileTools

export filesmatch

using SHA


# Types
################################################################################


# Functions
################################################################################

#Compute hash key from file contents to verify file equivalence.
#-------------------------------------------------------------------------------
function hashcontents(filepath::String)
	try
		open(filepath) do f
			return sha2_256(f)
		end
	catch
		return sha2_256("")
	end
end

#Fast file matching algorithm.  Only checks dates & sizes.
#DEPRECATED
#   Cannot get copy operation to preserve time stamps.
#-------------------------------------------------------------------------------
function filesmatch_fast(src::String, dest::String)
	const tstamp_tol = 10 #seconds
	result = false

	try
		#Argh... Windows cp -p function does not copy time down to msec
		result = isfile(dest) && abs(mtime(src) - mtime(dest)) <= tstamp_tol && filesize(src) == filesize(dest)
	finally
		return result
	end
end

#SHA-based file check:
function filesmatch_SHA(src::String, dest::String)
	return hashcontents(src) == hashcontents(dest)
end

#Select file matching algorithm:
filesmatch = filesmatch_SHA
#filesmatch = filesmatch_fast

end #FileTools
