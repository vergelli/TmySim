module Config

    @doc """
        Config

    A module for defining configuration structures for sensor simulation.

    This module provides `SensorConfig` for sensor-specific parameters and `SimConfig` for simulation-wide parameters.

    # Exports
    - `SensorConfig`: A structure for sensor configuration.
    - `SimConfig`: A structure for simulation configuration.
    """

    export SensorConfig, SimConfig

    @doc """
        SensorConfig

    A structure to hold configuration parameters for a sensor simulation.

    # Fields
    - `name::String`: The name of the sensor (e.g., "temp").
    - `freq::Float64`: The sampling frequency in Hz.
    - `noise::Float64`: The noise level for the sensor data.
    - `base_signal::Function`: A function defining the base signal (e.g., `t -> sin(t)`).
    """
    struct SensorConfig
        name::String
        freq::Float64
        noise::Float64
        base_signal::Function
    end

    @doc """
        SimConfig

    A structure to hold simulation-wide configuration parameters.

    # Fields
    - `sensor::SensorConfig`: The sensor configuration.
    - `window_size::Float64`: Size of the visualization window in seconds.
    - `print_values::Bool`: Whether to print sensor values to the console.
    """
    struct SimConfig
        sensor::SensorConfig
        window_size::Float64
        print_values::Bool
    end

end