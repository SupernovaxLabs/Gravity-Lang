# Gravity-Lang Documentation

Welcome to the comprehensive documentation for Gravity-Lang, a domain-specific language for gravitational physics simulations.

## Quick Links

- [Getting Started](getting-started.md)
- [Language Reference](language-reference.md)
- [Tutorials](tutorials/)
  - [Beginner: Your First Orbit](tutorials/01-first-orbit.md)
  - [Intermediate: Multi-Body Systems](tutorials/02-multi-body.md)
  - [Advanced: Rocket Trajectories](tutorials/03-rocket-trajectories.md)
- [Examples Gallery](examples-gallery.md)
- [API Reference](api-reference.md)
- [Performance Guide](performance-guide.md)

## What is Gravity-Lang?

Gravity-Lang is a high-level DSL designed to make gravitational physics simulations accessible and readable. Instead of writing complex numerical integration code, you describe the physical scenario in plain syntax:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [0, 1.022, 0][km/s]

simulate orbit in 0..720 dt 3600[s] integrator rk45 {
    grav all
    print Moon.position
}
```

## Key Features

- **Intuitive Syntax** - Read like English, write like physics
- **Performance** - Native C++ execution with no runtime overhead
- **Flexibility** - Multiple integrators, gravity models, and output formats
- **Portability** - Cross-platform support (Linux, macOS, Windows)
- **Extensibility** - Easy to add new physics models and features

## Documentation Structure

### For Beginners

Start with [Getting Started](getting-started.md) to learn the basics:
1. Installation and setup
2. Your first simulation
3. Understanding the output
4. Basic DSL syntax

### For Intermediate Users

Explore the [Language Reference](language-reference.md) for:
- Complete DSL syntax
- All available commands and options
- Unit system and conversions
- Integrator comparison

### For Advanced Users

Check out advanced topics:
- [Performance Guide](performance-guide.md) - Optimization techniques
- [Extending Gravity-Lang](extending.md) - Add custom physics
- [Compiler Architecture](architecture.md) - Internal design

## Community

- [Contributing Guide](../CONTRIBUTING.md)
- [Contributors](../CONTRIBUTORS.md)
- [Code of Conduct](../CODE_OF_CONDUCT.md)
- [GitHub Issues](https://github.com/dill-lk/Gravity-Lang/issues)
- [GitHub Discussions](https://github.com/dill-lk/Gravity-Lang/discussions)

## Support

Need help? Check these resources:
1. Browse the [Tutorials](tutorials/)
2. Look at [Examples](examples-gallery.md)
3. Search [existing issues](https://github.com/dill-lk/Gravity-Lang/issues)
4. Ask in [Discussions](https://github.com/dill-lk/Gravity-Lang/discussions)
5. Open a [new issue](https://github.com/dill-lk/Gravity-Lang/issues/new/choose)

## License

Gravity-Lang is open-source software. See the [LICENSE](../LICENSE) file for details.
