# Tutorial 2: Multi-Body N-Body Systems

**Difficulty**: Intermediate
**Time**: 20 minutes
**Prerequisites**: Tutorial 1 completed

## Introduction

In this tutorial, you'll simulate a multi-body system with mutual gravitational interactions. You'll learn:

- How to handle N-body gravitational interactions
- Using `grav all` for mutual attraction
- Selective gravity with explicit `pull` syntax
- Tracking multiple bodies simultaneously
- Understanding energy conservation

## Step 1: Three-Body Problem

Let's create a simple three-body system with the Sun, Earth, and Moon:

```gravity
# Three-body Sun-Earth-Moon system

# Sun at the origin
sphere Sun at [0,0,0][m] mass 1.989e30[kg] radius 696340[km] fixed

# Earth orbiting the Sun
sphere Earth at [1.496e11,0,0][m] mass 5.972e24[kg] radius 6371[km]
Earth.velocity = [0, 29780, 0][m/s]

# Moon orbiting Earth (offset from Earth's position)
sphere Moon at [1.496e11,384400000,0][m] mass 7.348e22[kg] radius 1737[km]
Moon.velocity = [1022, 29780, 0][m/s]

# Run simulation with mutual gravity
simulate solar_system in 0..365 dt 86400[s] integrator rk45 {
    grav all
    print Earth.position
    print Moon.position
}
```

### Key Concepts

**`grav all`**: This enables mutual gravitational attraction between ALL bodies in the system:
- Sun pulls Earth
- Sun pulls Moon
- Earth pulls Moon
- Moon pulls Earth
- And so on...

**Velocity composition**: The Moon's velocity is the sum of:
- Earth's orbital velocity around the Sun (29780 m/s)
- Moon's orbital velocity around Earth (1022 m/s)

## Step 2: Understanding N-Body Complexity

The computational cost grows as O(N²) where N is the number of bodies:

| Bodies | Interactions | Relative Cost |
|--------|--------------|---------------|
| 2      | 1            | 1×            |
| 3      | 3            | 3×            |
| 10     | 45           | 45×           |
| 100    | 4,950        | 4,950×        |

For large N, consider using selective gravity or threading.

## Step 3: Selective Gravity

Instead of `grav all`, you can specify which bodies pull which:

```gravity
# Binary star system with planets

sphere StarA at [-1e11,0,0][m] mass 2e30[kg] radius 7e8[m]
StarA.velocity = [0, -15000, 0][m/s]

sphere StarB at [1e11,0,0][m] mass 1.5e30[kg] radius 6e8[m]
StarB.velocity = [0, 15000, 0][m/s]

sphere Planet1 at [2e11,0,0][m] mass 6e24[kg] radius 6.4e6[m]
Planet1.velocity = [0, 25000, 0][m/s]

sphere Planet2 at [-2e11,0,0][m] mass 4e24[kg] radius 5e6[m]
Planet2.velocity = [0, -25000, 0][m/s]

simulate binary_star in 0..1000 dt 86400[s] integrator rk45 {
    # Stars attract each other
    StarA pull StarB
    StarB pull StarA

    # Both stars pull both planets
    StarA pull Planet1, Planet2
    StarB pull Planet1, Planet2

    # Planets don't pull each other (too weak)
    # This saves computation!

    print StarA.position
    print StarB.position
}
```

This approach is more efficient when you can ignore weak interactions.

## Step 4: Tracking Multiple Outputs

Use `dump_all` to track all bodies at once:

