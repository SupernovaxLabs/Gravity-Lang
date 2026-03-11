# Getting Started with Gravity-Lang

Welcome! This guide will help you get up and running with Gravity-Lang in minutes.

## What is Gravity-Lang?

Gravity-Lang is a domain-specific language (DSL) for writing gravitational physics simulations. Instead of complex numerical code, you describe what you want to simulate in plain, readable syntax:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [0, 1.022, 0][km/s]

simulate orbit in 0..100 dt 3600[s] integrator rk4 {
    grav all
    print Moon.position
}
```

That's it! This simulates the Earth-Moon system for 100 hours.

## Installation

### Option 1: Download Pre-built Binaries (Easiest)

1. Go to [Releases](https://github.com/dill-lk/Gravity-Lang/releases)
2. Download for your platform:
   - **Linux**: `gravity-linux-x64.tar.gz`
   - **macOS**: `gravity-macos-x64.tar.gz`
   - **Windows**: `gravity-windows-x64.zip`

3. Extract and run:

**Linux/macOS:**
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

### Option 2: Build from Source

**Prerequisites:**
- CMake 3.16+
- C++17 compiler (GCC 7+, Clang 5+, or MSVC 2017+)
- Git

**Build steps:**
```bash
git clone https://github.com/dill-lk/Gravity-Lang.git
cd Gravity-Lang
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j
```

**Test it works:**
```bash
./build/gravity --help
./build/gravity run examples/moon_orbit.gravity
```

### Option 3: Docker (For Any Platform)

```bash
docker pull gravity-lang:latest
docker run -v $(pwd):/workspace gravity-lang run /examples/moon_orbit.gravity
```

Or build locally:
```bash
git clone https://github.com/dill-lk/Gravity-Lang.git
cd Gravity-Lang
docker build -t gravity-lang .
docker run -v $(pwd):/workspace gravity-lang run /examples/moon_orbit.gravity
```

### Option 4: Homebrew (macOS/Linux) - Coming Soon

```bash
brew tap dill-lk/gravity-lang
brew install gravity-lang
```

## Your First Simulation

### Step 1: Create a File

Create `my_first_sim.gravity`:

```gravity
# A simple Earth-Moon simulation

sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [0, 1.022, 0][km/s]

simulate orbit in 0..100 dt 3600[s] integrator rk4 {
    grav all
    print Moon.position
}
```

### Step 2: Run It

```bash
./build/gravity run my_first_sim.gravity
```

You should see output like:
```
Step 0: [3.844e+08, 0.000e+00, 0.000e+00] m
Step 1: [3.844e+08, 3.679e+06, 0.000e+00] m
Step 2: [3.843e+08, 7.358e+06, 0.000e+00] m
...
```

The Moon is orbiting! 🌙

### Step 3: Save to CSV

Modify your script to save data:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [0, 1.022, 0][km/s]

observe Moon.position to "moon_orbit.csv" frequency 1

simulate orbit in 0..100 dt 3600[s] integrator rk4 {
    grav all
}
```

Run again:
```bash
./build/gravity run my_first_sim.gravity
```

Now you have `moon_orbit.csv` with position data!

## Understanding the Syntax

### Bodies

Declare celestial bodies:
```gravity
sphere <Name> at [x,y,z][unit] mass <mass>[kg] radius <radius>[unit]
```

- `sphere` - A spherical body (planet, moon, star)
- `at [x,y,z][unit]` - Initial position
- `mass <value>[kg]` - Mass in kilograms
- `radius <value>[unit]` - Physical radius (for visualization)
- `fixed` (optional) - Body doesn't move

### Velocities

Set initial velocity:
```gravity
<Name>.velocity = [vx, vy, vz][unit]
```

### Gravity

Enable gravitational forces:
```gravity
grav all                    # All bodies attract each other
Earth pull Moon             # Earth pulls Moon
Sun pull Earth, Mars        # Sun pulls Earth and Mars
```

### Simulation

Run the simulation:
```gravity
simulate <name> in <start>..<end> dt <timestep>[s] integrator <type> {
    # commands here
}
```

- `in 0..100` - Run for 100 steps
- `dt 3600[s]` - Each step is 3600 seconds (1 hour)
- `integrator rk4` - Use Runge-Kutta 4th order

## Common Use Cases

### 1. Check Orbital Period

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [0, 1.022, 0][km/s]

