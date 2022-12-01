module Graphs
export SchGraph, path_graph, star_graph

using ..Categories
using ..Functors
using ..FinCats
using ..FinSets
using ..Diagrams

const SchGraph = FinCat(Set([:E,:V]), Dict(:src => (:E,:V), :tgt => (:E,:V)))

function path_graph(n::Int)
  V,E = Set(1:n), Set(1:(n-1))
  Diagram{Symbol, FinSet, FinFunction, FinSetC}(
    SchGraph,
    FinSetC(),
    Dict(:V => V, :E => E),
    Dict(
      :src => FinFunction(E, V, Dict(e => e for e in E)),
      :tgt => FinFunction(E, V, Dict(e => e+1 for e in E))
    )
  )
end

function star_graph(n::Int)
  V,E = Set(1:(n+1)), Set(1:n)
  Diagram{Symbol, FinSet, FinFunction, FinSetC}(
    SchGraph,
    FinSetC(),
    Dict(:V => V, :E => E),
    Dict(
      :src => FinFunction(E, V, Dict(e => 1 for e in E))
      :tgt => FinFunction(E, V, Dict(e => e+1 for e in E))
    )
  )
end

end
