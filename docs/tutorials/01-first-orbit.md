# Tutorial 1: Your First Orbital Simulation

**Difficulty**: Beginner
**Time**: 10 minutes
**Prerequisites**: Gravity-Lang installed

## Introduction

In this tutorial, you'll create your first gravitational simulation: a simple two-body Earth-Moon system. You'll learn:

- How to declare celestial bodies
- How to set initial velocities
- How to run a simulation
- How to interpret the output

## Step 1: Create Your Script

Create a new file called `my_first_orbit.gravity`:

```gravity
# My first Earth-Moon simulation

# Declare Earth at the origin
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed

# Declare Moon at its average distance from Earth
sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]

# Set Moon's orbital velocity (perpendicular to position)
Moon.velocity = [0, 1.022, 0][km/s]

# Run the simulation
simulate orbit in 0..100 dt 3600[s] integrator rk4 {
    grav all
    print Moon.position
}
```

## Step 2: Understanding the Code

Let's break down what each part does:

### Declaring Bodies

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
```

- `sphere` - Declares a spherical body
- `Earth` - Name of the body
- `at [0,0,0][m]` - Position in 3D space (x, y, z) in meters
- `mass 5.972e24[kg]` - Mass in kilograms (scientific notation)
- `radius 6371[km]` - Physical radius (for visualization)
- `fixed` - Body doesn't move (acts as reference frame)

### Setting Velocity

```gravity
Moon.velocity = [0, 1.022, 0][km/s]
```

The Moon needs an initial velocity to orbit rather than fall toward Earth. The velocity is perpendicular to the position vector, creating a circular orbit.

### Running the Simulation

```gravity
simulate orbit in 0..100 dt 3600[s] integrator rk4 {
    grav all
    print Moon.position
}
```

- `simulate orbit` - Names this simulation
- `in 0..100` - Run for 100 time steps
- `dt 3600[s]` - Each time step is 3600 seconds (1 hour)
- `integrator rk4` - Use the Runge-Kutta 4th order integrator
- `grav all` - Apply gravitational forces between all bodies
- `print Moon.position` - Output Moon's position at each step

## Step 3: Run Your Simulation

```bash
./build/gravity run my_first_orbit.gravity
```

You should see output like:

```
Step 0: Moon position = [3.844000e+08, 0.000000e+00, 0.000000e+00] m
Step 1: Moon position = [3.843954e+08, 3.679200e+06, 0.000000e+00] m
Step 2: Moon position = [3.843816e+08, 7.358298e+06, 0.000000e+00] m
...
```

## Step 4: Visualize the Results

The position values show the Moon moving in its orbit! The x-component decreases while the y-component increases, indicating circular motion.

### Calculate Orbital Period

Since we're using 1-hour time steps:
- 100 steps = 100 hours ≈ 4.17 days
- The actual Moon orbital period is ~27.3 days

To see a full orbit, increase the step count:

```gravity
simulate orbit in 0..720 dt 3600[s] integrator rk4 {
```

This gives you 720 hours (30 days) - enough to see more than a full orbit!

## Step 5: Save Data to CSV

Modify your simulation to save data:

```gravity
observe Moon.position to "moon_orbit.csv" frequency 1

simulate orbit in 0..720 dt 3600[s] integrator rk4 {
    grav all
}
```

Now run it again:

```bash
./build/gravity run my_first_orbit.gravity
```

This creates `moon_orbit.csv` with position data you can plot in Excel, Python, or any spreadsheet software.

## Experiments to Try

1. **Change the velocity**: What happens if you double `Moon.velocity`?
2. **Try different integrators**: Replace `rk4` with `verlet`, `leapfrog`, or `euler`
3. **Add a third body**: Try adding a spacecraft between Earth and Moon
4. **Change time step**: What happens with `dt 7200[s]` (2 hours)?

## Common Issues

### Moon crashes into Earth

Your initial velocity is too low. Increase the y-component of `Moon.velocity`.

### Moon flies away

Your initial velocity is too high. Decrease it or check that it's perpendicular to the position.

### Numbers look weird

Check your units! Make sure you're using `[km]` vs `[m]` and `[km/s]` vs `[m/s]` consistently.

## Next Steps

Ready for more? Try:

- [Tutorial 2: Multi-Body Systems](02-multi-body.md)
- Explore the [Examples Gallery](../examples-gallery.md)
- Read the [Language Reference](../language-reference.md)

## Summary

You've learned:
- ✅ How to declare bodies with position, mass, and radius
- ✅ How to set initial velocities
- ✅ How to run a simulation with different integrators
- ✅ How to output and save data
- ✅ How to interpret the results

Congratulations on completing your first Gravity-Lang simulation! 🎉
