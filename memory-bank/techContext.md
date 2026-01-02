# Tech Context: Book-Builder

**Last Updated**: January 2, 2026
**Project**: Reusable Book Publishing System
**Context**: Technologies, dependencies, setup, and troubleshooting

---

## Technology Stack

### Core Technologies

#### Document Processing
- **Pandoc 3.7+**: Universal document converter
  - Markdown → LaTeX/HTML/EPUB
  - Citation processing (--citeproc)
  - Template system
  - Lua filter support

#### PDF Generation
- **XeLaTeX** (TeX Live 2025): Advanced PDF typesetting
  - Unicode support
  - Custom font loading
  - Professional typography
  - PDF/X-1a compliance

#### Build Automation
- **Node.js 16+**: JavaScript runtime
  - Build orchestration scripts
  - File processing
  - Validation tools

- **NPM**: Package management
  - Dependency management
  - Script execution

### Supporting Technologies

#### LaTeX Packages
- **tcolorbox**: Colored callout boxes with rounded corners
- **minted**: Advanced code syntax highlighting
- **hyperref**: PDF hyperlinks and bookmarks
- **geometry**: Page layout control
- **fontspec**: Font loading and configuration
- **graphicx**: Image inclusion
- **babel**: Language support

#### Node.js Dependencies
```json
{
  "dependencies": {},
  "devDependencies": {
    "chalk": "^4.1.2",      // Terminal colors
    "commander": "^9.4.1",   // CLI argument parsing
    "fs-extra": "^11.0.0",   // Enhanced file operations
    "glob": "^8.0.3",        // File pattern matching
    "yaml": "^2.0.0"         // YAML parsing
  }
}
```

#### Fonts
- **Atkinson Hyperlegible**: Primary typography
  - Family: AtkinsonHyperlegibleNext
  - Variants: Regular, Bold, Italic, BoldItalic
  - Formats: TTF (PDF), WOFF2 (web)
  - Size: ~10MB total
  - License: SIL Open Font License

---

## Development Environment

### Prerequisites

**Required Software**:
```bash
# macOS installation
brew install node        # Node.js 16+
brew install pandoc      # Pandoc 3.7+
brew install --cask mactex  # XeLaTeX (TeX Live 2025)

# Verification
node --version    # v16.0.0+
npm --version     # 8.0.0+
pandoc --version  # 3.7+
xelatex --version # TeX Live 2025
```

**Optional Tools**:
```bash
brew install git          # Version control
brew install gh           # GitHub CLI
```

### Installation

#### As Git Submodule (Recommended)

**In Parent Book Project**:
```bash
# Add book-builder as submodule
git submodule add https://github.com/constellize/book-builder.git

# Initialize submodule
git submodule update --init --recursive

# Install dependencies
cd book-builder && npm install
```

#### Standalone (For Development)

```bash
# Clone repository
git clone https://github.com/constellize/book-builder.git
cd book-builder

# Install dependencies
npm install

# Run example
cd examples/sample-book
npm run build:pdf
```

### Directory Structure

```
book-builder/
├── scripts/                # Build automation
│   ├── build-book.js       # Main build script
│   ├── validate-emojis.js  # Emoji validation
│   └── clean-build.js      # Cleanup utility
├── config/                 # Configuration
│   ├── book.config.js      # Build configuration
│   ├── pandoc-defaults-digital.yaml
│   └── pandoc-defaults-print.yaml
├── templates/              # Document templates
│   ├── book-digital.latex  # PDF template (digital)
│   ├── book-print.latex    # PDF template (print)
│   ├── filters/            # Lua filters
│   │   ├── callout-filter-digital.lua
│   │   ├── callout-filter-print.lua
│   │   ├── minted-filter.lua
│   │   └── link-filter.lua
│   └── metadata.yaml       # Template metadata
├── fonts/                  # Typography (~10MB)
│   ├── AtkinsonHyperlegibleNext-*.ttf
│   └── AtkinsonHyperlegibleNext-*.woff2
├── styles/                 # Styling
│   ├── book.css            # HTML styles
│   └── citations/          # CSL citation styles
├── examples/               # Sample projects
│   └── sample-book/        # Complete example
├── memory-bank/            # Project documentation
├── package.json            # NPM configuration
├── README.md               # Documentation
└── LICENSE                 # SIL OFL (fonts), MIT (code)
```

