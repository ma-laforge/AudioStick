#console.jl: Console tools.


#==Output
===============================================================================#

#Print with underline
function println_ul(text::String, ulchar = "─")
	underline = repeat(ulchar, length(text))
	println(text)
	println(underline)
end


#==Input
===============================================================================#

#Wrapper functions:
_parse(::Type{String}, value::AbstractString) = string(value)
_parse(::Type{T}, value::AbstractString) where T<:Real = parse(T, value)

#Prompt user for a value
function input(::Type{T}, prompt::String) where T
	print(prompt)
	return _parse(T, strip(readline(stdin)))
end

#Prompt user for a value, using default
function input(::Type{T}, prompt::String, default) where T
	println(prompt)
	print("[$default]: ")
	result = _parse(T, strip(readline(stdin)))
	if "" == result
		result = default
	end
	return result
end

#Prompt user for string:
input(prompt::String) = input(String, prompt)

pause() = input("Press enter to continue...")

#Last line
