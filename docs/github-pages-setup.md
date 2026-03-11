# GitHub Pages Deployment Guide

This guide explains how to enable and deploy GitHub Pages for Gravity-Lang documentation.

## Quick Setup

### Step 1: Enable GitHub Pages

1. Go to your repository: https://github.com/dill-lk/Gravity-Lang
2. Click **Settings** (top navigation)
3. Scroll to **Pages** (left sidebar)
4. Under **Source**, select:
   - **Source**: Deploy from a branch
   - **Branch**: `main`
   - **Folder**: `/ (root)`
5. Click **Save**

### Step 2: Wait for Deployment

GitHub will automatically build and deploy your site. This takes 1-3 minutes.

### Step 3: Access Your Site

Your site will be available at:
```
https://dill-lk.github.io/Gravity-Lang/
```

## What Gets Deployed

The following files create your documentation website:

### Homepage
- `index.md` - Main landing page

### Configuration
- `_config.yml` - Jekyll configuration and theme

### Documentation
- `docs/README.md` - Documentation index
- `docs/tutorials/01-first-orbit.md` - Beginner tutorial
- `docs/tutorials/02-multi-body.md` - Intermediate tutorial
- `docs/tutorials/03-rocket-trajectories.md` - Advanced tutorial

### Auto-Generated
- `README.md` - Renders as project info
- `CONTRIBUTING.md` - Contribution guidelines
- `CODE_OF_CONDUCT.md` - Community standards

## Theme Customization

The site uses the **Cayman** theme. To change themes:

1. Edit `_config.yml`
2. Change `theme:` to one of:
   - `jekyll-theme-minimal`
   - `jekyll-theme-cayman`
   - `jekyll-theme-slate`
   - `jekyll-theme-architect`
   - `jekyll-theme-modernist`

## Custom Domain (Optional)

To use a custom domain like `gravity-lang.org`:

1. Purchase domain from registrar
2. Add CNAME file to repository root:
   ```
   echo "gravity-lang.org" > CNAME
   git add CNAME
   git commit -m "Add custom domain"
   git push
   ```
3. Configure DNS with registrar:
   ```
   A     @     185.199.108.153
   A     @     185.199.109.153
   A     @     185.199.110.153
   A     @     185.199.111.153
   CNAME www   dill-lk.github.io
   ```
4. In GitHub Settings → Pages, enter custom domain

## Local Testing

Test the site locally before deploying:

```bash
# Install Jekyll
gem install bundler jekyll

# Create Gemfile
cat > Gemfile << 'EOF'
source "https://rubygems.org"
gem "github-pages", group: :jekyll_plugins
gem "jekyll-include-cache", group: :jekyll_plugins
EOF

# Install dependencies
bundle install

# Serve locally
bundle exec jekyll serve

# Open http://localhost:4000/Gravity-Lang/
```

## Troubleshooting

### Site not updating
- Check Actions tab for build failures
- Wait 5 minutes after push
- Hard refresh browser (Ctrl+Shift+R)

### 404 errors on pages
- Ensure markdown files have `.md` extension
- Check links use relative paths
- Verify file names match exactly (case-sensitive)

### Theme not applying
- Check `_config.yml` syntax
- Ensure theme is supported by GitHub Pages
- Clear browser cache

## Build Status

Monitor deployment status:
- **Actions tab**: https://github.com/dill-lk/Gravity-Lang/actions
- Look for "pages build and deployment" workflow
- Green ✓ = successful, Red ✗ = failed

## Advanced Features

### Google Analytics (Optional)

Add to `_config.yml`:
```yaml
google_analytics: UA-XXXXXXXXX-X
```

### Search Engine Optimization

The `jekyll-seo-tag` plugin is already configured and will:
- Generate meta tags
- Create sitemap.xml
- Add structured data

### Custom Navigation

Edit `_config.yml` to customize header navigation:
```yaml
header_pages:
  - docs/README.md
  - docs/tutorials/01-first-orbit.md
  - CONTRIBUTING.md
```

## Maintenance

### Updating Content

1. Edit markdown files locally
2. Commit and push to main branch
3. GitHub automatically rebuilds site
4. Check site after 2-3 minutes

### Adding New Pages

1. Create new `.md` file in `docs/`
2. Add front matter:
   ```yaml
   ---
   layout: default
   title: Page Title
   ---
   ```
3. Link from other pages
4. Commit and push

## Resources

- [GitHub Pages Docs](https://docs.github.com/pages)
- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [Cayman Theme](https://github.com/pages-themes/cayman)
- [Markdown Guide](https://www.markdownguide.org/)
