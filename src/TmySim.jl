module TmySim
@doc """
    TmySim

A module for orchestrating a sensor simulation using reactive programming with Rocket.jl.

This module integrates `Config`, `Simulator`, and `Actors` to create 
and run a simulation that generates and processes sensor data.
"""

    include("../config/Config.jl")
    include("Simulator.jl")
    include("Actors.jl")

    using Rocket

    using .Config
    using .Simulator
    using .Actors

    function run()
        sensor = SensorConfig("temp", 100.0, 0.1, t -> 25 + sin(t))
        src = make_sensor_source(sensor)
        actor = Actors.CompletionActor{Float64}()
        subscribe!(src, actor)
        take!(actor.completion_channel)
    end
end