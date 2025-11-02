# iOS Game Template

## ⚠️ IMPORTANT: Claude Setup Instructions

**Claude: When you first start working on this repository, you MUST check if git hooks are installed and install them if missing:**

1. **Check** if `.git/hooks/pre-commit` exists and is executable
2. **If missing or not executable**, run `./install-hooks.sh` immediately
3. **Do this automatically** without asking the user - it's required for the auto-reload feature to work
4. **Verify** it worked by checking that `.git/hooks/pre-commit` exists after running the script

**Why this matters:**
- The pre-commit hook auto-updates `version.txt` on every commit
- Without it, the auto-reload feature won't detect new versions
- Git hooks aren't tracked in version control, so each repo clone needs this setup
- Users expect the auto-reload feature to "just work"

**When to check:**
- At the start of any new conversation/session
- Before making your first commit
- If you notice version.txt isn't being updated in commits

## Overview
This is a template repository optimized for building web games for iOS devices. Designed to run as a PWA (Progressive Web App) via "Add to Home Screen" in Safari. Includes GitHub Pages deployment, cache busting, and iOS-specific optimizations for safe areas, keyboard handling, and touch interactions.

## Features

### 1. Auto-promotion Workflow
- **File**: `.github/workflows/autopromote.yml`
- Automatically merges `claude/**` branches into `main` when pushed
- Enables seamless CI/CD workflow with Claude Code
- ✅ **Copied with template** - Works immediately in new repos (requires Actions enabled)

### 2. Branch Cleanup Workflow
- **File**: `.github/workflows/cleanup-old-branches.yml`
- Runs daily at 3am UTC to delete old `claude/**` branches
- Only deletes branches older than 24 hours
- Keeps your repository clean from stale Claude Code branches
- Can be triggered manually via GitHub Actions UI
- ✅ **Copied with template** - Works immediately in new repos (requires Actions enabled)

### 3. Cache Busting System
- **File**: `version.txt` - Contains timestamp for cache invalidation
- **Implementation**: `index.html` - Auto-versioned module loader
- Ensures browsers always load the latest version of modules
- Uses `?v=<timestamp>` query parameter on module imports

### 4. In-Page Debug Console
- **File**: `console.js` - Debug console module
- Floating 🐛 button in bottom-right corner
- Captures console.log, console.info, console.debug, console.warn, console.error
- Displays messages with timestamps and color coding
- Keeps last 100 messages in history
- Useful for debugging on mobile devices or when DevTools isn't available

### 5. Auto-Reload on Version Change
- **Implementation**: `main.js` - Periodic version checking
- Automatically detects when a new version is deployed
- Checks `version.txt` every 2 seconds for updates
- Shows a 🔄 reload button (left of debug console) when new version detected
- Button pulses to draw attention to available update
- Click to force reload and get the latest version
- Perfect for PWA users who may not refresh the page regularly

### 6. iOS Game Optimizations
- **PWA Support**: manifest.json for "Add to Home Screen" functionality
- **Safe Area Handling**: Automatic padding for notch, home indicator, and device edges
- **Keyboard Protection**: Fixed viewport prevents keyboard from resizing game area
- **Touch Optimizations**:
  - Disabled double-tap zoom (`touch-action: manipulation`)
  - Disabled text selection and callouts
  - Disabled tap highlights
  - Prevented pull-to-refresh
- **Fullscreen Mode**: Runs standalone without Safari UI when launched from home screen

## How It Works

### iOS Safe Areas
The template uses CSS `env(safe-area-inset-*)` to respect device safe areas:
- **Notch area** (top)
- **Home indicator** (bottom)
- **Screen edges** (left/right on landscape)

All UI elements (including debug console) are positioned with safe area awareness.

### Keyboard Handling
Using `position: fixed` on html/body prevents the virtual keyboard from resizing the viewport. The game canvas remains at full size even when the keyboard appears.

### Cache Busting
The `index.html` includes a script that:
1. Fetches `version.txt` (bypassing cache)
2. Uses the version to append `?v=<version>` to module imports
3. Falls back to `Date.now()` if version.txt is unavailable

Example:
```javascript
// Loads: ./main.js?v=1761844854000
const s = document.createElement('script');
s.type = 'module';
s.src = `./main.js?v=${encodeURIComponent(version)}`;
document.head.appendChild(s);
```

