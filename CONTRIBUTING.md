# Contributing to Gravity-Lang

Thank you for your interest in contributing to Gravity-Lang! This document provides guidelines and instructions for contributing to the project.

**Maintainer**: [@dill-lk](https://github.com/dill-lk)

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Submitting Changes](#submitting-changes)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/Gravity-Lang.git
   cd Gravity-Lang
   ```
3. **Add the upstream repository**:
   ```bash
   git remote add upstream https://github.com/dill-lk/Gravity-Lang.git
   ```

## How to Contribute

### Reporting Bugs

Before creating a bug report:
- Check the existing issues to avoid duplicates
- Collect information about the bug (OS, compiler version, error messages)
- Create a minimal reproduction script if possible

When filing a bug report, include:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected vs. actual behavior
- Your environment (OS, compiler, CMake version)
- Any relevant `.gravity` script that triggers the bug
- Error messages or logs

### Suggesting Enhancements

Enhancement suggestions are welcome! Please:
- Use a clear, descriptive title
- Provide a detailed description of the proposed feature
- Explain why this enhancement would be useful
- Include example `.gravity` syntax if applicable
- Consider backward compatibility

### Pull Requests

1. Create a new branch for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following the [coding standards](#coding-standards)

3. Add or update tests as needed

4. Update documentation if you've changed functionality

5. Commit your changes with clear, descriptive messages:
   ```bash
   git commit -m "Add feature: description of what you did"
   ```

6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

7. Open a Pull Request with:
   - Clear title describing the change
   - Description of what changed and why
   - Reference to any related issues
   - Screenshots or examples if applicable

## Development Setup

### Prerequisites

- CMake 3.16 or higher
- C++17 or C++20 compatible compiler:
  - GCC 7+ or Clang 5+ on Linux/macOS
  - MSVC 2017+ on Windows
- Git

### Building

```bash
cmake -S . -B build
cmake --build build -j
```

### Running Tests

```bash
cd build
ctest --output-on-failure
```

### Running Examples

```bash
./build/gravity run examples/moon_orbit.gravity
```

## Coding Standards

### C++ Code Style

- Use C++17/20 standard features
- Follow existing code formatting in the repository
- Use meaningful variable and function names
- Keep functions focused and concise
- Add comments for complex logic
- Prefer `const` and `constexpr` where applicable

### DSL (.gravity files)

- Use clear, descriptive body names
- Include comments explaining the physical scenario
- Use appropriate units with tags (e.g., `[km]`, `[kg]`)
- Format for readability with consistent indentation

### Commit Messages

Follow this format:
```
type: brief description (50 chars or less)

Longer explanation if necessary. Wrap at 72 characters.

Fixes #123
```

Types: `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `chore`

Examples:
- `feat: add Barnes-Hut algorithm for N-body optimization`
- `fix: correct RK45 adaptive step size calculation`
- `docs: update README with MOND gravity examples`

## Submitting Changes

### Before Submitting

- [ ] Code builds without warnings
- [ ] All tests pass (`ctest --output-on-failure`)
- [ ] New features have tests
- [ ] Documentation is updated
- [ ] Commit messages are clear
- [ ] Branch is up to date with upstream main

### Pull Request Process

1. Ensure your PR has a clear description
2. Link any related issues
3. Be responsive to review comments
4. Update your PR based on feedback
5. Squash commits if requested

## Testing

### Adding Tests

Tests are defined in `CMakeLists.txt`:

```cmake
add_test(NAME test_name COMMAND gravity run ${CMAKE_SOURCE_DIR}/examples/test.gravity)
```

### Test Categories

1. **Example tests**: Verify example scripts run without error
2. **Parser tests**: Test DSL parsing and validation
3. **Physics tests**: Verify numerical accuracy of integrators
4. **Feature tests**: Test specific functionality (checkpointing, plotting, etc.)

### Writing Good Tests

- Test one thing at a time
- Use meaningful test names
- Include both positive and negative test cases
- Test edge cases and error conditions
- Keep test scripts simple and focused

## Documentation

### README Updates

Update the README.md when:
- Adding new DSL syntax or features
- Changing CLI flags or usage
- Adding new integrators or physics models
- Updating build requirements

### Code Comments

Add comments for:
- Complex algorithms or physics calculations
- Non-obvious implementation decisions
- Workarounds for platform-specific issues
- References to papers or external resources

### Example Scripts

When adding features, include:
- A working example in `examples/`
- Clear comments explaining the scenario
- Appropriate output (CSV, plots) if applicable

## Questions?

- Open an issue with the `question` label
- Check existing issues and documentation first
- Be specific about what you need help with

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

## Contributors

All contributors are recognized in our [CONTRIBUTORS.md](CONTRIBUTORS.md) file. Thank you to everyone who helps make Gravity-Lang better!

---

Thank you for contributing to Gravity-Lang! Your efforts help make gravitational physics simulations accessible to everyone.
