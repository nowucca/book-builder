# System Patterns: Book-Builder

**Last Updated**: January 2, 2026
**Project**: Reusable Book Publishing System
**Context**: System architecture, build process, and design patterns

---

## System Architecture

### High-Level Overview

```
Book Project (Parent Repository)
├── content files (*.md)
├── metadata.yaml
├── package.json
├── build.js (wrapper)
└── book-builder/ (git submodule)
    ├── scripts/        # Build automation
    ├── templates/      # LaTeX, HTML templates
    ├── fonts/          # Atkinson Hyperlegible
    ├── styles/         # CSS, citation styles
    ├── config/         # Pandoc defaults
    └── examples/       # Sample projects
```

### Core Components

**1. Build Scripts (Node.js)**
```
scripts/
├── build-book.js          # Main build orchestrator
├── validate-emojis.js     # Emoji validation
├── validate-links.js      # Link checking
└── clean-build.js         # Cleanup utility
```

**2. Templates**
```
templates/
├── book-digital.latex     # PDF template (interactive)
├── book-print.latex       # PDF template (print-ready)
├── book.html              # HTML template
├── filters/
│   ├── callout-filter-digital.lua  # Callout rendering (digital)
│   ├── callout-filter-print.lua    # Callout rendering (print)
│   ├── minted-filter.lua           # Code highlighting
│   └── link-filter.lua             # Link processing
└── metadata.yaml          # Template metadata
```

**3. Configuration**
```
config/
├── book.config.js                  # Build configuration
├── pandoc-defaults-digital.yaml    # Pandoc settings (digital)
└── pandoc-defaults-print.yaml      # Pandoc settings (print)
```

**4. Assets**
```
fonts/                     # Atkinson Hyperlegible (10MB)
├── AtkinsonHyperlegibleNext-Regular.ttf
├── AtkinsonHyperlegibleNext-Bold.ttf
└── ... (all weights and styles)

styles/
├── book.css              # HTML styling
└── citations/            # CSL citation styles
```

---

## Build Process Flow

### Phase 1: Validation

```
build-book.js
    ↓
Validate Prerequisites
    ├── Check Pandoc version (3.7+)
    ├── Check XeLaTeX (if PDF target)
    └── Check Node.js dependencies
    ↓
Validate Emoji Usage
    ├── Scan all .md files
    ├── Check against approved list
    └── Report violations (fail build)
    ↓
Continue to Phase 2
```

### Phase 2: Content Processing

```
Process Source Files
    ↓
For each content file (foreword, chapters, appendices):
    ├── Read markdown content
    ├── Inject chapter/appendix images
    ├── Process {REPO_BASE} placeholders
    ├── Apply format-specific transforms
    └── Write to build/intermediate/
    ↓
Copy images to build/assets/
    ↓
Continue to Phase 3
```

### Phase 3: Book Generation

```
Generate Book with Pandoc
    ↓
Build Pandoc Command
    ├── Input: all intermediate .md files (in order)
    ├── Output: build/{target}/constellize-book.{ext}
    ├── Format: pdf / html5 / epub3
    ├── Defaults: config/pandoc-defaults-{variant}.yaml
    ├── Template: templates/book-{variant}.latex
    ├── Filters: Lua filters for processing
    ├── Bibliography: references.json
    ├── Metadata: from metadata.yaml
    └── Engine: xelatex (for PDF)
    ↓
Execute Pandoc
    ↓
XeLaTeX Processing (for PDF)
    ├── Multiple passes for cross-references
    ├── Font loading (Atkinson Hyperlegible)
    ├── Image embedding
    ├── TOC generation
    └── PDF output
    ↓
Build Complete
```

---

## Design Patterns

### Pattern 1: Wrapper Script Delegation

**Context**: Parent book project needs simple interface to build system.

**Solution**: Lightweight wrapper (build.js) delegates to submodule scripts.

**Implementation**:
```javascript
// book/build.js
const buildScript = path.join(__dirname, 'book-builder', 'scripts', 'build-book.js');
const args = ['.', ...process.argv.slice(2)].join(' ');
execSync(`node ${buildScript} ${args}`, { stdio: 'inherit', cwd: __dirname });
```