---

## Configuration

### Parent Project Setup

**Required Files**:

**1. metadata.yaml** (Book-specific configuration)
```yaml
---
title: "Your Book Title"
subtitle: "Your Subtitle"
author: "Your Name"
publisher: "Publisher Name"
version: "1.0.0"
edition: "First Edition"

# Book structure
book:
  chapters:
    - "Chapter 1 Title"
    - "Chapter 2 Title"
  appendices:
    - "Appendix A Title"

# PDF metadata
pdfx:
  title: "Full Title for PDF Metadata"
  author: "Author Name"
  subject: "Book Subject"
  keywords: "keyword1, keyword2"
---
```

**2. package.json** (Build scripts)
```json
{
  "name": "your-book",
  "version": "1.0.0",
  "scripts": {
    "build:digital": "node book-builder/scripts/build-book.js . --target digital",
    "build:print": "node book-builder/scripts/build-book.js . --target print",
    "build:web": "node book-builder/scripts/build-book.js . --target web",
    "build:epub": "node book-builder/scripts/build-book.js . --target epub",
    "clean": "rm -rf build/"
  }
}
```

**3. Content Files**
```
your-book/
├── ch1.md              # Chapter 1
├── ch2.md              # Chapter 2
├── appA.md             # Appendix A
├── images/             # Images
│   ├── chapters/       # Chapter images
│   └── appendices/     # Appendix images
└── references.json     # Bibliography (optional)
```

### Customization Options

**book.config.js** (Advanced configuration)
```javascript
module.exports = {
  book: {
    title: "Your Book",
    author: "Your Name"
  },
  source: {
    chapters: ['ch[1-9].md'],
    appendices: ['app[A-Z].md']
  },
  outputs: {
    digital: {
      format: 'pdf',
      dpi: 300,
      defaultsFile: 'book-builder/config/pandoc-defaults-digital.yaml'
    }
  }
};
```

---

## Build Workflows

### Digital PDF Build

```bash
npm run build:digital
```

**Process**:
1. Validate prerequisites (Pandoc, XeLaTeX)
2. Validate emoji usage in content
3. Process source files (inject images, resolve placeholders)
4. Copy images to build/assets/
5. Run Pandoc with:
   - Defaults: pandoc-defaults-digital.yaml
   - Template: book-digital.latex
   - Filters: minted, callout-digital, link
   - Engine: xelatex
6. Output: `build/digital/book.pdf`

**Expected Time**: 30-60 seconds for typical book

### Print PDF Build

```bash
npm run build:print
```

**Differences from Digital**:
- Uses `pandoc-defaults-print.yaml`
- Uses `book-print.latex` template
- Uses `callout-filter-print.lua` (print-safe styling)
- PDF/X-1a compliant output
- Optimized for physical printing

### HTML Build

```bash
npm run build:web
```

**Process**:
- No XeLaTeX (direct HTML output)
- Uses HTML template
- Applies CSS styling from `styles/book.css`
- Output: `build/web/book.html`

**Expected Time**: 10-20 seconds

### EPUB Build

```bash
npm run build:epub
```

**Process**:
- Similar to HTML but EPUB3 format
- Optimized for e-readers
- Output: `build/epub/book.epub`

---

## Common Issues & Troubleshooting

### Issue 1: Pandoc Not Found

**Symptom**: `command not found: pandoc`

**Solution**:
```bash
brew install pandoc
pandoc --version  # Verify 3.7+
```

### Issue 2: XeLaTeX Not Found

**Symptom**: `command not found: xelatex`

**Solution**:
```bash
brew install --cask mactex
# Add to PATH if needed
export PATH="/Library/TeX/texbin:$PATH"
```

### Issue 3: Font Errors

**Symptom**: `Font Atkinson Hyperlegible not found`

**Cause**: Submodule not initialized or fonts/ missing

**Solution**:
```bash
git submodule update --init --recursive
ls book-builder/fonts/  # Verify fonts present
```

### Issue 4: Node Module Errors

**Symptom**: `Cannot find module 'fs-extra'`

**Solution**:
```bash
cd book-builder
rm -rf node_modules package-lock.json
npm install
```

### Issue 5: Build Fails with Emoji Error

