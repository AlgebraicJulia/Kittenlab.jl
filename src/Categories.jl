module Categories
export Category, dom, codom, compose, id

abstract type Category{Ob, Hom} end

# Abstract functions

function dom(c::Category{Ob, Hom}, f::Hom)::Ob where {Ob, Hom}
  error("unimplemented")
end

function codom(c::Category{Ob, Hom}, f::Hom)::Ob where {Ob, Hom}
  error("unimplemented")
end

function compose(c::Category{Ob, Hom}, f::Hom, g::Hom)::Hom where {Ob, Hom}
  @assert codom(f) == dom(g)
  error("unimplemented")
end

function id(c::Category{Ob, Hom}, x::Ob)::Hom where {Ob, Hom}
  error("unimplemented")
end

# Laws
######

# compose(c, f, compose(c, g, h)) == compose(c, compose(c, f, g), h)
# compose(c, f, id(x)) == f
# compsoe(c, id(x), f) == f

end