**Benefits**:
- Simple parent project setup
- All complexity in submodule
- Easy to update build system

### Pattern 2: Content Directory Parameter

**Context**: Build scripts need to work from different locations.

**Solution**: Accept content directory as first parameter, resolve all paths relative to it.

**Implementation**:
```javascript
// book-builder/scripts/build-book.js
const config = require('../config/book.config.js');
config.source.root = process.argv[2] || path.resolve(__dirname, '../..');

const contentDir = config.source.root;
const metadataPath = path.join(contentDir, 'metadata.yaml');
const chaptersPath = path.join(contentDir, 'ch*.md');
```

**Benefits**:
- Works as submodule or standalone
- Flexible deployment options
- Testable with different content

### Pattern 3: Target-Specific Defaults

**Context**: Different output targets need different configurations.

**Solution**: Separate pandoc-defaults-{target}.yaml files for each output variant.

**Files**:
- `pandoc-defaults-digital.yaml` - Interactive PDF with hyperlinks
- `pandoc-defaults-print.yaml` - Print-ready PDF/X-1a

**Implementation**:
```javascript
// In book.config.js
outputs: {
  digital: {
    defaultsFile: 'book-builder/config/pandoc-defaults-digital.yaml',
    format: 'pdf',
    pdfType: 'interactive'
  },
  print: {
    defaultsFile: 'book-builder/config/pandoc-defaults-print.yaml',
    format: 'pdf',
    pdfType: 'x1a'
  }
}
```

**Benefits**:
- Clean separation of concerns
- Easy to maintain variants
- Correct filters for each target

### Pattern 4: Lua Filters for Transformation

**Context**: Markdown needs transformation before LaTeX/HTML generation.

**Solution**: Pandoc Lua filters modify AST during processing.

**Filters**:
1. **minted-filter.lua**: Code block → Minted environment
2. **callout-filter-digital.lua**: ::: callout → tcolorbox with left bar
3. **callout-filter-print.lua**: ::: callout → tcolorbox print-safe
4. **link-filter.lua**: Process and validate links

**Processing Order**:
```
Markdown → Parse → AST
    ↓
minted-filter (code blocks)
    ↓
callout-filter (div elements)
    ↓
link-filter (links)
    ↓
LaTeX/HTML Generation
```

**Benefits**:
- Powerful transformation capabilities
- Format-specific processing
- Maintainable and testable

### Pattern 5: Validation as Quality Gate

**Context**: Catch issues before expensive Pandoc/LaTeX processing.

**Solution**: Pre-flight validation checks that fail fast.

**Validations**:
1. **Emoji Check**: Only approved emojis (avoid rendering issues)
2. **Link Check**: All internal references exist
3. **Structure Check**: Required files present
4. **Prerequisites Check**: Tools available

**Implementation**:
```javascript
async validateEmojiUsage() {
  const violations = await validateEmojis(this.rootDir);
  if (violations.length > 0) {
    throw new Error(`Emoji validation failed: ${violations.length} violations`);
  }
}
```

**Benefits**:
- Fast failure (seconds vs minutes)
- Clear error messages
- Prevents partial builds

### Pattern 6: Build Artifacts Isolation

**Context**: Keep source clean, organize outputs clearly.

**Solution**: All build artifacts in build/ directory (gitignored).

**Structure**:
```
build/
├── intermediate/    # Processed markdown
├── assets/         # Copied images
├── digital/        # Digital PDF output
├── print/          # Print PDF output
├── web/            # HTML output
└── epub/           # EPUB output
```

**Benefits**:
- Clean git status
- Easy to clean (rm -rf build/)
- Organized outputs
- No pollution of source tree

---

## Critical Code Paths

### Path 1: PDF Build (Digital)

```
npm run build:digital
    ↓
book/build.js --target digital
    ↓
book-builder/scripts/build-book.js . --target digital
    ↓
Read config.outputs.digital
    ├── format: pdf
    ├── defaultsFile: pandoc-defaults-digital.yaml
    ├── template: book-digital.latex
    └── filters: [minted, callout-digital, link]
    ↓
Process content files → build/intermediate/
    ↓
pandoc \
  build/intermediate/*.md \
  --defaults=book-builder/config/pandoc-defaults-digital.yaml \
  --template=book-builder/templates/book-digital.latex \
  --output=build/digital/constellize-book.pdf
    ↓
XeLaTeX processes:
    ├── Load Atkinson Hyperlegible fonts
    ├── Apply tcolorbox styling (callouts)
    ├── Process Minted code blocks
    ├── Generate TOC and cross-references
    └── Output PDF
    ↓
build/digital/constellize-book.pdf
```

