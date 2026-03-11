# Tutorial 3: Rocket Trajectories and Spacecraft Dynamics

**Difficulty**: Advanced
**Time**: 30 minutes
**Prerequisites**: Tutorials 1 and 2 completed

## Introduction

This tutorial covers simulating rockets and spacecraft, including:

- Rocket body declarations with fuel
- Thrust and burn rates
- Staging events
- Gravity turns
- Atmospheric drag
- Launch to orbit

## Step 1: Basic Rocket

Let's start with a simple rocket on a launchpad:

```gravity
# Earth
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed

# Rocket on the surface at the equator
rocket Falcon at [0,6371000,0][m] mass 30000[kg] radius 3[m]
Falcon.velocity = [0,0,0][m/s]

# Rocket configuration
Falcon.fuel_mass = 420000[kg]
Falcon.burn_rate = 2500[kg/s]
Falcon.isp = 282[s]
Falcon.thrust_direction = [0,1,0]

simulate launch in 0..500 dt 1[s] integrator rk4 {
    Earth pull Falcon
    print Falcon.altitude
    print Falcon.velocity
}
```

### Understanding Rocket Parameters

- **`fuel_mass`**: Total propellant mass (adds to dry mass)
- **`burn_rate`**: Fuel consumption rate (kg/s)
- **`isp`**: Specific impulse (seconds) - efficiency measure
- **`thrust_direction`**: Unit vector for thrust direction

The actual thrust force is calculated using the rocket equation:
```
F_thrust = burn_rate × isp × g0
```
where g0 = 9.80665 m/s² (standard gravity)

## Step 2: Vertical Launch

Let's launch straight up:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed

rocket Rocket at [0,6371000,0][m] mass 5000[kg] radius 2[m]
Rocket.velocity = [0,0,0][m/s]
Rocket.fuel_mass = 45000[kg]
Rocket.burn_rate = 1500[kg/s]
Rocket.isp = 300[s]
Rocket.thrust_direction = [0,1,0]  # Straight up

# Save telemetry
observe Rocket.altitude to "rocket_altitude.csv" frequency 1
observe Rocket.velocity to "rocket_velocity.csv" frequency 1
observe Rocket.fuel_mass to "rocket_fuel.csv" frequency 1

simulate vertical_launch in 0..100 dt 0.5[s] integrator rk45 {
    Earth pull Rocket
    print Rocket.altitude
}
```

The rocket will burn fuel for: `45000 kg / 1500 kg/s = 30 seconds`

After burnout, it will coast upward, then fall back down.

## Step 3: Gravity Turn

For orbital insertion, we need to pitch over during ascent:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed

rocket Rocket at [0,6371000,0][m] mass 10000[kg] radius 3[m]
Rocket.velocity = [0,0,0][m/s]
Rocket.fuel_mass = 90000[kg]
Rocket.burn_rate = 2000[kg/s]
Rocket.isp = 310[s]

# Gravity turn parameters
Rocket.gravity_turn_start = 10[s]
Rocket.gravity_turn_end = 60[s]
Rocket.target_angle = 45[deg]

# Initially thrust upward
Rocket.thrust_direction = [0,1,0]

simulate gravity_turn in 0..200 dt 0.5[s] integrator rk45 {
    Earth pull Rocket

    # The interpreter automatically adjusts thrust_direction
    # based on gravity_turn parameters

    print Rocket.altitude
    print Rocket.velocity
}
```

The gravity turn gradually pitches the rocket from vertical to the target angle, following a smooth trajectory.

## Step 4: Staging

Multi-stage rockets drop mass to improve efficiency:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed

# First stage
rocket Stage1 at [0,6371000,0][m] mass 25000[kg] radius 4[m]
Stage1.velocity = [0,0,0][m/s]
Stage1.fuel_mass = 400000[kg]
Stage1.burn_rate = 3000[kg/s]
Stage1.isp = 282[s]
Stage1.thrust_direction = [0,1,0]

# Stage separation at T+130s
Stage1.separation_time = 130[s]
Stage1.separation_impulse = 1000[m/s]

# Second stage (created at separation)
rocket Stage2 at [0,6371000,0][m] mass 8000[kg] radius 2.5[m]
Stage2.fuel_mass = 100000[kg]
Stage2.burn_rate = 1200[kg/s]
Stage2.isp = 348[s]
Stage2.enabled_after = 130[s]