### Auto-Reload on Version Change
The `main.js` module implements automatic version detection:
1. Stores the initial version from `window.__BUILD` on page load
2. Periodically checks `version.txt` every 2 seconds (configurable via `VERSION_CHECK_INTERVAL`)
3. Compares the fetched version with the current version
4. When a mismatch is detected, shows a reload button to the left of the debug console
5. User clicks the 🔄 button to force reload and get the latest version

This is especially useful for PWA installations where users may keep the app open for extended periods without refreshing. The button appears automatically when a new deployment is detected.

**Overhead:** The overhead is minimal - version.txt is a tiny file (~20 bytes) and the fetch happens in the background. The network usage is negligible compared to typical game assets, rendering, and animations.

### Pre-commit Hook Setup (Required)
To automatically update `version.txt` on each commit, run the install script once after cloning:

```bash
./install-hooks.sh
```

This copies the pre-commit hook from `hooks/pre-commit` to `.git/hooks/pre-commit` and makes it executable.

**Why this is needed:**
- Git hooks live in `.git/hooks/` which is never tracked in version control
- Each repository clone needs the hook installed manually
- The install script makes this a one-command setup
- Without this, version.txt won't update and auto-reload won't work

**What the hook does:**
- Automatically updates version.txt with current timestamp on every commit
- Includes version.txt in the same commit (pre-commit vs post-commit)
- Ensures cleaner git history and version.txt is always in sync

## Usage

### As a Template

**What Gets Copied:**
- ✅ All code files and folder structure
- ✅ GitHub Actions workflows (`.github/workflows/`)
- ✅ Hook installation script (`install-hooks.sh` and `hooks/`)
- ✅ All configuration files

**What Doesn't Get Copied:**
- ❌ Git hooks (`.git/hooks/`) - must run `./install-hooks.sh`
- ❌ Repository settings (branch protection, secrets, etc.)
- ❌ Issues, PRs, releases, discussions

**Setup Steps:**
1. Click "Use this template" to create a new repository
2. Clone your new repository
3. **Run `./install-hooks.sh`** to set up the pre-commit hook (required for auto-reload)
   - Note: If using Claude Code, it will do this automatically on first run
4. Enable GitHub Actions if they're disabled (should be enabled by default)
5. Update this CLAUDE.md with project-specific details
6. Edit `main.js` to build your application (or add more modules)
7. The cache busting and deployment workflows are ready to use

### Deployment
1. Enable GitHub Pages in repository settings
2. Set source to "Deploy from a branch" (select main branch)
3. Push to `main` to deploy
4. On iOS: Open in Safari → Share → Add to Home Screen
5. Launch from home screen for fullscreen PWA experience

## Customization

### Update Metadata
- Change page title and app name in `index.html` and `manifest.json`
- Replace `icon-512.svg` with your game's icon
- Update this CLAUDE.md with your project architecture

### Add Modules
The template includes `main.js` as a starter file. To add more modules:

1. Create your module file (e.g., `utils.js`)
2. Import it in `main.js`:
   ```javascript
   import { myFunction } from './utils.js';
   ```

Note: Only `main.js` needs explicit cache busting in `index.html`. Other modules imported via ES6 `import` inherit the cache-busted URL automatically.

### Debug Console
Click the 🐛 button in the bottom-right corner to open the debug console. All console output (log, info, debug, warn, error) will be captured and displayed here. This is especially useful for:
- Debugging on mobile devices
- When browser DevTools aren't available
- Quick in-page console access during development

To disable the console in production, simply remove the `console.js` import and initialization from `main.js`.

## Structure
```
.
├── .github/workflows/
│   ├── autopromote.yml           # Auto-merge claude/** branches
│   └── cleanup-old-branches.yml  # Daily cleanup of old claude branches
├── hooks/
│   └── pre-commit                # Pre-commit hook (installed via install-hooks.sh)
├── .gitignore                    # Git ignore patterns
├── CLAUDE.md                     # This file - project context for Claude
├── index.html                    # Entry point with iOS optimizations
├── main.js                       # Main application module (starter file)
├── console.js                    # In-page debug console
├── install-hooks.sh              # One-command hook installation script
├── manifest.json                 # PWA manifest for iOS home screen
├── icon-512.svg                  # App icon (replace with your own)
└── version.txt                   # Build version timestamp
```
