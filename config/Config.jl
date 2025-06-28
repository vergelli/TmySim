module Config
export SensorConfig

    @doc"""
    Configuration module for sensor simulation.
    This module defines the `SensorConfig` struct, which holds the configuration
    for a sensor, including its name, frequency, noise level, and a base signal function.
    """
    struct SensorConfig
        name::String
        freq::Float64
        noise::Float64
        base_signal::Function
    end

end
