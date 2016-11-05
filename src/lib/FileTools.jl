#FileTools.jl
#Tools to help with file manipulations

module FileTools

export fastsync_sourcefile


# Types
################################################################################


# Functions
################################################################################

# Fast file matching algorithm.  Only checks dates & sizes.
#-------------------------------------------------------------------------------
function filesmatch_fast(src::AbstractString, dest::AbstractString)
	const tstamp_tol = 10 #seconds
	result = false

	try
		#Argh... Windows cp -p function does not copy time down to msec
		result = isfile(dest) && abs(mtime(src) - mtime(dest)) <= tstamp_tol && filesize(src) == filesize(dest)
	finally
		return result
	end
end

#Synchronize a file with its source (not a 2-way sync.)
#Fast sync: does not generate a full hash mapping (ex: SHA-1).
#Returns true if a copy was needed to synchronize files.
#-------------------------------------------------------------------------------
function fastsync_sourcefile(src::AbstractString, dest::AbstractString)
	filesmatch = false

	if (!isfile(src))
		warn("Missing file: $src")
		return false
	elseif filesmatch_fast(src, dest)
		return true
	end

#	cp(src, dest) #Won't preserve modified timestamps.
	run(`cp $src $dest -p`)

	if !filesmatch_fast(src, dest)
		warn("Synchronization failed: $src -> $dest.")
		return false
	end

	return true
end

end #FileTools
