## Description

<!-- Provide a clear and concise description of what this PR does -->

## Type of Change

<!-- Mark the relevant option with an 'x' -->

- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring
- [ ] Test addition/improvement
- [ ] Build/CI improvement

## Related Issues

<!-- Link to related issues: Fixes #123, Closes #456, Related to #789 -->

## Changes Made

<!-- List the specific changes you made -->

-
-
-

## Testing

<!-- Describe the tests you ran and how to reproduce them -->

### Test Environment

- **OS**:
- **Compiler**:
- **CMake Version**:

### Test Commands

```bash
# Build
cmake -S . -B build
cmake --build build -j

# Run tests
cd build
ctest --output-on-failure

# Manual testing (if applicable)
./build/gravity run examples/your_test.gravity
```

### Test Results

<!-- Paste relevant test output or screenshots -->

```
# Test output here
```

## Checklist

<!-- Mark completed items with an 'x' -->

- [ ] My code follows the project's coding standards
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have updated the documentation accordingly
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

## DSL Changes (if applicable)

<!-- If you've changed the .gravity DSL syntax, provide examples -->

### Before

```gravity
# Old syntax
```

### After

```gravity
# New syntax
```

## Breaking Changes

<!-- If this PR introduces breaking changes, describe them and provide migration instructions -->

## Additional Notes

<!-- Any additional information that reviewers should know -->

## Screenshots (if applicable)

<!-- Add screenshots, plots, or animations showing the changes in action -->
