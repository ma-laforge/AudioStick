#files.jl: Tools to help with file manipulations


#==Helper Functions
===============================================================================#
#Compute hash key from file contents to verify file equivalence.
function hashcontents(filepath::String)
	try
		open(filepath) do f
			return sha2_256(f)
		end
	catch
		return sha2_256("")
	end
end

#SHA-based file check:
function filesmatch_SHA(src::String, dest::String)
	return hashcontents(src) == hashcontents(dest)
end

#Fast file matching algorithm.  Only checks dates & sizes.
#DEPRECATED
#   Cannot get copy operation to preserve time stamps.
function filesmatch_fast(src::String, dest::String)
	tstamp_tol = 10 #seconds
	result = false

	try
		#Argh... Windows cp -p function does not copy time down to msec
		result = isfile(dest) && abs(mtime(src) - mtime(dest)) <= tstamp_tol && filesize(src) == filesize(dest)
	finally
		return result
	end
end


#==Helper Functions
===============================================================================#
#Generate output file name from source filename
#(Strip out leading numbers, spaces, -, & _ from source basename)
function cleannamme(src::String)
	pat = r"^[0-9|\-|_| ]*(.*)$"

	#Get simplified filename:
	m = match(pat, src)
	result = strip(m.captures[1])
	if length(result) < 1
		result = src #Don't simplify
	end
	return result
end

#Last line
