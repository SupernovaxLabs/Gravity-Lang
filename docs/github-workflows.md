# GitHub Workflows Documentation

This document describes the automated workflows configured for the Gravity-Lang repository.

## Overview

The repository uses GitHub Actions to automate various tasks including PR labeling, contributor recognition, version tagging, and maintenance.

## Workflows

### 1. PR Auto-Labeler (`pr-labeler.yml`)

**Triggers**: When a PR is opened, edited, synchronized, or reopened

**What it does**:
- **Path-based labeling**: Automatically adds labels based on which files were changed (e.g., `cpp`, `documentation`, `tests`)
- **Size labeling**: Adds size labels (`size/XS`, `size/S`, `size/M`, `size/L`, `size/XL`) based on lines changed
- **Title-based labeling**: Detects conventional commit prefixes (`feat:`, `fix:`, `docs:`, etc.) and adds appropriate labels
- **First-time contributor**: Detects first-time contributors and adds welcome message

**Labels added**:
- Category: `cpp`, `documentation`, `examples`, `tests`, `build`, `ci/cd`, `docker`, `tools`
- Size: `size/XS` through `size/XL`
- Type: `enhancement`, `bug`, `documentation`, `tests`, `refactoring`, `performance`
- Status: `work-in-progress`, `breaking-change`
- Special: `first-time-contributor`

### 2. Contributor Recognition (`contributor-recognition.yml`)

**Triggers**: When a PR is merged or an issue is closed

**What it does**:
- **Thank contributors**: Posts thank-you messages when PRs are merged
- **First-time celebrations**: Special message for first merged contribution
- **Milestone tracking**: Tracks contribution count and celebrates milestones (1, 5, 10, 25, 50 contributions)
- **Issue reporters**: Thanks helpful issue reporters

**Labels added**:
- `contributor-1`, `contributor-5`, `contributor-10`, `contributor-25`, `contributor-50`

**Example messages**:
```
🎉 Congratulations @username on your first merged contribution to Gravity-Lang!
```
```
🏆 Milestone Achievement! 🏆
@username has reached 10 merged contributions to Gravity-Lang!
```

### 3. PR Auto-Tag (`pr-auto-tag.yml`)

**Triggers**: When a PR is opened, edited, synchronized, or reopened

**What it does**:
- **Version impact analysis**: Determines what type of version bump the PR will cause
- **Semantic versioning**: Follows semver based on PR type
  - Breaking changes → Major version bump
  - New features → Minor version bump
  - Bug fixes → Patch version bump
- **Version labels**: Adds `version:major`, `version:minor`, or `version:patch` labels
- **Comment with details**: Posts a comment explaining the version impact

**Example comment**:
```
✨ Version Impact

This PR will result in a minor version bump:
- Current version: v1.2.3
- Next version (if merged): v1.3.0

🎉 This adds new features - minor version will be incremented.
```

### 4. Stale Issues and PRs (`stale.yml`)

**Triggers**: Daily at 00:00 UTC (or manual trigger)

**What it does**:
- **Mark stale**: Issues/PRs with no activity for 60 days are marked as stale
- **Auto-close**: Stale items are closed after 14 additional days
- **Exemptions**: Won't mark items as stale if they have:
  - Labels: `pinned`, `security`, `help-wanted`, `good-first-issue`
  - Assignees
- **Activity detection**: Removes stale label if new activity occurs

### 5. Label Sync (`label-sync.yml`)

**Triggers**:
- When `.github/labels.yml` is updated
- Manual trigger

**What it does**:
- **Syncs labels**: Ensures all labels defined in `labels.yml` exist in the repository
- **Updates descriptions**: Updates label colors and descriptions
- **Preserves existing**: Doesn't delete labels not in the config file

### 6. Build and Release (`build.yml`)

**Note**: This workflow already existed in the repository.

**What it does**:
- **Auto-tagging**: Creates version tags on main/master pushes
- **Cross-platform builds**: Builds for Linux, macOS, and Windows
- **Release creation**: Publishes GitHub releases with binaries
- **Testing**: Runs test suite on all platforms

## Label Configuration

Labels are defined in `.github/labels.yml` and automatically synced. The configuration includes:

### Label Categories

1. **Type Labels**: `bug`, `enhancement`, `documentation`, `question`
2. **Status Labels**: `work-in-progress`, `blocked`, `ready-for-review`, `needs-review`
3. **Priority Labels**: `priority-critical`, `priority-high`, `priority-medium`, `priority-low`
4. **Size Labels**: `size/XS`, `size/S`, `size/M`, `size/L`, `size/XL`
5. **Category Labels**: `cpp`, `examples`, `tests`, `build`, `ci/cd`, `docker`, `tools`, `dependencies`
6. **Special Labels**: `good-first-issue`, `help-wanted`, `first-time-contributor`, `security`
7. **Contributor Milestones**: `contributor-1`, `contributor-5`, `contributor-10`, `contributor-25`, `contributor-50`
8. **Version Labels**: `version:major`, `version:minor`, `version:patch`

## Labeler Configuration

The `.github/labeler.yml` file configures path-based automatic labeling:

- **documentation**: Any `*.md` files or `docs/` directory
- **cpp**: C++ source files in `cpp/` directory
- **examples**: `.gravity` files in `examples/`
- **build**: CMake files
- **ci/cd**: Workflow files
- **docker**: Docker-related files
- **tests**: Test files
- **tools**: Scripts and tools

## Best Practices

### For Contributors

1. **Use conventional commits** in PR titles:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation
   - `test:` for tests
   - `refactor:` for refactoring
   - `perf:` for performance improvements
   - `chore:` for maintenance

2. **Add `!:` for breaking changes**:
   ```
   feat!: redesign API structure
   ```

3. **Draft PRs**: Mark work-in-progress PRs as draft to get the `work-in-progress` label

### For Maintainers

1. **Review automation**: Check that labels are correctly applied
2. **Milestone celebrations**: The bot will automatically celebrate contribution milestones
3. **Stale management**: Review stale issues/PRs before they auto-close
4. **Label sync**: Update `.github/labels.yml` to add/modify labels

## Manual Actions

### Trigger Label Sync

```bash
# Via GitHub UI: Actions → Sync Labels → Run workflow
# Or push changes to .github/labels.yml
```

### Trigger Stale Check

```bash
# Via GitHub UI: Actions → Stale Issues and PRs → Run workflow
```

## Permissions

All workflows use the default `GITHUB_TOKEN` with these permissions:
- `pull-requests: write` - Add labels and comments to PRs
- `issues: write` - Add labels and comments to issues
- `contents: read` - Read repository contents

## Troubleshooting

### Labels not being added

1. Check workflow runs in the Actions tab
2. Verify permissions are correct
3. Ensure `.github/labeler.yml` paths are correct

### First-time contributor not detected

The workflow checks for merged PRs from the same author. Draft PRs and unmerged PRs don't count.

### Version labels incorrect

The version bump is determined by:
1. Labels: `breaking-change` → major
2. Labels/title: `enhancement`/`feat:` → minor
3. Everything else → patch

## Future Enhancements

Potential additions:
- Automatic PR assignment
- Code coverage reporting
- Automatic changelog generation
- Release notes automation
- Automated testing on PR comments (e.g., `/test`)

---

For questions or suggestions about these workflows, please open an issue!
