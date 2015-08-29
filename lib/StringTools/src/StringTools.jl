module StringTools

export parsestring

parsestring(::Type{Float64}, value::String) = float64(value)
parsestring(::Type{Float32}, value::String) = float32(value)
parsestring(::Type{Int64}, value::String) = int64(value)
parsestring(::Type{Int32}, value::String) = int32(value)

#Assumes "string" is how you create ASCIIString:
parsestring(::Type{ASCIIString}, value::String) = string(value)

end #StringTools
