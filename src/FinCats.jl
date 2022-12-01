module FinCats
export FinCatMorphism, FinCat

using ..Categories

struct FinCatMorphism{L}
  dom::L
  codom::L
  path::Vector{L}
end

struct FinCat{L} <: Category{L, FinCatMorphism{L}}
  objects::Set{L}
  homs::Dict{L, Tuple{L, L}}
end

# Example
#
# FinCat(Set([:a,:b,:c]), Dict(:f => (:a, :b), :g => (:b, :c), :h => (:c, :a)))

function isvalid(c::FinCat{L}, f::FinCatMorphism{L}) where {L}
  for i in 1:(length(f.path) - 1)
    c.homs[f.path[i]][2] == c.homs[f.path[i+1]][1] || return false
  end
  return true
end

Categories.dom(::FinCat{L}, f::FinCatMorphism{L}) where {L} = f.dom

Categories.codom(::FinCat{L}, f::FinCatMorphism{L}) where {L} = f.codom

function Categories.compose(::FinCat{L}, f::FinCatMorphism{L}, g::FinCatMorphism{L}) where {L}
  @assert f.codom == g.dom
  FinCatMorphism(f.dom, g.codom, L[f.path; g.path])
end

Categories.id(::FinCat{L}, x::L) where {L} = FinCatMorphism{L}(x,x,L[])

end
