module Actors
@doc """
        Actors

    A module for defining actors that handle observable events.

    This module provides `CompletionActor`, a custom actor that 
    processes emitted values, completion events, and errors from a `Rocket.jl` 
    observable, with support for signaling completion via a `Channel`.

    # Exports
    - `CompletionActor`: An actor for handling observable events.
    """
    using Rocket

    export CompletionActor

    @doc """
            CompletionActor{T} <: Rocket.Actor{T}

        A custom actor for handling events from a `Rocket.jl` observable, 
        with a channel to signal completion.

        # Fields
        - `completion_channel::Channel{Bool}`: A channel that signals 
        when the observable completes or errors.

        # Constructors
        - `CompletionActor{T}()`: Creates a new actor with 
        an initialized `Channel{Bool}` of size 1.

        # Type Parameters
        - `T`: The type of values emitted by the observable.
        """
    struct CompletionActor{T} <: Rocket.Actor{T}
        completion_channel::Channel{Bool}
        CompletionActor{T}() where T = new{T}(Channel{Bool}(1))
    end

    @doc """
        Rocket.on_next!(actor::CompletionActor{T}, value::T) where T

    Handles a new value emitted by the observable by printing it to the console.

    # Parameters
    - `actor`: The `CompletionActor` instance.
    - `value`: The emitted value of type `T`.
    """
    function Rocket.on_next!(actor::CompletionActor{T}, value::T) where T
        println(value)
    end

    @doc """
        Rocket.on_complete!(actor::CompletionActor)
    Signals that the observable has completed by printing a message
    and putting `true` into the `completion_channel`.
    # Parameters
    - `actor`: The `CompletionActor` instance.
    """
    function Rocket.on_complete!(actor::CompletionActor)
        println("completed")
        put!(actor.completion_channel, true)
    end

    @doc """
        Rocket.on_error!(actor::CompletionActor, err)
    Handles an error emitted by the observable by printing the error message
    and putting `true` into the `completion_channel`.
    # Parameters
    - `actor`: The `CompletionActor` instance.
    - `err`: The error that occurred.
    """
    function Rocket.on_error!(actor::CompletionActor, err)
        println("Error: ", err)
        put!(actor.completion_channel, true)
    end

end
