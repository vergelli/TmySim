module TmySim

    include("../config/Config.jl")
    include("Simulator.jl")
    include("Actors.jl")
    include("Stream.jl")
    include("Visualizer.jl")

    using Rocket
    using .Config
    using .Simulator
    using .Actors
    using .Stream
    using .Visualizer

    @doc """
        TmySim

    A module for orchestrating a sensor simulation using reactive programming with Rocket.jl.

    This module integrates `Config`, `Simulator`, `Actors`, `Stream`, and `Visualizer` to create and run a simulation that generates, processes, and visualizes sensor data in real-time.

    # Exports
    - `run`: The main function to start the simulation and visualization.
    """

    export run

    @doc """
        run()

    Runs the sensor simulation, optionally printing values to the console and visualizing them in real-time, using configurations defined in `SimConfig`.

    # Effects
    - Creates a `SimConfig` with a sensor configuration (160 Hz frequency), visualization window size, and printing option.
    - Generates a reactive data stream using `Stream.jl`.
    - Subscribes a `CompletionActor` to optionally print values to the console.
    - Subscribes a `PlotActor` to visualize the data with `GLMakie.jl`.
    - Runs indefinitely until interrupted with Ctrl+C.

    # Examples
    ```julia
    julia> run()
    # Displays a real-time plot with a 2-second window, no console printing
    ```
    """
    function run()

        sensor = SensorConfig("temp", 60.0, 0.1, t -> 1 + sin(t))
        config = SimConfig(sensor, 10.0, false)
        
        stream = make_stream(config.sensor)
        actor = Actors.CompletionActor{Float64}(config.print_values)
        subscription = subscribe!(get_observable(stream), actor)
        fig = visualize_stream(stream, config.window_size, config.sensor.freq)

        try
            while true
                sleep(0.1)
            end
        catch e
            if e isa InterruptException
                unsubscribe!(subscription)
                println("Simulación interrumpida")
                put!(actor.completion_channel, true)
                close(fig)
            else
                rethrow(e)
            end
        end
        take!(actor.completion_channel)
    end
end