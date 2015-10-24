module StringTools

export parsestring

parsestring(::Type{Float64}, value::AbstractString) = float64(value)
parsestring(::Type{Float32}, value::AbstractString) = float32(value)
parsestring(::Type{Int64}, value::AbstractString) = int64(value)
parsestring(::Type{Int32}, value::AbstractString) = int32(value)

#Assumes "string" is how you create ASCIIString:
parsestring(::Type{ASCIIString}, value::AbstractString) = string(value)

end #StringTools