**Symptom**: `Emoji validation failed: X violations`

**Cause**: Content contains unapproved emojis

**Solution**:
1. Check error output for specific emojis and locations
2. Either:
   - Remove unapproved emojis, OR
   - Add to approved list in `validate-emojis.js`

### Issue 6: Minted/Syntax Highlighting Errors

**Symptom**: LaTeX error with minted package

**Cause**: Python Pygments not installed or -shell-escape not enabled

**Solution**:
```bash
# Install Pygments
pip install Pygments

# Verify build uses -shell-escape (already in config)
```

### Issue 7: Callout Boxes Not Rendering

**Symptom**: Callouts appear as plain text

**Cause**: Wrong filter or template for target

**Solution**:
- Verify using correct target (digital/print)
- Check filter file exists: `templates/filters/callout-filter-digital.lua`
- Verify tcolorbox LaTeX package installed

---

## Performance Considerations

### Build Times

**Typical Book (200 pages, 50 images)**:
- Digital PDF: 30-60 seconds
- Print PDF: 35-70 seconds
- HTML: 10-20 seconds
- EPUB: 15-25 seconds

**Factors Affecting Speed**:
- Number of pages
- Image count and size
- Code block quantity (syntax highlighting)
- Bibliography size
- System resources

**Optimization Tips**:
- Use optimized images (reasonable DPI)
- Cache XeLaTeX auxiliary files during development
- Use incremental builds (pandoc --incremental)

### Repository Size

**book-builder Repository**:
- Total: ~15-20 MB
- Fonts: ~10 MB
- Scripts/templates: ~5 MB
- Examples: ~2-3 MB

**Considerations**:
- Fonts are largest contributor
- Acceptable for git repository
- Benefits outweigh size concerns

---

## Testing

### Manual Testing Checklist

**PDF Build**:
- [ ] Builds without errors
- [ ] Fonts render correctly
- [ ] Images appear in correct locations
- [ ] Code blocks have syntax highlighting
- [ ] Callout boxes have colored backgrounds
- [ ] Table of contents is accurate
- [ ] Cross-references work
- [ ] Hyperlinks function (digital PDF)

**HTML Build**:
- [ ] Builds without errors
- [ ] Styling looks correct
- [ ] Images load
- [ ] Code blocks formatted
- [ ] Responsive on mobile

**EPUB Build**:
- [ ] Builds without errors
- [ ] Opens in e-reader
- [ ] Navigation works
- [ ] Images display

### Validation Testing

```bash
# Run emoji validation standalone
node book-builder/scripts/validate-emojis.js .

# Run link validation (if available)
node book-builder/scripts/validate-links.js .
```

---

## Deployment

### As Submodule in Book Projects

**Initial Setup**:
```bash
cd your-book-project
git submodule add https://github.com/constellize/book-builder.git
git submodule update --init --recursive
cd book-builder && npm install
```

**Updates**:
```bash
cd book-builder
git pull origin main
cd ..
git add book-builder
git commit -m "Update book-builder to latest"
```

### Standalone Development

**Setup**:
```bash
git clone https://github.com/constellize/book-builder.git
cd book-builder
npm install
```

**Testing Changes**:
```bash
cd examples/sample-book
npm run build:digital
# Verify changes work
```

**Publishing**:
```bash
# Update version in package.json
# Tag release
git tag -a v1.1.0 -m "Version 1.1.0"
git push origin main --tags
```

---

## Dependencies Management

### Updating Dependencies

```bash
# Check for outdated packages
npm outdated

# Update specific package
npm update chalk

# Update all (carefully)
npm update

# Verify builds still work
cd examples/sample-book && npm run build:digital
```

### Security

```bash
# Audit dependencies
npm audit

# Fix vulnerabilities
npm audit fix
```

---

## Future Technical Considerations

### Potential Upgrades
- Pandoc 4.x when released
- Node.js LTS version updates
- TeX Live annual updates
- Font version updates

### Platform Support
- Currently: macOS primary
- Future: Linux support verified
- Future: Windows support (WSL2)

### Scalability
- Handles books up to 1000+ pages
- Multiple concurrent builds
- CI/CD integration ready

---

**Document Owner**: Steve Atkinson
**Last Updated**: January 2, 2026
**Next Review**: After major dependency updates or platform changes
