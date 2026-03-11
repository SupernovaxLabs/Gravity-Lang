# Examples Gallery

A showcase of what you can build with Gravity-Lang.

## Table of Contents

- [Basic Orbits](#basic-orbits)
- [Multi-Body Systems](#multi-body-systems)
- [Rocket Simulations](#rocket-simulations)
- [Advanced Physics](#advanced-physics)
- [Visualization Examples](#visualization-examples)

---

## Basic Orbits

### Earth-Moon System

**File**: `examples/moon_orbit.gravity`

A simple two-body orbital system demonstrating:
- Fixed central body
- Orbital velocity calculation
- Position tracking

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [0, 1.022, 0][km/s]

simulate orbit in 0..720 dt 3600[s] integrator rk4 {
    grav all
    print Moon.position
}
```

**Physics**: Moon completes ~1 orbit in 27.3 days

**Run**: `./build/gravity run examples/moon_orbit.gravity`

---

### Binary Star System

**File**: `examples/binary_star.gravity`

Two stars orbiting their common center of mass:
- No fixed bodies
- Mutual attraction
- Conservation of momentum

```gravity
sphere StarA at [-1e11,0,0][m] mass 2e30[kg] radius 7e8[m]
StarA.velocity = [0, -15000, 0][m/s]

sphere StarB at [1e11,0,0][m] mass 1.5e30[kg] radius 6e8[m]
StarB.velocity = [0, 15000, 0][m/s]

dump_all to "binary_star.csv" frequency 10

simulate binary in 0..1000 dt 86400[s] integrator leapfrog {
    grav all
}
```

**Physics**: Stars orbit around barycenter (center of mass)

**Visualization**: Plot positions to see figure-8 pattern

---

## Multi-Body Systems

### Solar System

**File**: `examples/solar_system.gravity`

Complete inner solar system simulation:
- Sun + 4 inner planets
- Realistic masses and distances
- N-body gravitational interactions

```gravity
sphere Sun at [0,0,0][m] mass 1.989e30[kg] radius 696340[km] fixed

sphere Mercury at [57.9e9,0,0][m] mass 3.3e23[kg] radius 2440[km]
Mercury.velocity = [0, 47870, 0][m/s]

sphere Venus at [108.2e9,0,0][m] mass 4.87e24[kg] radius 6052[km]
Venus.velocity = [0, 35020, 0][m/s]

sphere Earth at [149.6e9,0,0][m] mass 5.972e24[kg] radius 6371[km]
Earth.velocity = [0, 29780, 0][m/s]

sphere Mars at [227.9e9,0,0][m] mass 6.39e23[kg] radius 3390[km]
Mars.velocity = [0, 24070, 0][m/s]

threads auto
dump_all to "solar_system.csv" frequency 10

simulate solar_system in 0..365 dt 86400[s] integrator leapfrog {
    grav all
}
```

**Physics**: Simulate one Earth year (365 days)

**Performance**: Uses threading for faster computation

---

### Galaxy Collision

**File**: `examples/galaxy_collision.gravity`

Two galaxies merging:
- 2 galactic cores
- Multiple star particles
- Long-term dynamics

```gravity
# Galaxy A core
sphere CoreA at [-5e20,0,0][m] mass 1e41[kg] radius 1e19[m]
CoreA.velocity = [0, 1e5, 0][m/s]

# Galaxy B core
sphere CoreB at [5e20,0,0][m] mass 8e40[kg] radius 9e18[m]
CoreB.velocity = [0, -1e5, 0][m/s]

# Stars in Galaxy A (blue)
sphere StarA1 at [-4e20,1e20,0][m] mass 2e30[kg] radius 7e8[m]
StarA1.velocity = [0, 1.2e5, 0][m/s]
# ... more stars ...

# Stars in Galaxy B (pink)
sphere StarB1 at [4e20,-1e20,0][m] mass 2e30[kg] radius 7e8[m]
StarB1.velocity = [0, -1.2e5, 0][m/s]
# ... more stars ...

threads auto
dump_all to "galaxy_collision.csv" frequency 50

simulate collision in 0..5000 dt 1e10[s] integrator leapfrog {
    grav all
}
```

**Physics**: Cores interact gravitationally, stars follow

**Visualization**: Animate to see tidal tails and merger

---

## Rocket Simulations

### Vertical Launch

Simple rocket going straight up:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed

rocket Rocket at [0,6371000,0][m] mass 5000[kg] radius 2[m]
Rocket.velocity = [0,0,0][m/s]
Rocket.fuel_mass = 45000[kg]
Rocket.burn_rate = 1500[kg/s]
Rocket.isp = 300[s]
Rocket.thrust_direction = [0,1,0]

observe Rocket.altitude to "altitude.csv" frequency 1

simulate launch in 0..100 dt 0.5[s] integrator rk45 {
    Earth pull Rocket
}
```

**Physics**: Rocket burns for 30 seconds, then coasts

**Expected**: Reaches ~100km altitude before falling back

---

### Orbital Insertion

Rocket with gravity turn for orbit:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed

rocket Rocket at [0,6371000,0][m] mass 10000[kg] radius 3[m]
Rocket.velocity = [0,0,0][m/s]
Rocket.fuel_mass = 90000[kg]
Rocket.burn_rate = 2000[kg/s]
Rocket.isp = 310[s]
Rocket.thrust_direction = [0,1,0]

Rocket.gravity_turn_start = 10[s]
Rocket.gravity_turn_end = 60[s]
Rocket.target_angle = 45[deg]

plot on body Rocket

simulate launch in 0..300 dt 0.5[s] integrator rk45 {
    Earth pull Rocket
}

orbital_elements Rocket around Earth
```

**Physics**: Gravity turn pitches rocket toward horizontal

**Expected**: Elliptical orbit (not quite circular without circularization burn)

---

### Two-Stage Rocket

**File**: `examples/rocket_testing.gravity`

Multi-stage vehicle:
- First stage: high thrust, low ISP
- Second stage: lower thrust, high ISP
- Staging at optimal time

**Physics**: Demonstrates rocket equation and staging benefits

---

## Advanced Physics

### MOND vs Newtonian

**File**: `examples/mond_vs_newtonian.gravity`

Compare Modified Newtonian Dynamics to standard gravity:

```gravity
# Run with Newtonian
gravity newtonian
simulate newtonian in 0..1000 dt 86400[s] integrator leapfrog {
    grav all
}

# Run with MOND
gravity mond
simulate mond in 0..1000 dt 86400[s] integrator leapfrog {
    grav all
}
```

**Physics**: MOND modifies gravity at large distances

**Use case**: Galaxy rotation curves

---

### Integrator Comparison

**File**: `examples/integrator_comparison.gravity`

Test all integrators on same system:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [0, 1.022, 0][km/s]

# Test each integrator
simulate test_euler in 0..100 dt 3600[s] integrator euler { grav all }
simulate test_leapfrog in 0..100 dt 3600[s] integrator leapfrog { grav all }
simulate test_rk4 in 0..100 dt 3600[s] integrator rk4 { grav all }
simulate test_rk45 in 0..100 dt 3600[s] integrator rk45 { grav all }
```

**Analysis**: Compare accuracy, speed, energy conservation

---

### Lagrange Points

Find L4 and L5 equilibrium points:

```gravity
sphere Sun at [0,0,0][m] mass 1.989e30[kg] radius 696340[km] fixed
sphere Earth at [1.496e11,0,0][m] mass 5.972e24[kg] radius 6371[km]
Earth.velocity = [0, 29780, 0][m/s]

# L4 point (60° ahead of Earth)
probe L4 at [7.48e10, 1.296e11, 0][m] radius 1[m]
L4.velocity = [0, 29780, 0][m/s]

# L5 point (60° behind Earth)
probe L5 at [7.48e10, -1.296e11, 0][m] radius 1[m]
L5.velocity = [0, 29780, 0][m/s]

observe L4.position to "l4.csv" frequency 10
observe L5.position to "l5.csv" frequency 10

simulate lagrange in 0..3650 dt 86400[s] integrator leapfrog {
    grav all
}
```

**Physics**: L4 and L5 are stable equilibrium points

**Expected**: Probes remain near starting positions

---

## Visualization Examples

### Animated SVG Output

Any simulation can generate animated plots:

```gravity
plot on body Rocket

simulate launch in 0..300 dt 0.5[s] integrator rk45 {
    Earth pull Rocket
}
```

**Output**: `artifacts/telemetry_Rocket.svg`

**View**: Open in web browser for animated trajectory

---

### CSV for Custom Plotting

```gravity
dump_all to "simulation.csv" frequency 1

simulate orbit in 0..1000 dt 3600[s] integrator rk4 {
    grav all
}
```

Then plot with Python:
```python
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('simulation.csv')
plt.plot(df['x'], df['y'])
plt.xlabel('X (m)')
plt.ylabel('Y (m)')
plt.title('Orbital Trajectory')
plt.show()
```

---

## More Examples

All examples are in the `examples/` directory:

| File | Description | Complexity |
|------|-------------|------------|
| `moon_orbit.gravity` | Earth-Moon | Beginner |
| `earth_moon.gravity` | Earth-Moon with output | Beginner |
| `binary_star.gravity` | Binary star system | Intermediate |
| `solar_system.gravity` | Inner solar system | Intermediate |
| `galaxy_collision.gravity` | Galaxy merger | Advanced |
| `rocket_testing.gravity` | Multi-stage rocket | Advanced |
| `threaded_three_body.gravity` | Parallel three-body | Intermediate |
| `integrator_comparison.gravity` | Integrator tests | Intermediate |
| `mond_vs_newtonian.gravity` | Physics comparison | Advanced |
| `all_features_one.gravity` | Feature showcase | Reference |

---

## Creating Your Own

### Template for New Simulation

```gravity
# Title: [Your Simulation Name]
# Description: [What it demonstrates]

# Bodies
sphere Body1 at [x,y,z][unit] mass [value][kg] radius [value][unit]
# Add more bodies...

# Initial velocities
Body1.velocity = [vx, vy, vz][unit]

# Optional: threading, output
threads auto
dump_all to "output.csv" frequency 10

# Simulation
simulate name in 0..N dt [timestep][s] integrator [type] {
    grav all
    # or selective gravity
}

# Optional: analysis
orbital_elements Body1 around Body2
```

---

## Tips for Interesting Simulations

1. **Hohmann Transfer**: Launch from Earth orbit to Mars orbit
2. **Figure-8 Orbit**: Three equal masses in figure-8 pattern
3. **Slingshot**: Use Moon gravity assist to escape Earth
4. **Tidal Locking**: Show Moon always faces Earth
5. **Ring System**: Particles orbiting a planet
6. **Trojan Asteroids**: Bodies at L4/L5 Lagrange points
7. **Satellite Constellation**: GPS/Starlink-like grid
8. **Interplanetary Travel**: Earth to Jupiter mission

---

## Sharing Your Simulations

Created something cool? Share it!

1. Fork the repository
2. Add your `.gravity` file to `examples/`
3. Document it in this file
4. Submit a pull request

We'd love to see what you build! 🚀

---

For more information:
- [Getting Started](getting-started.md)
- [Language Reference](language-reference.md)
- [Tutorials](tutorials/)
