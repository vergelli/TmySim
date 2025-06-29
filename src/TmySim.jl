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

    Runs the sensor simulation, printing values to the console and visualizing them in real-time.

    # Effects
    - Creates a sensor configuration with a 100 Hz frequency.
    - Generates a reactive data stream using `Stream.jl`.
    - Subscribes a `CompletionActor` to print values to the console.
    - Subscribes a `PlotActor` to visualize the data with `GLMakie.jl`.
    - Waits for the simulation to complete (after 100 emissions).

    # Examples
    ```julia
    julia> run()
    # Prints sensor values and displays a real-time plot
    ```
    """
    function run()
        sensor = SensorConfig("temp", 160.0, 0.1, t -> 1 + sin(t))
        stream = make_stream(sensor)
        actor = Actors.CompletionActor{Float64}()
        visualize_stream(stream, 3.0, sensor.freq)
        subscribe!(get_observable(stream), actor)
        take!(actor.completion_channel)
    end
end

