# Changelog

All notable changes to Gravity-Lang will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CONTRIBUTING.md with contribution guidelines
- CODE_OF_CONDUCT.md based on Contributor Covenant
- CHANGELOG.md to track project changes
- GitHub issue and pull request templates

## Recent History

### 2026-03-11

#### Fixed
- Avoid duplicate asset uploads in release workflow by narrowing file globs to `dist/*.tar.gz` and `dist/*.zip`

### 2026-02-28

#### Added
- Banner image to README and release pages for visual branding
- Native C++ telemetry plotting with `plot on` DSL directive
- Animated SVG generation directly from interpreter
- `dump_all to "file" frequency N` syntax for full-state CSV export
- Auto-directory creation for all output files (CSV, checkpoints, telemetry)
- DSL quickstart guide in README
- NASA validation script (`tools/validate_against_nasa.sh`)
- Support for `probe` and `rocket` body types in headers
- CI artifact verification with SHA256 checksums
- Windows signature reports in CI (when available)
- Shell quoting helper for safe command construction

#### Changed
- Restructured README into comprehensive, navigable documentation
- Enhanced telemetry dashboard UI (dark theme, three-panel layout)
- Improved error messages for incomplete `orbital_elements` syntax
- Updated multiple example scripts with better comments and features

#### Fixed
- Parser handling of `grav all` now properly defers expansion
- Rocket fuel mass updates no longer double-count
- Simulation step range validation prevents overflow
- Auto-plot behavior respects explicit `plot on|off` directives

## Earlier Releases

For detailed commit history, see: https://github.com/dill-lk/Gravity-Lang/commits/main

---

## Types of Changes

- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** for vulnerability fixes