simulate orbit in 0..720 dt 3600[s] integrator rk4 {
    grav all
    print Moon.position
}

orbital_elements Moon around Earth
```

### 2. Three-Body Problem

```gravity
sphere Sun at [0,0,0][m] mass 1.989e30[kg] radius 696340[km] fixed
sphere Earth at [1.496e11,0,0][m] mass 5.972e24[kg] radius 6371[km]
Earth.velocity = [0, 29780, 0][m/s]
sphere Moon at [1.496e11,384400000,0][m] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [1022, 29780, 0][m/s]

dump_all to "three_body.csv" frequency 10

simulate solar in 0..365 dt 86400[s] integrator leapfrog {
    grav all
}
```

### 3. Rocket Launch

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
rocket Rocket at [0,6371000,0][m] mass 10000[kg] radius 3[m]
Rocket.velocity = [0,0,0][m/s]
Rocket.fuel_mass = 90000[kg]
Rocket.burn_rate = 2000[kg/s]
Rocket.isp = 310[s]
Rocket.thrust_direction = [0,1,0]

plot on body Rocket

simulate launch in 0..300 dt 0.5[s] integrator rk45 {
    Earth pull Rocket
}
```

## CLI Commands

### Run a Simulation

```bash
./build/gravity run script.gravity
```

### Check Syntax (Without Running)

```bash
./build/gravity check script.gravity
```

Strict mode (fails on warnings):
```bash
./build/gravity check script.gravity --strict
```

### Resume from Checkpoint

```bash
./build/gravity run script.gravity --resume checkpoint.json
```

### Dump All States

```bash
./build/gravity run script.gravity --dump-all=output.csv
```

### Compiler Mode

Generate C++ code:
```bash
./build/gravityc script.gravity --emit output.cpp
```

Compile and run:
```bash
./build/gravityc script.gravity --emit output.cpp --build executable --run
```

### Get Help

```bash
./build/gravity --help
./build/gravity list-features
```

## Next Steps

### Tutorials

Work through the tutorial series:
1. [Tutorial 1: Your First Orbit](tutorials/01-first-orbit.md) - Beginner
2. [Tutorial 2: Multi-Body Systems](tutorials/02-multi-body.md) - Intermediate
3. [Tutorial 3: Rocket Trajectories](tutorials/03-rocket-trajectories.md) - Advanced

### Examples

Explore the examples in `examples/`:
- `moon_orbit.gravity` - Earth-Moon system
- `binary_star.gravity` - Binary star system
- `rocket_testing.gravity` - Rocket launch
- `galaxy_collision.gravity` - Galaxy merger
- `solar_system.gravity` - Full solar system

### Reference Documentation

- [Language Reference](language-reference.md) - Complete syntax guide
- [Performance Guide](performance-guide.md) - Optimization tips
- [API Reference](api-reference.md) - Advanced features

## Troubleshooting

### "Command not found"

Make sure you're in the right directory:
```bash
cd /path/to/Gravity-Lang
./build/gravity run script.gravity
```

Or add to PATH:
```bash
export PATH=$PATH:/path/to/Gravity-Lang/build
gravity run script.gravity
```

### Build Errors

Make sure you have dependencies:
```bash
# Ubuntu/Debian
sudo apt install cmake g++ make

# macOS
brew install cmake

# Windows
# Install Visual Studio with C++ tools
```

### Simulation Doesn't Work

1. Check syntax:
   ```bash
   ./build/gravity check script.gravity
   ```

2. Read error messages - they're designed to be helpful!

3. Start with a working example:
   ```bash
   ./build/gravity run examples/moon_orbit.gravity
   ```

### Results Don't Match Expectations

- Check units (km vs m, km/s vs m/s)
- Try a smaller time step (dt)
- Use a better integrator (rk4 or rk45)
- Verify initial conditions are correct

## Getting Help

- 📚 [Documentation](README.md)
- 💬 [GitHub Discussions](https://github.com/dill-lk/Gravity-Lang/discussions)
- 🐛 [Report a Bug](https://github.com/dill-lk/Gravity-Lang/issues/new?template=bug_report.md)
- ❓ [Ask a Question](https://github.com/dill-lk/Gravity-Lang/issues/new?template=question.md)

## Contributing

Want to contribute? See [CONTRIBUTING.md](../CONTRIBUTING.md)!

---

Happy simulating! 🚀🌌
