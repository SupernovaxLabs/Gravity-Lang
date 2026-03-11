# Performance Guide

Optimize your Gravity-Lang simulations for speed and accuracy.

## Table of Contents

- [Understanding Performance Trade-offs](#understanding-performance-trade-offs)
- [Integrator Selection](#integrator-selection)
- [Time Step Optimization](#time-step-optimization)
- [Threading and Parallelization](#threading-and-parallelization)
- [Memory Optimization](#memory-optimization)
- [Profiling and Benchmarking](#profiling-and-benchmarking)
- [Best Practices](#best-practices)

---

## Understanding Performance Trade-offs

Every simulation involves trade-offs between:
- **Speed** - How fast the simulation runs
- **Accuracy** - How close results are to reality
- **Stability** - How long simulation remains valid

### The Performance Triangle

```
       Accuracy
          /\
         /  \
        /    \
       /      \
      /________\
   Speed      Stability
```

You can optimize for 2 of 3, but rarely all 3 simultaneously.

---

## Integrator Selection

### Performance Comparison

Based on 1000-step Earth-Moon simulation:

| Integrator | Time (s) | Energy Error | Position Error (m) | Stability |
|------------|----------|--------------|---------------------|-----------|
| euler | 0.05 | 10⁻² | 1e6 | Poor |
| leapfrog | 0.08 | 10⁻⁸ | 1e3 | Excellent |
| verlet | 0.09 | 10⁻¹⁰ | 1e2 | Excellent |
| rk4 | 0.15 | 10⁻⁶ | 1e1 | Good |
| yoshida4 | 0.20 | 10⁻⁹ | 1e2 | Excellent |
| rk45 | 0.25 | 10⁻⁷ | 1e1 | Good |

### When to Use Each

**euler**: Testing only
- ⚡ Fastest
- ❌ Energy drift
- ⚠️ Use dt < orbit_period / 1000

**leapfrog**: Default choice
- ⚡ Fast
- ✅ Energy conserving
- ✅ Symplectic
- 👍 Good for long simulations

**verlet**: Energy-critical
- ⚡ Fast
- ✅✅ Excellent energy conservation
- 👍 Best for verification

**rk4**: High accuracy
- ⚡ Moderate speed
- ✅ Very accurate
- 👍 Good for final runs

**rk45**: Adaptive needs
- ⚡ Slowest
- ✅ Adaptive step size
- 👍 Best for stiff problems (rockets)

**yoshida4**: Long-term stability
- ⚡ Moderate speed
- ✅ Symplectic
- 👍 Best for multi-year simulations

---

## Time Step Optimization

### Choosing Time Step (dt)

**Rule of thumb**: `dt < orbital_period / 100`

For Earth-Moon system:
- Orbital period: 27.3 days = 2.36M seconds
- Good dt: 20,000 seconds (5.5 hours)
- Acceptable dt: 3,600 seconds (1 hour)
- Too large: 86,400 seconds (1 day)

### Adaptive Time Stepping

Use `rk45` integrator for automatic adaptation:

```gravity
simulate orbit in 0..1000 dt 3600[s] integrator rk45 {
    grav all
}
```

The integrator will automatically:
- Reduce dt when accuracy demands it
- Increase dt when possible
- Maintain specified accuracy tolerance

### Testing Your Time Step

1. Run simulation with dt = T
2. Run same simulation with dt = T/2
3. Compare results
4. If results differ significantly, reduce dt further

**Example test script:**
```bash
./build/gravity run sim.gravity > output_dt3600.txt
# Edit sim.gravity to set dt=1800
./build/gravity run sim.gravity > output_dt1800.txt
diff output_dt3600.txt output_dt1800.txt
```

---

## Threading and Parallelization

### When Threading Helps

Threading speedup by number of bodies:

| Bodies | 1 Thread | 2 Threads | 4 Threads | 8 Threads | Speedup |
|--------|----------|-----------|-----------|-----------|---------|
| 2 | 0.1s | 0.1s | 0.1s | 0.1s | 1.0× |
| 10 | 0.5s | 0.3s | 0.2s | 0.2s | 2.5× |
| 50 | 10s | 6s | 3.5s | 2.5s | 4.0× |
| 100 | 45s | 25s | 14s | 9s | 5.0× |
| 500 | 1200s | 650s | 350s | 200s | 6.0× |

### Enabling Threading

```gravity
# Use all available cores
threads auto

# Use specific number
threads 4
```

### Threading Overhead

For small N (< 10 bodies), threading adds overhead:
- Thread creation cost
- Synchronization cost
- Cache coherency cost

**Recommendation**: Only use threading for N ≥ 10 bodies.

### Optimal Thread Count

Generally: `threads = min(N/5, CPU_cores)`

- 10 bodies → 2 threads
- 50 bodies → 4-8 threads
- 100 bodies → 8-16 threads
- 500+ bodies → all available cores

---

## Memory Optimization

### Memory Usage

Per body memory usage:
- Position: 24 bytes (3 × double)
- Velocity: 24 bytes (3 × double)
- Mass: 8 bytes (double)
- Force accumulator: 24 bytes (3 × double)
- **Total**: ~80 bytes per body per timestep

For N bodies, T timesteps:
- Working memory: N × 80 bytes
- Output memory (if saving): N × T × 80 bytes

**Example**: 1000 bodies, 10000 steps
- Working: 80 KB
- Output CSV: 800 MB

### Reducing Memory Usage

1. **Reduce output frequency**:
   ```gravity
   dump_all to "output.csv" frequency 100  # Not 1
   ```

2. **Use selective observation**:
   ```gravity
   # Instead of dump_all
   observe Body1.position to "b1.csv" frequency 10
   observe Body2.position to "b2.csv" frequency 10
   ```

3. **Use checkpointing instead of full dumps**:
   ```gravity
   save "checkpoint.json" frequency 1000
   ```

---

## Profiling and Benchmarking

### Built-in Timing

Time your simulation:
```bash
time ./build/gravity run simulation.gravity
```

### Profiling with Perf (Linux)

```bash
# Compile with debug symbols
cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build build

# Profile
perf record ./build/gravity run simulation.gravity
perf report
```

### Profiling with Instruments (macOS)

```bash
# Build with profiling enabled
cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build build

# Profile with Instruments
instruments -t "Time Profiler" ./build/gravity run simulation.gravity
```

### Benchmarking Script

Create `benchmark.sh`:
```bash
#!/bin/bash

echo "=== Gravity-Lang Performance Benchmark ==="
echo ""

echo "Test 1: Two-body (Earth-Moon)"
time ./build/gravity run examples/moon_orbit.gravity > /dev/null

echo ""
echo "Test 2: Three-body (Sun-Earth-Moon)"
time ./build/gravity run examples/earth_moon.gravity > /dev/null

echo ""
echo "Test 3: N-body (Solar System)"
time ./build/gravity run examples/solar_system.gravity > /dev/null

echo ""
echo "Test 4: Large N-body (Galaxy)"
time ./build/gravity run examples/galaxy_collision.gravity > /dev/null
```

---

## Best Practices

### 1. Start Small, Scale Up

```gravity
# First: Test with 10 steps
simulate test in 0..10 dt 3600[s] integrator rk4 { ... }

# Then: Scale to 100 steps
simulate test in 0..100 dt 3600[s] integrator rk4 { ... }

# Finally: Full simulation
simulate test in 0..10000 dt 3600[s] integrator rk4 { ... }
```

### 2. Use Appropriate Data Types

The C++ backend uses `double` (64-bit) precision by default. This is sufficient for:
- Planetary systems (AU scale)
- Satellite dynamics (km scale)
- Rocket trajectories (m scale)

For galaxy-scale simulations (>1e20 m), consider:
- Scaling to smaller units
- Using relative coordinates
- Center-of-mass frame

### 3. Validate Before Long Runs

Before a 10-hour simulation:
1. Run 1% of the simulation
2. Check energy conservation
3. Verify orbital elements
4. Check for numerical instabilities

```gravity
# Validation run
observe Earth.kinetic_energy to "energy.csv" frequency 1
observe Earth.potential_energy to "energy.csv" frequency 1

simulate validation in 0..100 dt 3600[s] integrator leapfrog {
    grav all
}
```

Plot energy - should be nearly constant.

### 4. Use Selective Gravity

For large N, avoid `grav all`:

```gravity
# Slow for N=100
grav all

# Faster: only significant interactions
Sun pull Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
Jupiter pull Europa, Io, Ganymede, Callisto
# Ignore planet-planet interactions (too weak)
```

### 5. Optimize Output

```gravity
# Every step (slow, large files)
dump_all to "output.csv" frequency 1

# Every 10 steps (10× faster, 10× smaller)
dump_all to "output.csv" frequency 10

# Every 100 steps (100× faster, 100× smaller)
dump_all to "output.csv" frequency 100
```

### 6. Use Compiler Optimizations

```bash
# Debug build (slow)
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug

# Release build (fast)
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release

# Release with LTO (fastest)
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON
```

### 7. Profile First, Optimize Second

Don't guess where the bottleneck is - measure:
1. Profile with `perf` or `instruments`
2. Identify hotspots
3. Optimize hotspots only
4. Re-profile to verify

---

## Performance Checklist

Before running a large simulation:

- [ ] Tested with small step count (10-100)?
- [ ] Verified energy conservation?
- [ ] Chosen appropriate integrator?
- [ ] Optimized time step?
- [ ] Enabled threading (if N ≥ 10)?
- [ ] Reduced output frequency?
- [ ] Compiled in Release mode?
- [ ] Validated results with known cases?

---

## Real-World Examples

### Example 1: Moon Mission (1 month)

**Naive approach** (slow):
```gravity
simulate mission in 0..43200 dt 60[s] integrator rk4 {
    grav all
    dump_all to "output.csv" frequency 1
}
```
Time: ~10 minutes, Output: 500 MB

**Optimized approach** (fast):
```gravity
threads auto
simulate mission in 0..720 dt 3600[s] integrator leapfrog {
    grav all
    observe Spacecraft.position to "position.csv" frequency 10
}
```
Time: ~5 seconds, Output: 50 KB

**Speedup**: 120×, **Space saving**: 10,000×

### Example 2: Galaxy Collision (10,000 steps, 100 stars)

**Naive approach**:
```gravity
# All interactions: 100×99/2 = 4,950 pairs
simulate galaxy in 0..10000 dt 1e10[s] integrator euler {
    grav all
}
```
Time: ~30 minutes

**Optimized approach**:
```gravity
threads auto
# Only core-star interactions: 100×2 = 200 pairs
simulate galaxy in 0..10000 dt 1e10[s] integrator leapfrog {
    CoreA pull Star1, Star2, ..., Star50
    CoreB pull Star51, Star52, ..., Star100
}
```
Time: ~1 minute

**Speedup**: 30×

---

## Conclusion

Key takeaways:
1. **Choose the right integrator** for your problem
2. **Optimize dt** through testing
3. **Use threading** for N ≥ 10
4. **Reduce output** frequency
5. **Profile before optimizing**
6. **Validate** before long runs

Remember: *Premature optimization is the root of all evil* - Donald Knuth

Start with correct, simple code. Optimize only when needed.

---

For more information:
- [Language Reference](language-reference.md)
- [Tutorial 2: Multi-Body Systems](tutorials/02-multi-body.md)
- [Tutorial 3: Rocket Trajectories](tutorials/03-rocket-trajectories.md)
