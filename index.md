---
layout: default
title: Home
---

# Gravity-Lang

[![Build Status](https://github.com/dill-lk/Gravity-Lang/actions/workflows/build.yml/badge.svg)](https://github.com/dill-lk/Gravity-Lang/actions)
[![License](https://img.shields.io/github/license/dill-lk/Gravity-Lang)](LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/dill-lk/Gravity-Lang)](https://github.com/dill-lk/Gravity-Lang/releases)

**A domain-specific language for gravitational physics simulations**

Write physics simulations in readable, intuitive syntax. Describe planets, stars, rockets, and probes naturally, and let Gravity-Lang handle the complex numerical integration.

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [0, 1.022, 0][km/s]

simulate orbit in 0..720 dt 3600[s] integrator rk45 {
    grav all
    print Moon.position
}
```

## Features

- **Intuitive DSL** - Read like English, write like physics
- **High Performance** - Native C++ execution, no runtime overhead
- **Cross-Platform** - Linux, macOS, and Windows support
- **Multiple Integrators** - euler, verlet, leapfrog, rk4, yoshida4, rk45
- **Rich Physics** - Newtonian gravity, MOND, GR corrections, rocketry
- **Easy Output** - CSV telemetry, animated SVG plots, checkpointing

## Quick Start

### Installation

Download pre-built binaries from the [latest release](https://github.com/dill-lk/Gravity-Lang/releases):

**Linux / macOS:**
```bash
tar -xzf gravity-linux-x64.tar.gz
cd gravity-linux-x64
./gravity run examples/moon_orbit.gravity
```

**Windows:**
```powershell
Expand-Archive gravity-windows-x64.zip .
cd gravity-windows-x64
.\gravity.exe run examples\moon_orbit.gravity
```

### Build from Source

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j
./build/gravity run examples/moon_orbit.gravity
```

## Documentation

- [Getting Started Guide](docs/README.md)
- [Tutorial 1: Your First Orbit](docs/tutorials/01-first-orbit.md)
- [Tutorial 2: Multi-Body Systems](docs/tutorials/02-multi-body.md)
- [Tutorial 3: Rocket Trajectories](docs/tutorials/03-rocket-trajectories.md)
- [Language Reference](docs/language-reference.md)
- [Examples Gallery](docs/examples-gallery.md)

## Examples

### Earth-Moon System
```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [0, 1.022, 0][km/s]

simulate orbit in 0..720 dt 3600[s] integrator rk4 {
    grav all
    print Moon.position
}
```

### Rocket Launch
```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
rocket Falcon at [0,6371000,0][m] mass 30000[kg] radius 3[m]
Falcon.fuel_mass = 420000[kg]
Falcon.burn_rate = 2500[kg/s]
Falcon.isp = 282[s]

simulate launch in 0..500 dt 1[s] integrator rk45 {
    Earth pull Falcon
    plot on body Falcon
}
```

### Galaxy Collision
```gravity
sphere CoreA at [-5e20,0,0][m] mass 1e41[kg] radius 1e19[m]
CoreA.velocity = [0, 1e5, 0][m/s]

sphere CoreB at [5e20,0,0][m] mass 8e40[kg] radius 9e18[m]
CoreB.velocity = [0, -1e5, 0][m/s]

# Add multiple stars...

simulate collision in 0..5000 dt 1e10[s] integrator leapfrog {
    grav all
    dump_all to "collision.csv" frequency 10
}
```

## Contributing

We welcome contributions! See our [Contributing Guide](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md).

- [Report a Bug](https://github.com/dill-lk/Gravity-Lang/issues/new?template=bug_report.md)
- [Request a Feature](https://github.com/dill-lk/Gravity-Lang/issues/new?template=feature_request.md)
- [Ask a Question](https://github.com/dill-lk/Gravity-Lang/issues/new?template=question.md)
- [Start a Discussion](https://github.com/dill-lk/Gravity-Lang/discussions)

## Community

- **GitHub Issues**: [Bug reports and feature requests](https://github.com/dill-lk/Gravity-Lang/issues)
- **GitHub Discussions**: [Questions and community chat](https://github.com/dill-lk/Gravity-Lang/discussions)
- **Examples**: Browse the [`examples/`](https://github.com/dill-lk/Gravity-Lang/tree/main/examples) directory

## License

Gravity-Lang is open-source software. See the [LICENSE](LICENSE) file for details.

---

Built with ❤️ for the physics simulation community
