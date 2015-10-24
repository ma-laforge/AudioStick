#EasyConf: Interface to read/write simple configuration files

module EasyConf

export EasyConfFile
export getvalue


# Types
################################################################################

type ConfigDict
	d::Dict{AbstractString, Any}
end
ConfigDict() = ConfigDict(Dict{AbstractString, Any}())

type EasyConfFile
	s::IOStream
end


# Read/Write functions
################################################################################

#-------------------------------------------------------------------------------
function Base.open(::Type{EasyConfFile}, path::AbstractString, args...)
	s = open(path, args...)
	return EasyConfFile(s)
end

#-------------------------------------------------------------------------------
Base.close(f::EasyConfFile) = close(f.s)

#-------------------------------------------------------------------------------
function Base.read(f::EasyConfFile)
	cfg = ConfigDict()

	for line in eachline(f.s)
		elements = split(line, "=")
		if length(elements) != 2
			continue
		end
		cfg[strip(elements[1])] = strip(elements[2])
	end

	return cfg
end

#-------------------------------------------------------------------------------
function Base.write(f::EasyConfFile, cfg::ConfigDict)
	for (k,v) in cfg.d
		write(f.s, "$k = $v")
	end
end

#-------------------------------------------------------------------------------
function Base.read(::Type{EasyConfFile}, path::AbstractString)
	local f, cfg
	try
		f = open(EasyConfFile, path, "r")
	catch
		#Cannot open; Return empty dictionary
		return ConfigDict()
	end

	try
		cfg = read(f)
	finally
		close(f)
	end
	return cfg
end

#-------------------------------------------------------------------------------
function Base.write(::Type{EasyConfFile}, path::AbstractString, cfg::ConfigDict)
	f = open(EasyConfFile, path, "w")
	try
		write(f, cfg)
	finally
		close(f)
	end
end


# Other tools
################################################################################

Base.setindex!(c::ConfigDict, v, k::AbstractString) = c.d[k] = v
Base.getindex(c::ConfigDict, k::AbstractString) = c.d[k]

# Safe means of reading from ConfigDict
#-------------------------------------------------------------------------------
function getvalue(c::ConfigDict, k::AbstractString, vdefault)
	local result
	try
		result = c[k]
	catch
		return vdefault
	end
	return result
end

end #EasyConf


