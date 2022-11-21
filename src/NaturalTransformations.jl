module NaturalTransformations

using ..Categories
using ..Functors

abstract type NaturalTransformation{C<:Category,D<:Category} end

function component(::NaturalTransformation{C,D}, x::ObC)::HomD where
    {ObC, HomC, ObD, HomD, C<:Category{ObC, HomC}, D<:Category{ObD, HomD}}
  error("unimplemented")
end

struct FunctorCat{C<:Category,D<:Category} <: Category{Functor{C,D}, NaturalTransformation{C,D}}
  c::C
  d::D
end

Categories.dom(::FunctorCat{C,D}, ::NaturalTransformation{C,D}) where {C,D} = error("unimplemented")
Categories.codom(::FunctorCat{C,D}, ::NaturalTransformation{C,D}) where {C,D} = error("unimplemented")

struct ComposedNT{C<:Category, D<:Category,
                  A<:NaturalTransformation{C,D},B<:NaturalTransformation{C,D}} <: NaturalTransformation{C,D}
  cats::FunctorCat{C,D}
  α::A
  β::B
end

Categories.dom(c::FunctorCat, γ::ComposedNT) = dom(c, γ.α)
Categories.codom(c::FunctorCat, γ::ComposedNT) = codom(c, γ.β)

function Categories.compose(cats::FunctorCat, α::NaturalTransformation, β::NaturalTransformation)
  @assert codom(cats, α) == dom(cats, β)
  ComposedNT(cats, α, β)
end

function component(γ::ComposedNT{C,D}, x) where {C<:Category,D<:Category}
  d = γ.cats.d
  compose(d, component(γ.α, x), component(γ.β, x))
end

struct IdTransformation{C<:Category, D<:Category} <: NaturalTransformation{C,D}
  f::Functor{C,D}
end

Categories.id(::FunctorCat, f::Functor) = IdTransformation(f)

end