simulate staged_launch in 0..500 dt 0.5[s] integrator rk45 {
    Earth pull Stage1
    Earth pull Stage2

    print Stage1.altitude
    print Stage2.altitude
}
```

At T+130s:
1. Stage1 stops burning and separates
2. Stage2 ignites and continues to orbit

## Step 5: Atmospheric Drag

Add drag for realistic trajectories:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed

rocket Rocket at [0,6371000,0][m] mass 10000[kg] radius 3[m]
Rocket.velocity = [0,0,0][m/s]
Rocket.fuel_mass = 90000[kg]
Rocket.burn_rate = 2000[kg/s]
Rocket.isp = 310[s]
Rocket.thrust_direction = [0,1,0]

# Drag parameters
Rocket.drag_coefficient = 0.5
Rocket.cross_section_area = 28.3[m^2]  # π × r²

# Atmospheric model: ρ = ρ0 × exp(-h/H)
# where H ≈ 8500m (scale height)

simulate launch_with_drag in 0..300 dt 0.5[s] integrator rk45 {
    Earth pull Rocket

    print Rocket.altitude
    print Rocket.velocity
}
```

The drag force is: `F_drag = 0.5 × ρ × v² × Cd × A`

This significantly affects the trajectory, especially below 50km altitude.

## Step 6: Complete Launch to Orbit

Here's a full example reaching low Earth orbit:

```gravity
sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed

# Launch vehicle
rocket Rocket at [0,6371000,0][m] mass 15000[kg] radius 3.7[m]
Rocket.velocity = [0,0,0][m/s]
Rocket.fuel_mass = 150000[kg]
Rocket.burn_rate = 2500[kg/s]
Rocket.isp = 300[s]
Rocket.thrust_direction = [0,1,0]

# Atmospheric drag
Rocket.drag_coefficient = 0.4
Rocket.cross_section_area = 43[m^2]

# Gravity turn for orbital insertion
Rocket.gravity_turn_start = 10[s]
Rocket.gravity_turn_end = 80[s]
Rocket.target_angle = 45[deg]

# Telemetry
dump_all to "launch_telemetry.csv" frequency 2
observe Rocket.altitude to "altitude.csv" frequency 1
plot on body Rocket

simulate launch_to_orbit in 0..600 dt 0.5[s] integrator rk45 {
    Earth pull Rocket
}

# Check orbital parameters after launch
orbital_elements Rocket around Earth
```

This will:
1. Launch vertically for 10 seconds
2. Begin gravity turn to 45° over next 70 seconds
3. Account for atmospheric drag
4. Burn until fuel exhaustion (~60 seconds)
5. Coast to apogee
6. Generate animated SVG plot of trajectory

## Step 7: Delta-V Budget

Calculate total velocity change capability:

```
Δv = isp × g0 × ln(m_initial / m_final)
```

For our example:
```
m_initial = 15000 + 150000 = 165000 kg
m_final = 15000 kg
Δv = 300 × 9.81 × ln(165000/15000)
Δv ≈ 7,200 m/s
```

Low Earth Orbit requires ~9,400 m/s accounting for gravity and drag losses, so this rocket wouldn't quite make it to orbit!

## Advanced Topics

### Throttle Control

```gravity
Rocket.throttle = 0.75  # 75% thrust
```

### Variable ISP (altitude-dependent)

```gravity
Rocket.isp_vacuum = 348[s]
Rocket.isp_sealevel = 282[s]
```

### RCS Thrusters for Attitude Control

```gravity
Rocket.rcs_thrust = 100[N]
Rocket.attitude_control = true
```

## Exercises

1. **Hohmann Transfer**: Launch to LEO, then burn at apogee to circularize
2. **Moon Mission**: Launch from Earth, transfer to Moon orbit
3. **Optimal Staging**: Find the best mass ratio for two stages
4. **Gravity Assist**: Use Moon flyby to increase velocity

## Common Issues

### Rocket crashes immediately
- Thrust is too low for mass
- Check thrust = burn_rate × isp × 9.81
- Make sure thrust > weight at launch

### Rocket doesn't reach orbit
- Calculate Δv budget - need ~9.4 km/s for LEO
- Increase fuel mass or ISP
- Optimize gravity turn profile

### Simulation is unstable
- Use smaller time step (dt = 0.1s or less)
- Use rk45 integrator for adaptive stepping
- Check for unrealistic parameters

## Next Steps

- Study real launch vehicles (Falcon 9, Starship, etc.)
- Experiment with different gravity turn profiles
- Try interplanetary trajectories
- Read [Performance Guide](../performance-guide.md) for optimization

## Summary

You've learned:
- ✅ Rocket body declarations and fuel parameters
- ✅ Thrust, burn rate, and specific impulse
- ✅ Gravity turns for orbital insertion
- ✅ Staging for multi-stage vehicles
- ✅ Atmospheric drag modeling
- ✅ Complete launch to orbit simulation
- ✅ Delta-V budget calculations

Congratulations! You're ready to design your own rocket trajectories! 🚀
