# Gravity-Lang

[![Build Status](https://github.com/dill-lk/Gravity-Lang/actions/workflows/build.yml/badge.svg)](https://github.com/dill-lk/Gravity-Lang/actions)
[![License](https://img.shields.io/github/license/dill-lk/Gravity-Lang)](LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/dill-lk/Gravity-Lang)](https://github.com/dill-lk/Gravity-Lang/releases)
[![C++](https://img.shields.io/badge/C%2B%2B-17%2F20-blue.svg)](https://isocpp.org/)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey)](https://github.com/dill-lk/Gravity-Lang)

![Gravity-Lang](https://github.com/user-attachments/assets/b693ef5c-b202-4444-81c8-7d2960018253)

**Gravity-Lang** is a domain-specific language for writing and running gravitational physics simulations. Describe planets, stars, rockets, and probes in plain readable syntax, then let the interpreter handle the physics — from simple two-body orbits to full N-body galaxy collisions and rocket ascent trajectories.

The interpreter is built in native C++ for performance, supports multiple numerical integrators, and outputs CSV telemetry and animated SVG plots without any external dependencies.

---

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Build](#build)
  - [Run your first simulation](#run-your-first-simulation)
- [Writing Gravity-Lang scripts](#writing-gravity-lang-scripts)
  - [Declaring bodies](#declaring-bodies)
  - [Setting velocities](#setting-velocities)
  - [Gravity rules](#gravity-rules)
  - [Running a simulation](#running-a-simulation)
  - [Outputs and diagnostics](#outputs-and-diagnostics)
- [Examples](#examples)
- [CLI reference](#cli-reference)
- [Testing](#testing)
- [Tips and common pitfalls](#tips-and-common-pitfalls)

---

## Features

- **Readable DSL** — scripts read like plain descriptions of a physical scenario.
- **Multiple integrators** — `euler`, `verlet`, `leapfrog`, `rk4`, `yoshida4`, `rk45` (adaptive).
- **Flexible gravity models** — Newtonian, MOND, and GR correction modes.
- **Rocketry support** — fuel mass, burn rate, ISP, drag, throttle control, gravity turns, and staging events.
- **N-body simulations** — `grav all` enables full mutual attraction across every declared body.
- **Data export** — per-body CSV telemetry, full-state dumps, and native C++ animated SVG plots.
- **Checkpointing** — save and resume simulation state at any step.
- **Multithreading** — optional parallel force accumulation via `threads N|auto`.
- **Physics monitoring** — track energy, momentum, and angular momentum conservation.

---

## Getting Started

### Build

Gravity-Lang requires CMake and a C++17 compiler (GCC or Clang on Linux/macOS, MSVC on Windows).

```bash
cmake -S . -B build
cmake --build build -j
```

This produces two binaries inside `build/`:

| Binary | Purpose |
|---|---|
| `gravity` | Runs and interprets `.gravity` scripts |
| `gravityc` | Emits C++ source from a `.gravity` script |

> **Windows note:** unsigned executables may be blocked by SmartScreen. If you see "Access is denied", right-click the EXE → Properties → Unblock, or run `Unblock-File gravity.exe` in PowerShell.

### Run your first simulation

```bash
./build/gravity run examples/moon_orbit.gravity
```

This simulates the Earth–Moon system for one lunar month and prints the Moon's position at each hour-long step. Output CSV data is written to `moon_orbit.csv`.

---

## Writing Gravity-Lang scripts

A `.gravity` script has four main parts: declare bodies, configure interactions, add outputs, and run the simulation.

### Declaring bodies

Three body types are available: `sphere`, `probe`, and `rocket`.

```gravity
sphere Earth at [0,0,0][m]       mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon  at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
rocket Rocket at [0,6371000,0][m] mass 30000[kg]   radius 3[m]
```

- `fixed` keeps a body stationary (useful for a central reference body like Earth).
- Coordinates accept unit tags: `[m]`, `[km]`.
- Mass is always in `[kg]`; radius accepts `[m]` or `[km]`.

### Setting velocities

```gravity
Moon.velocity = [0, 1.022, 0][km/s]
```

Velocity components are `[x, y, z]` and accept `[m/s]` or `[km/s]`.

### Gravity rules

```gravity
# Apply mutual gravity between all bodies
grav all

# Or specify explicit targets (comma-separated)
Earth pull Moon
MilkyWay_Core pull StarA1, StarA2, StarA3
```

### Running a simulation

```gravity
simulate orbit in 0..720 dt 3600[s] integrator rk45 {
    grav all
    print Moon.position
}
```

- `0..720` means 720 steps (not 720 seconds — total time is `steps × dt`).
- `dt 3600[s]` sets each step to one hour.
- The integrator can be `euler`, `verlet`, `leapfrog`, `rk4`, `yoshida4`, or `rk45`.

### Outputs and diagnostics

```gravity
# Print orbital elements at any point
orbital_elements Moon around Earth

# Stream position data to CSV
observe Moon.position to "artifacts/moon.csv" frequency 1

# Dump all body states every 10 steps
dump_all to "artifacts/all.csv" frequency 10

# Generate an animated SVG telemetry plot
plot on body Moon

# Save a checkpoint you can resume later
save "artifacts/checkpoint.json" frequency 50
```

---

## Examples

The `examples/` directory contains ready-to-run scripts:

| Script | What it demonstrates |
|---|---|
| `moon_orbit.gravity` | Earth–Moon two-body orbit |
| `rocket_testing.gravity` | Two-stage rocket ascent with gravity turn |
| `galaxy_collision.gravity` | Two-galaxy N-body collision |
| `binary_star.gravity` | Binary star system |
| `solar_system.gravity` | Multi-planet solar system |
| `all_features_one.gravity` | Full feature showcase in a single script |
| `integrator_comparison.gravity` | Side-by-side integrator accuracy comparison |
| `mond_vs_newtonian.gravity` | MOND vs. Newtonian gravity comparison |

Run any example with:

```bash
./build/gravity run examples/<script>.gravity
```

---

## CLI reference

```bash
# Run a simulation
./build/gravity run examples/moon_orbit.gravity

# Validate a script without running physics
./build/gravity check examples/moon_orbit.gravity --strict

# Dump all body states to CSV on every step
./build/gravity run examples/moon_orbit.gravity --dump-all=artifacts/dump.csv

# Resume from a previously saved checkpoint
./build/gravity run examples/moon_orbit.gravity --resume artifacts/checkpoint.json

# List all supported runtime features
./build/gravity list-features

# Show help
./build/gravity --help

# Emit C++ source from a Gravity script
./build/gravityc examples/moon_orbit.gravity --emit moon.cpp --strict
./build/gravityc --help
```

---

## Testing

```bash
cd build
ctest --output-on-failure
```

For optional NASA-reference accuracy checks against Earth–Moon and Mercury orbital data:

```bash
./tools/validate_against_nasa.sh --strict
```

---

## Tips and common pitfalls

- **`orbital_elements` needs a center body:** always write `orbital_elements Moon around Earth`, not just `orbital_elements Moon`.
- **Step count vs. elapsed time:** `simulate in 0..N` runs `N` steps. Total simulated time = `N × dt`. Use a larger `dt` for long spans rather than a huge step count.
- **Fuel mass adds to total mass:** `Body.fuel_mass` is added on top of the declared body mass (wet mass = declared mass + fuel mass).
- **`grav all` is global:** it applies mutual attraction across all declared bodies regardless of where it appears in the script.
- **`plot on` defaults to `Rocket`:** for other body names, use `plot on body <Name>`.
- **Step range limits:** keep `END - START` within 32-bit integer bounds; use a larger `dt` for very long simulations instead of a large step count.

---

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:

- Reporting bugs
- Suggesting features
- Submitting pull requests
- Coding standards and testing requirements

We follow a [Code of Conduct](CODE_OF_CONDUCT.md) to ensure a welcoming community for all contributors.

---

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

---

## Acknowledgments

Gravity-Lang is created and maintained by [@dill-lk](https://github.com/dill-lk).

This project is an experimental exploration of domain-specific languages for scientific computing and physics simulation.

For questions, discussions, or to share your simulations, feel free to [open an issue](https://github.com/dill-lk/Gravity-Lang/issues) or start a [discussion](https://github.com/dill-lk/Gravity-Lang/discussions).
