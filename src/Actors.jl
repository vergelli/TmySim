module Actors

    using Rocket

    @doc """
        Actors

    A module for defining actors that handle observable events.

    This module provides `CompletionActor`, a custom actor that processes emitted values, completion events, and errors from a `Rocket.jl` observable, with support for signaling completion via a `Channel`.

    # Exports
    - `CompletionActor`: An actor for handling observable events.
    """

    export CompletionActor

    @doc """
        CompletionActor{T} <: Rocket.Actor{T}

    A custom actor for handling events from a `Rocket.jl` observable, with a channel to signal completion and configurable printing.

    # Fields
    - `completion_channel::Channel{Bool}`: A channel that signals when the observable completes or errors.
    - `print_values::Bool`: Whether to print values to the console.

    # Constructors
    - `CompletionActor{T}(print_values::Bool=true)`: Creates a new actor with an initialized `Channel{Bool}` and printing configuration.

    # Type Parameters
    - `T`: The type of values emitted by the observable.
    """
    struct CompletionActor{T} <: Rocket.Actor{T}
        completion_channel::Channel{Bool}
        print_values::Bool
        CompletionActor{T}(print_values::Bool=true) where T = new{T}(Channel{Bool}(1), print_values)
    end

    @doc """
        Rocket.on_next!(actor::CompletionActor{T}, value::T) where T

    Handles a new value emitted by the observable by optionally printing it to the console.

    # Parameters
    - `actor`: The `CompletionActor` instance.
    - `value`: The emitted value of type `T`.

    # Effects
    - If `actor.print_values` is `true`, prints the value to the console.
    """
    function Rocket.on_next!(actor::CompletionActor{T}, value::T) where T
        if actor.print_values
            println(value)
        end
    end

    @doc """
        Rocket.on_complete!(actor::CompletionActor)

    Signals that the observable has completed by printing a message and putting `true` into the `completion_channel`.

    # Parameters
    - `actor`: The `CompletionActor` instance.
    """
    function Rocket.on_complete!(actor::CompletionActor)
        println("completed")
        put!(actor.completion_channel, true)
    end

    @doc """
        Rocket.on_error!(actor::CompletionActor, err)

    Handles an error emitted by the observable by printing the error message and putting `true` into the `completion_channel`.

    # Parameters
    - `actor`: The `CompletionActor` instance.
    - `err`: The error that occurred.
    """
    function Rocket.on_error!(actor::CompletionActor, err)
        println("Error: ", err)
        put!(actor.completion_channel, true)
    end
end