# Language Reference

Complete reference for the Gravity-Lang domain-specific language.

## Table of Contents

- [Body Declarations](#body-declarations)
- [Units](#units)
- [Velocity Assignment](#velocity-assignment)
- [Gravity Rules](#gravity-rules)
- [Simulation Blocks](#simulation-blocks)
- [Integrators](#integrators)
- [Output Commands](#output-commands)
- [Advanced Features](#advanced-features)

---

## Body Declarations

### Sphere

Standard spherical body (planet, star, moon).

```gravity
sphere <Name> at [x,y,z][unit] mass <value>[kg] radius <value>[unit] [fixed]
```

**Parameters:**
- `Name` - Identifier for the body (alphanumeric, underscores)
- `at [x,y,z][unit]` - Initial position (3D vector with units)
- `mass <value>[kg]` - Mass in kilograms
- `radius <value>[unit]` - Physical radius (for visualization)
- `fixed` (optional) - Body doesn't move (reference frame)

**Example:**
```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
```

### Probe

Massless test particle (doesn't affect other bodies gravitationally).

```gravity
probe <Name> at [x,y,z][unit] radius <value>[unit]
```

**Example:**
```gravity
probe Voyager at [1e12,0,0][m] radius 1[m]
```

### Rocket

Body with propulsion capabilities.

```gravity
rocket <Name> at [x,y,z][unit] mass <value>[kg] radius <value>[unit]
```

**Additional Properties:**
```gravity
<Name>.fuel_mass = <value>[kg]
<Name>.burn_rate = <value>[kg/s]
<Name>.isp = <value>[s]
<Name>.thrust_direction = [x,y,z]
<Name>.drag_coefficient = <value>
<Name>.cross_section_area = <value>[m^2]
```

**Example:**
```gravity
rocket Falcon at [0,6371000,0][m] mass 30000[kg] radius 3[m]
Falcon.fuel_mass = 420000[kg]
Falcon.burn_rate = 2500[kg/s]
Falcon.isp = 282[s]
Falcon.thrust_direction = [0,1,0]
```

---

## Units

### Position/Distance
- `[m]` - meters
- `[km]` - kilometers

### Velocity
- `[m/s]` - meters per second
- `[km/s]` - kilometers per second

### Mass
- `[kg]` - kilograms (only unit for mass)

### Time
- `[s]` - seconds

### Angles (for gravity turns)
- `[deg]` - degrees
- `[rad]` - radians

---

## Velocity Assignment

Set initial velocity for a body:

```gravity
<Name>.velocity = [vx, vy, vz][unit]
```

**Example:**
```gravity
Moon.velocity = [0, 1.022, 0][km/s]
```

---

## Gravity Rules

### Mutual Attraction

All bodies attract all other bodies:

```gravity
grav all
```

### Selective Attraction

Specify which bodies pull which:

```gravity
<Body1> pull <Body2>
<Body1> pull <Body2>, <Body3>, <Body4>
```

**Examples:**
```gravity
# Earth pulls Moon
Earth pull Moon

# Sun pulls all planets
Sun pull Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune

# Binary star system
StarA pull StarB
StarB pull StarA
```

---

## Simulation Blocks

### Basic Syntax

```gravity
simulate <name> in <start>..<end> dt <timestep>[s] integrator <type> {
    # Commands
}
```

**Parameters:**
- `name` - Simulation identifier
- `start..end` - Step range (integers)
- `dt <value>[s]` - Time step in seconds
- `integrator <type>` - Numerical integrator choice

**Example:**
```gravity
simulate orbit in 0..720 dt 3600[s] integrator rk4 {
    grav all
    print Moon.position
}
```

### Alternative: Orbit Syntax

```gravity
orbit <name> in <start>..<end> dt <timestep>[s] integrator <type> {
    # Commands
}
```

---

## Integrators

### Available Integrators

| Integrator | Order | Accuracy | Energy Conservation | Speed | Best For |
|------------|-------|----------|---------------------|-------|----------|
| `euler` | 1st | ⭐ | ❌ | ⚡⚡⚡ | Quick tests |
| `verlet` | 2nd | ⭐⭐ | ✅✅✅ | ⚡⚡ | Energy-critical |
| `leapfrog` | 2nd | ⭐⭐ | ✅✅ | ⚡⚡ | Long simulations |
| `rk4` | 4th | ⭐⭐⭐ | ✅ | ⚡ | High precision |
| `yoshida4` | 4th | ⭐⭐⭐ | ✅✅ | ⚡ | Symplectic needs |
| `rk45` | 4/5th | ⭐⭐⭐⭐ | ✅ | ⚡ | Adaptive stepping |

### Integrator Selection Guide

**Use `euler`** for:
- Quick prototyping
- Short simulations
- Testing syntax

**Use `leapfrog`** for:
- Default choice for most simulations
- Long-term orbital mechanics
- N-body systems

**Use `verlet`** for:
- When energy conservation is critical
- Molecular dynamics-like problems
- Verification runs

**Use `rk4`** for:
- High-accuracy requirements
- Publication-quality results
- Comparing against reference data

**Use `rk45`** for:
- Stiff differential equations
- Variable timestep needs
- Rocket trajectories with thrust

**Use `yoshida4`** for:
- Symplectic integration needs
- Long-term stability
- Hamiltonian systems

---

## Output Commands

### Print

Output to console at each timestep:

```gravity
print <Body>.position
print <Body>.velocity
print <Body>.mass
print <Body>.altitude
```

### Observe

Save to CSV file:

```gravity
observe <Body>.position to "filename.csv" frequency <N>
observe <Body>.velocity to "filename.csv" frequency <N>
observe <Body>.altitude to "filename.csv" frequency <N>
```

**Parameters:**
- `frequency <N>` - Output every N steps (1 = every step)

**Example:**
```gravity
observe Moon.position to "moon_data.csv" frequency 10
```

### Dump All

Save all body states to CSV:

```gravity
dump_all to "filename.csv" frequency <N>
```

**Example:**
```gravity
dump_all to "simulation.csv" frequency 5
```

### Save Checkpoint

Save simulation state for resuming:

```gravity
save "checkpoint.json" frequency <N>
```

**Example:**
```gravity
save "artifacts/checkpoint.json" frequency 100
```

### Plot

Generate animated SVG telemetry:

```gravity
plot on
plot off
plot on body <Name>
```

**Examples:**
```gravity
plot on body Rocket
```

### Orbital Elements

Calculate and display orbital parameters:

```gravity
orbital_elements <Body> around <CentralBody>
```

**Example:**
```gravity
orbital_elements Moon around Earth
```

**Output includes:**
- Semi-major axis
- Eccentricity
- Inclination
- Right ascension of ascending node
- Argument of periapsis
- True anomaly

---

## Advanced Features

### Threading

Enable parallel force calculation:

```gravity
threads <N>
threads auto
```

**Examples:**
```gravity
threads 4        # Use 4 threads
threads auto     # Use all available cores
```

### Gravity Models

Select gravity model:

```gravity
gravity newtonian    # Standard inverse-square law (default)
gravity mond         # Modified Newtonian Dynamics
gravity gr           # General Relativity corrections
```

### Rocket Parameters

#### Gravity Turn

```gravity
<Rocket>.gravity_turn_start = <time>[s]
<Rocket>.gravity_turn_end = <time>[s]
<Rocket>.target_angle = <angle>[deg]
```

#### Staging

```gravity
<Rocket>.separation_time = <time>[s]
<Rocket>.separation_impulse = <delta_v>[m/s]
<Rocket>.enabled_after = <time>[s]
```

#### Atmospheric Drag

```gravity
<Rocket>.drag_coefficient = <Cd>
<Rocket>.cross_section_area = <value>[m^2]
```

---

## Comments

Single-line comments use `#`:

```gravity
# This is a comment
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km]  # inline comment
```

---

## Complete Example

```gravity
# Solar System Simulation

# Sun at origin
sphere Sun at [0,0,0][m] mass 1.989e30[kg] radius 696340[km] fixed

# Inner planets
sphere Mercury at [57.9e9,0,0][m] mass 3.3e23[kg] radius 2440[km]
Mercury.velocity = [0, 47870, 0][m/s]

sphere Venus at [108.2e9,0,0][m] mass 4.87e24[kg] radius 6052[km]
Venus.velocity = [0, 35020, 0][m/s]

sphere Earth at [149.6e9,0,0][m] mass 5.972e24[kg] radius 6371[km]
Earth.velocity = [0, 29780, 0][m/s]

sphere Mars at [227.9e9,0,0][m] mass 6.39e23[kg] radius 3390[km]
Mars.velocity = [0, 24070, 0][m/s]

# Enable threading for performance
threads auto

# Save data every 10 steps
dump_all to "solar_system.csv" frequency 10

# Simulate one Earth year
simulate solar_system in 0..365 dt 86400[s] integrator leapfrog {
    grav all
}

# Check Earth's orbit
orbital_elements Earth around Sun
```

---

## CLI Usage

### Run Simulation

```bash
./build/gravity run script.gravity
```

### Check Syntax

```bash
./build/gravity check script.gravity
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

### List Features

```bash
./build/gravity list-features
```

### Compiler Mode

```bash
./build/gravityc script.gravity --emit output.cpp
./build/gravityc script.gravity --emit output.cpp --build executable
./build/gravityc script.gravity --emit output.cpp --build executable --run
```

---

## Error Handling

The interpreter provides helpful error messages:

```
❌ Error: Unknown unit '[km/h]'
💡 Suggestion: Did you mean '[km/s]' or '[m/s]'?
```

Common errors:
- Invalid units
- Missing objects in gravity rules
- Negative mass values
- Invalid time step ranges
- Incomplete orbital_elements syntax

---

## Best Practices

1. **Use appropriate integrators**: `leapfrog` for most cases, `rk45` for rockets
2. **Check energy conservation**: Use `observe` to track energy over time
3. **Start with small step counts**: Test with 10-100 steps before long runs
4. **Use appropriate dt**: Too small = slow, too large = inaccurate
5. **Enable threading for N>10**: Significant speedup for many bodies
6. **Save checkpoints**: For long simulations, save state periodically
7. **Use selective gravity**: When possible, avoid `grav all` for N>100

---

## Performance Tips

- **Timestep**: Larger dt = faster but less accurate
- **Integrator**: euler fastest, rk45 slowest but most accurate
- **Threading**: Use `threads auto` for N>10 bodies
- **Selective gravity**: Specify only necessary interactions
- **Output frequency**: Higher frequency = larger files, slower

---

## Troubleshooting

### Simulation crashes
- Reduce time step (dt)
- Switch to adaptive integrator (rk45)
- Check initial velocities are reasonable

### Inaccurate results
- Use smaller time step
- Use higher-order integrator (rk4, rk45)
- Check units are consistent

### Slow performance
- Increase time step (if accuracy permits)
- Use faster integrator (leapfrog, euler)
- Enable threading
- Use selective gravity instead of `grav all`

---

For more information, see:
- [Tutorial 1: First Orbit](tutorials/01-first-orbit.md)
- [Tutorial 2: Multi-Body Systems](tutorials/02-multi-body.md)
- [Tutorial 3: Rocket Trajectories](tutorials/03-rocket-trajectories.md)
