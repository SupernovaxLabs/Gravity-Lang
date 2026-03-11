# Gravity-Lang Dockerfile
# Build and run Gravity-Lang simulations in a containerized environment

FROM ubuntu:22.04 AS builder

LABEL maintainer="Gravity-Lang Contributors"
LABEL description="Gravitational physics simulation DSL"

# Install build dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    make \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /build

# Copy source code
COPY . .

# Build Gravity-Lang
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build -j$(nproc)

# Run tests to verify build
RUN cd build && ctest --output-on-failure

# Runtime stage
FROM ubuntu:22.04

# Install runtime dependencies (minimal)
RUN apt-get update && apt-get install -y \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Copy binaries from builder
COPY --from=builder /build/build/gravity /usr/local/bin/gravity
COPY --from=builder /build/build/gravityc /usr/local/bin/gravityc

# Copy examples
COPY --from=builder /build/examples /examples

# Set working directory
WORKDIR /workspace

# Create artifacts directory
RUN mkdir -p /workspace/artifacts

# Set entrypoint
ENTRYPOINT ["gravity"]
CMD ["--help"]

# Usage examples:
# docker build -t gravity-lang .
# docker run -v $(pwd):/workspace gravity-lang run /workspace/my_sim.gravity
# docker run -v $(pwd):/workspace gravity-lang run /examples/moon_orbit.gravity
# docker run -it -v $(pwd):/workspace gravity-lang check /workspace/my_sim.gravity
