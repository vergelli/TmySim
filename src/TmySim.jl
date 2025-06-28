module TmySim

    include("../config/Config.jl")
    include("Simulator.jl")

    using Rocket

    using .Config
    using .Simulator

    function run()
        sensor = SensorConfig("temp", 60.0, 0.1, t -> 25 + sin(t))
        src = make_sensor_source(sensor)# |> take(10)
        subscribe!(src, x -> println("Valor: ", x))
        sleep(10)
    end

end
