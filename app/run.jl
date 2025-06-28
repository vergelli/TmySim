#& Entry point for the TmySim

#& This script activates the project environment, 
#& includes the TmySim module, and runs the simulation.

#*  Usage:
#*    julia ./app/run.jl

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

include("../src/TmySim.jl")
using .TmySim

TmySim.run()