using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

include("../src/TmySim.jl")
using .TmySim

TmySim.run()
