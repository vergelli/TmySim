 
# TmySim

**WiP**: A project for simulating sensor data.

## Prerequisites

- **Julia**: tested with **1.11.2**
- **Dependencies**:
  - `Rocket.jl`.
  - `GLMakie.jl`

Install dependencies by running:
```bash
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

## How to Run

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd TmySim
   ```

2. Activate the project environment and run the simulation:
   ```bash
   julia --project=. ./app/run.jl
   ```

This will execute the sensor simulation, printing sensor values to the console.

## Notes

- Real-time visualization with `Makie.jl` is under dev.
- Contributions and feedback are welcome.