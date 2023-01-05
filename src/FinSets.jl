module FinSets
export FinSet, FinFunction, FinSetC

using ..Categories

const FinSet = AbstractSet

# Examples:
#
# A = Set([:x,:y,:z])
# B = Set([1,3,4])

struct FinFunction{S,T}
  dom::FinSet{S}
  codom::FinSet{T}
  values::AbstractDict{S,T}
end

# Examples:
#
# f = FinFunction(A, B, Dict(:x => 3, :y => 1, :z => 1))

isvalid(f::FinFunction) = dom == keys(f.values) && values(f.values) ⊆ f.codom

(f::FinFunction{S})(x::S) where {S} = f.values[x]

struct FinSetC <: Category{FinSet, FinFunction}
end

Categories.dom(::FinSetC, f::FinFunction) = f.dom

Categories.codom(::FinSetC, f::FinFunction) = f.codom

function Categories.compose(::FinSetC, f::FinFunction{S,T}, g::FinFunction{T,R}) where {S,T,R}
  @assert f.codom == g.dom
  FinFunction(f.dom, g.codom, Dict(x => g(f(x)) for x in f.dom))
end

function Categories.id(::FinSetC, X::FinSet{S}) where {S}
  FinFunction{S,S}(X,X,Dict(x => x for x in X))
end

end
