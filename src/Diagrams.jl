module Diagrams
export Diagram

using ..Categories
using ..Functors
using ..FinCats

struct Diagram{L, Ob, Hom, C<:Category{Ob, Hom}} <: Functor{FinCat{L}, C}
  diagram::FinCat{L}
  base::C
  ob_map::Dict{L, Ob}
  hom_map::Dict{L, Hom}
end

Categories.dom(::Cat, d::Diagram) = d.diagram

Categories.codom(::Cat, d::Diagram) = d.base

Functors.ob_map(d::Diagram{L}, x::L) where {L} = d.ob_map[x]

function Functors.hom_map(d::Diagram{L}, x::FinCatMorphism{L}) where {L}
  foldl((f,g) -> compose(d.base, f, g), map(l -> d.hom_map[l], x.path); init=id(d.base, ob_map(d, x.dom)))
end

end
