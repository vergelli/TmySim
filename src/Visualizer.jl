module Visualizer

    using Rocket
    using GLMakie
    using ..Stream

    @doc """
        Visualizer

    A module for real-time visualization of sensor data streams using GLMakie.jl.

    This module provides `PlotActor` for updating a scrolling plot with sensor data and `visualize_stream` to start the visualization with a configurable window size.

    # Exports
    - `PlotActor`: An actor for updating a real-time plot.
    - `visualize_stream`: Starts visualization of a sensor stream.
    """

    export PlotActor, visualize_stream

    @doc """
        PlotActor{T} <: Rocket.Actor{T}

    An actor that updates a real-time scrolling plot with sensor data.

    # Fields
    - `values::Observable{Vector{T}}`: Observable holding the sensor values.
    - `times::Observable{Vector{Float64}}`: Observable holding the timestamps.
    - `window_size::Float64`: Size of the visualization window in seconds.
    - `freq::Float64`: Frequency of the sensor data in Hz.
    - `fig::Figure`: The GLMakie figure for the plot.
    - `ax::Axis`: The GLMakie axis for the plot.
    - `data_channel::Channel{T}`: Channel for receiving sensor values in the main thread.

    # Constructors
    - `PlotActor{T}(window_size::Float64, freq::Float64)`: Creates a new actor with an initialized plot and channel.
    """
    struct PlotActor{T} <: Rocket.Actor{T}
        values::Observable{Vector{T}}
        times::Observable{Vector{Float64}}
        window_size::Float64
        freq::Float64
        fig::Figure
        ax::Axis
        data_channel::Channel{T}
    end

    @doc """
        PlotActor{T}(window_size::Float64=1.0, freq::Float64=100.0) where T

    Creates a new `PlotActor` with an initialized GLMakie scrolling plot.

    # Parameters
    - `window_size::Float64`: Size of the visualization window in seconds (default: 1.0).
    - `freq::Float64`: Frequency of the sensor data in Hz (default: 100.0).

    # Returns
    - A `PlotActor{T}` instance with an initialized plot and channel.

    # Examples
    ```julia
    actor = PlotActor{Float64}(2.0, 100.0)  # 2-second window at 100 Hz
    ```
    """
    function PlotActor{T}(window_size::Float64=1.0, freq::Float64=100.0) where T
        values = Observable(T[])
        times = Observable(Float64[])
        fig = Figure(resolution=(800, 600))
        ax = Axis(fig[1, 1], title="Sensor Data", xlabel="Time (s)", ylabel="Value")
        lines!(ax, times, values, color=:blue)
        display(fig)
        data_channel = Channel{T}(Inf)

        @async begin
            while isopen(data_channel)
                try
                    value = take!(data_channel)
                    push!(values[], value)
                    push!(times[], time())
                    max_points = round(Int, window_size * freq)  # Calculate max points
                    if length(values[]) > max_points
                        popfirst!(values[])
                        popfirst!(times[])
                    end

                    if !isempty(times[])
                        t_max = times[][end]
                        t_min = t_max - window_size
                        ax.limits = ((t_min, t_max), (minimum(values[]) - 0.5, maximum(values[]) + 0.5))
                    end
                    notify(values)
                    notify(times)
                catch e
                    if e isa InvalidStateException
                        break
                    else
                        rethrow(e)
                    end
                end
            end
        end
        PlotActor{T}(values, times, window_size, freq, fig, ax, data_channel)
    end

    @doc """
        Rocket.on_next!(actor::PlotActor{T}, value::T) where T

    Sends a new sensor value to the data channel for processing in the main thread.

    # Parameters
    - `actor::PlotActor{T}`: The plot actor instance.
    - `value::T`: The new sensor value.

    # Effects
    - Sends the value to the actor's `data_channel` for main-thread processing.
    """
    function Rocket.on_next!(actor::PlotActor{T}, value::T) where T
        put!(actor.data_channel, value)
    end

    @doc """
        Rocket.on_complete!(actor::PlotActor)

    Signals that the visualization has completed.

    # Parameters
    - `actor::PlotActor`: The plot actor instance.

    # Effects
    - Closes the data channel and prints a completion message.
    """
    function Rocket.on_complete!(actor::PlotActor)
        close(actor.data_channel)
        println("Visualización completada")
    end

    @doc """
        Rocket.on_error!(actor::PlotActor, err)

    Handles errors during visualization.

    # Parameters
    - `actor::PlotActor`: The plot actor instance.
    - `err`: The error that occurred.

    # Effects
    - Closes the data channel and prints the error message.
    """
    function Rocket.on_error!(actor::PlotActor, err)
        close(actor.data_channel)
        println("Error en visualización: ", err)
    end

    @doc """
        visualize_stream(stream::SensorStream, window_size::Float64=1.0, freq::Float64=100.0)

    Starts real-time visualization of a sensor data stream with a configurable window size.

    # Parameters
    - `stream::SensorStream`: The sensor data stream to visualize.
    - `window_size::Float64`: Size of the visualization window in seconds (default: 1.0).
    - `freq::Float64`: Frequency of the sensor data in Hz (default: 100.0).

    # Returns
    - The `Figure` object for the plot.

    # Examples
    ```julia
    cfg = SensorConfig("temp", 100.0, 0.1, t -> 25 + sin(t))
    stream = make_stream(cfg)
    visualize_stream(stream, 2.0, 100.0)  # 2-second window
    ```
    """
    function visualize_stream(stream::SensorStream, window_size::Float64=1.0, freq::Float64=100.0)
        actor = PlotActor{Float64}(window_size, freq)
        subscribe!(get_observable(stream), actor)
        actor.fig
    end
end