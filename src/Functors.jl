module Functors
export Functor, ob_map, hom_map, KittenC

using ..Categories

# Basic definition
##################

abstract type Functor{C<:Category, D<:Category} end

function ob_map(F::Functor{C,D}, x::ObC)::ObD where {ObC, ObD, C<:Category{ObC}, D<:Category{ObD}}
  error("unimplemented")
end

function hom_map(F::Functor{C,D}, f::HomC)::HomD where
    {ObC, HomC, ObD, HomD, C<:Category{ObC, HomC}, D<:Category{ObD, HomD}}
  error("unimplemented")
end

# Laws
######

# dom(d, hom_map(F, f)) = ob_map(F, dom(c, f))
# codom(d, hom_map(F, f)) = ob_map(F, codom(c, f))
# compose(d, hom_map(F, f), hom_map(F, g)) == hom_map(F, compose(c, f, g))
# id(d, ob_map(F, x)) == ob_map(F, id(c, x))

# KittenC
#########

# KittenC is the category of Julia-implemented categories and functors

struct KittenC <: Category{Category, Functor}
end

function Categories.dom(::KittenC, F::Functor{C,D})::C where {C,D}
  error("unimplemented")
end

function Categories.codom(::KittenC, F::Functor{C,D})::D where {C,D}
  error("unimplemented")
end

struct ComposedFunctor{C<:Category, D<:Category, E<:Category} <: Functor{C, E}
  F::Functor{C,D}
  G::Functor{D,E}
end

ob_map(FG::ComposedFunctor, x) = ob_map(FG.G, ob_map(FG.F, x))
hom_map(FG::ComposedFunctor, f) = hom_map(FG.G, hom_map(FG.F, f))

Categories.dom(c::KittenC, FG::ComposedFunctor) = dom(c, FG.F)
Categories.codom(c::KittenC, FG::ComposedFunctor) = codom(c, FG.G)

function Categories.compose(::KittenC, F::Functor, G::Functor)
  ComposedFunctor(F,G)
end

struct IdFunctor{C<:Category}
  c::C
end

ob_map(I::IdFunctor, x) = x
hom_map(I::IdFunctor, f) = f

Categories.dom(::KittenC, F::IdFunctor) = F.c
Categories.codom(::KittenC, F::IdFunctor) = F.c

Categories.id(::KittenC, c::Category) = IdFunctor(c)

end
