include("input.jl")
include("dist_input.jl")

nusers{T<:Inputs}(inp::T) = inp.nusers
nitems{T<:Inputs}(inp::T) = inp.nitems

users_and_ratings{T<:Inputs}(inp::T, i::Int64) = _sprowsvals(get(inp.R), i)
all_user_ratings{T<:Inputs}(inp::T, i::Int64) = _spvals(get(inp.R), i)
all_users_rated{T<:Inputs}(inp::T, i::Int64) = _sprows(get(inp.R), i)

items_and_ratings{T<:Inputs}(inp::T, u::Int64) = _sprowsvals(get(inp.RT), u)
all_item_ratings{T<:Inputs}(inp::T, u::Int64) = _spvals(get(inp.RT), u)
all_items_rated{T<:Inputs}(inp::T, u::Int64) = _sprows(get(inp.RT), u)

function _sprowsvals{R<:InputRatings}(sp::R, col::Int64)
    s = SparseVector(sp[:,col])
    nonzeroinds(s), nonzeros(s)
end

function _sprows{R<:InputRatings}(sp::R, col::Int64)
    s = SparseVector(sp[:,col])
    nonzeroinds(s)
end

function _spvals{R<:InputRatings}(sp::R, col::Int64)
    s = SparseVector(sp[:,col])
    nonzeros(s)
end

function _sprowsvals(sp::ParallelSparseMatMul.SharedSparseMatrixCSC{Float64,Int64}, col::Int64)
    rowstart = sp.colptr[col]
    rowend = sp.colptr[col+1] - 1
    sp.rowval[rowstart:rowend], sp.nzval[rowstart:rowend]
end

function _sprows(sp::ParallelSparseMatMul.SharedSparseMatrixCSC{Float64,Int64}, col::Int64)
    rowstart = sp.colptr[col]
    rowend = sp.colptr[col+1] - 1
    sp.rowval[rowstart:rowend]
end

function _spvals(sp::ParallelSparseMatMul.SharedSparseMatrixCSC{Float64,Int64}, col::Int64)
    rowstart = sp.colptr[col]
    rowend = sp.colptr[col+1] - 1
    sp.nzval[rowstart:rowend]
end
