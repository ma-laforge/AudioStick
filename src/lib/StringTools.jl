module StringTools

export parsestring

parsestring{T<:Real}(::Type{T}, value::String) = parse(T, value)
parsestring(::Type{String}, value::String) = String(value)

end #StringTools
