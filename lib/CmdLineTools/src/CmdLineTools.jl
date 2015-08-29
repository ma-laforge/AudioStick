#CmdLineTools.jl
#Provides tools to help with command-line interactions.

module CmdLineTools

export input, pause
export println_ul

using StringTools


# Main tools
################################################################################

# Print with underline
#-------------------------------------------------------------------------------
function println_ul(text, ulchar = "-")
	underline = prod(fill(ulchar, length(text)))
	println(text)
	println(underline)
end

# Prompt user for a value
#-------------------------------------------------------------------------------
function input{T}(::Type{T}, prompt::String)
	print(prompt)
	return parsestring(T, strip(readline(STDIN)))
end

# Prompt user for a value, using default
#-------------------------------------------------------------------------------
function input{T}(::Type{T}, prompt::String, default)
	println(prompt)
	print("[$default]: ")
	result = parsestring(T, strip(readline(STDIN)))
	if "" == result
		result = default
	end
	return result
end

# Prompt user for string:
input(prompt::String) = input(ASCIIString, prompt)

pause() = input("Press enter to continue...")

end #CmdLineTools