```gravity
# Galaxy collision simulation
sphere CoreA at [-5e20,0,0][m] mass 1e41[kg] radius 1e19[m]
CoreA.velocity = [0, 1e5, 0][m/s]

sphere CoreB at [5e20,0,0][m] mass 8e40[kg] radius 9e18[m]
CoreB.velocity = [0, -1e5, 0][m/s]

# Add several stars around each core
sphere Star1 at [-4e20,1e20,0][m] mass 2e30[kg] radius 7e8[m]
Star1.velocity = [0, 1.2e5, 0][m/s]

sphere Star2 at [-6e20,-1e20,0][m] mass 2e30[kg] radius 7e8[m]
Star2.velocity = [0, 0.8e5, 0][m/s]

# ... add more stars ...

# Export all body states to CSV
dump_all to "galaxy_collision.csv" frequency 10

simulate collision in 0..5000 dt 1e10[s] integrator leapfrog {
    grav all
}
```

The `dump_all` command writes position, velocity, and mass for ALL bodies every 10 steps.

## Step 5: Energy Conservation Check

Add physics monitoring to verify your simulation is accurate:

```gravity
sphere Star1 at [0,0,0][m] mass 2e30[kg] radius 7e8[m] fixed
sphere Planet1 at [1.5e11,0,0][m] mass 6e24[kg] radius 6.4e6[m]
Planet1.velocity = [0, 30000, 0][m/s]

# Monitor energy conservation
observe Planet1.kinetic_energy to "planet_energy.csv" frequency 1
observe Planet1.potential_energy to "planet_energy.csv" frequency 1

simulate orbit in 0..365 dt 86400[s] integrator verlet {
    grav all
}
```

Plot the energy over time - it should remain nearly constant with good integrators like `verlet` or `rk45`.

## Step 6: Parallel Processing

For large N-body systems, enable threading:

```gravity
# Configuration (before body declarations)
threads auto

# ... declare many bodies ...

simulate large_system in 0..10000 dt 1000[s] integrator leapfrog {
    grav all
}
```

The `threads auto` directive uses all available CPU cores for parallel force calculation.

## Integrator Comparison for N-Body

Different integrators have different strengths:

| Integrator | Speed | Accuracy | Energy Conservation | Best For |
|------------|-------|----------|---------------------|----------|
| `euler`    | ⚡⚡⚡  | ⭐       | ❌                  | Quick tests |
| `leapfrog` | ⚡⚡   | ⭐⭐     | ✅✅                | Long simulations |
| `verlet`   | ⚡⚡   | ⭐⭐     | ✅✅✅              | Energy-critical |
| `rk4`      | ⚡     | ⭐⭐⭐   | ✅                  | High precision |
| `rk45`     | ⚡     | ⭐⭐⭐⭐ | ✅                  | Adaptive needs |

## Common Pitfalls

### Bodies fly apart

- Check that velocities are in the right units (`[m/s]` vs `[km/s]`)
- Verify velocities are roughly perpendicular to position vectors for orbits
- Make sure masses are realistic

### Simulation is too slow

- Use selective gravity instead of `grav all`
- Increase the time step `dt`
- Enable threading with `threads auto`
- Switch to a faster integrator like `leapfrog`

### Results are inaccurate

- Use a smaller time step
- Switch to a better integrator (`rk45` or `verlet`)
- Check for unit mismatches
- Verify initial conditions are physically realistic

## Exercises

1. **Figure-8 orbit**: Create a three-body system that forms a figure-8 pattern
2. **Trojan asteroids**: Place bodies at Earth's L4 and L5 Lagrange points
3. **Binary planet**: Two planets orbiting their common center of mass
4. **Star cluster**: 10+ stars with random positions and velocities

## Next Steps

- [Tutorial 3: Rocket Trajectories](03-rocket-trajectories.md)
- Read about [Performance Optimization](../performance-guide.md)
- Explore [Advanced Integrators](../language-reference.md#integrators)

## Summary

You've learned:
- ✅ How to simulate N-body systems with `grav all`
- ✅ Selective gravity for efficiency
- ✅ Tracking multiple bodies with `dump_all`
- ✅ Energy conservation monitoring
- ✅ Parallel processing with threading
- ✅ Choosing the right integrator

Keep experimenting with different configurations! 🌌
