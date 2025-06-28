module Simulator

using Rocket
using ..Config

@doc """
    Simulator

A module for generating reactive sensor data streams using Rocket.jl.

This module provides functionality to create an observable 
that emits sensor readings based on a `SensorConfig`.

# Exports
- `make_sensor_source`: Creates a reactive data source for a sensor.
"""

    export make_sensor_source

    @doc"""
    make_sensor_source(cfg::SensorConfig)

    Creates a sensor source that emits readings based on the provided `SensorConfig`.
    """
    function make_sensor_source(cfg::SensorConfig)
        interval = 1 / cfg.freq
        source = Rocket.timer(0, round(Int, interval * 1000))
        source |> map(Float64, _ -> cfg.base_signal(time()) + cfg.noise * randn())
    end

end