### Path 2: HTML Build

```
npm run build:web
    ↓
Similar to PDF but:
    ├── format: html5
    ├── No XeLaTeX (direct HTML output)
    ├── CSS styling from styles/book.css
    ├── Filters process differently for HTML
    └── Output: build/web/constellize-book.html
```

### Path 3: Emoji Validation

```
build-book.js starts
    ↓
validateEmojiUsage()
    ↓
validate-emojis.js
    ├── Scan all .md files (excluding node_modules, build/)
    ├── Extract emoji patterns
    ├── Check against approved list
    ├── Report violations with line numbers
    └── Return violations[]
    ↓
If violations.length > 0:
    └── Throw error, stop build
Else:
    └── Continue build
```

---

## Component Relationships

### Dependencies

**build-book.js depends on**:
- Node.js modules: fs-extra, chalk, commander, glob
- External tools: pandoc, xelatex
- Configuration: book.config.js
- Validation: validate-emojis.js
- Content: Parent project .md files

**Pandoc depends on**:
- Defaults files: pandoc-defaults-*.yaml
- Templates: book-*.latex
- Filters: *.lua
- Fonts: Atkinson Hyperlegible TTF files
- Content: Processed markdown in build/intermediate/

**XeLaTeX depends on**:
- LaTeX packages: tcolorbox, minted, hyperref, geometry
- Fonts: Embedded TTF files
- Generated .tex file from Pandoc

### Data Flow

```
User Content (.md)
    ↓ (processing)
Intermediate Files
    ↓ (pandoc)
LaTeX/HTML Document
    ↓ (xelatex or direct)
Final Output (PDF/HTML/EPUB)
```

---

## Evolution Strategy

### Versioning Approach

**Semantic Versioning**: MAJOR.MINOR.PATCH

- **MAJOR**: Breaking changes (template changes, config format)
- **MINOR**: New features (new filters, templates)
- **PATCH**: Bug fixes, documentation

**Current**: 1.0.0 (post-extraction from Constellize book)

### Upgrade Path for Parent Projects

**Scenario**: book-builder gets new feature

**Process**:
1. Develop and test in book-builder
2. Tag new version (e.g., v1.1.0)
3. Parent projects update submodule:
   ```bash
   cd book-builder
   git pull origin main
   cd ..
   git add book-builder
   git commit -m "Update book-builder to v1.1.0"
   ```

### Backward Compatibility

**Commitment**: Maintain backward compatibility within major versions.

**Breaking Changes Require**:
- Major version bump
- Migration guide
- Deprecation warnings in prior version
- Clear changelog

---

## Testing Strategy

### Unit Testing
- Lua filters (test AST transformations)
- Configuration loading
- Path resolution

### Integration Testing
- Build complete book from test content
- Verify all formats output correctly
- Check validation catches known issues

### Smoke Testing
- Example projects build successfully
- Fresh submodule integration works
- Common customizations work

---

## Decision Log

### Decision 1: Include Fonts vs External Requirement
**Decision**: Include fonts in repository (~10MB)
**Rationale**: Self-contained beats size concerns. Makes setup trivial.
**Date**: December 25, 2024

### Decision 2: Lua Filters vs Pandoc Extensions
**Decision**: Use Lua filters for transformations
**Rationale**: More powerful, better documented, easier to maintain
**Date**: December 2024

### Decision 3: Node.js vs Bash for Build Scripts
**Decision**: Use Node.js
**Rationale**: Cross-platform, better error handling, easier to extend
**Date**: December 2024

### Decision 4: Git Submodule vs NPM Package
**Decision**: Git submodule
**Rationale**: Source code access, easier customization, no npm registry dependency
**Date**: December 25, 2024

---

**Document Owner**: Steve Atkinson
**Last Updated**: January 2, 2026
**Next Review**: After major feature additions or architecture changes
