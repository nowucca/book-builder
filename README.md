# Constellize Book Tools

This directory contains the build tools and configuration for "The Constellize Method" book, which uses Pandoc to generate professional PDF/X-1a output with Atkinson Hyperlegible font.

## Features

- **PDF/X-1a Compliance**: Professional print-ready output
- **Atkinson Hyperlegible Font**: Excellent readability for technical content
- **300 DPI Images**: High-quality print resolution
- **Flexible Repository Links**: `{REPO_BASE}` placeholders work across formats
- **Rich Callout System**: Custom callout boxes for code references, architecture notes, etc.
- **Multiple Output Formats**: Web (HTML), PDF, EPUB, and development versions

## Prerequisites

### Required Software

1. **Pandoc 3.0+**
   ```bash
   brew install pandoc
   ```

2. **XeLaTeX (for PDF generation)**
   ```bash
   brew install --cask mactex
   ```

3. **Node.js 16+**
   ```bash
   # Already installed if you're using this system
   node --version
   ```

### Required Fonts

The Atkinson Hyperlegible font family is required for PDF generation:

```bash
cd tools
npm run fonts:install
```

Or download manually from: https://brailleinstitute.org/freefont

## Quick Start

1. **Install dependencies:**
   ```bash
   cd tools
   npm install
   ```

2. **Verify setup:**
   ```bash
   npm run setup
   ```

3. **Build the book:**
   ```bash
   # Development version (fast, local links)
   npm run build:development
   
   # PDF version (print-ready)
   npm run build:pdf
   
   # Web version (GitHub links)
   npm run build:web
   
   # All formats
   npm run build:all
   ```

## Directory Structure

```
tools/
├── config/
│   ├── book.config.js          # Main configuration
│   └── pandoc-defaults.yaml    # Pandoc settings
├── scripts/
│   ├── build-book.js           # Main build script
│   ├── validate-links.js       # Link validation
│   └── process-images.js       # Image processing
├── templates/
│   ├── book.latex              # LaTeX template
│   ├── metadata.yaml           # Book metadata
│   └── filters/                # Pandoc Lua filters
│       ├── callout-filter.lua  # Process callouts
│       └── link-filter.lua     # Process repository links
├── fonts/                      # Atkinson Hyperlegible fonts
├── styles/                     # CSS and LaTeX styling
└── package.json               # Dependencies and scripts
```

## Usage

### Basic Commands

```bash
# Build development version
npm run build

# Build specific format
npm run build:pdf
npm run build:web
npm run build:epub

# Validate links
npm run validate

# Clean build directory
npm run clean

# Watch for changes (development)
npm run watch
```

### Repository Links

Use `{REPO_BASE}` placeholders in your markdown:

```markdown
See the [Prompt Domain Model]({REPO_BASE}/codepromptu/src/shared/src/main/java/com/codepromptu/shared/domain/Prompt.java) for implementation details.
```

The build system will replace `{REPO_BASE}` with the appropriate URL for each output format:
- **Development**: `file:///path/to/local/repo`
- **Web/PDF**: `https://github.com/username/repo/blob/main`

### Callout System

Create rich callout boxes using blockquote syntax:

```markdown
> ** Code Reference: [Prompt Controller]({REPO_BASE}/codepromptu/src/api/src/main/java/com/codepromptu/api/controller/PromptController.java)**
> 
> The PromptController demonstrates RESTful API design with proper error handling and validation. Notice how it delegates business logic to the service layer while maintaining clean separation of concerns.
```

Available callout types:
- ` Code Reference` - Links to specific code files
- `️ System Architecture` - Architectural diagrams and explanations  
- ` Narrative Context` - Links to narrative/process documentation
- `⚡ Implementation Pattern` - Design patterns and best practices
- ` Related Components` - Cross-references to related code

## Configuration

### Book Configuration (`config/book.config.js`)

Main configuration file containing:
- Book metadata (title, author, etc.)
- Repository settings
- Output format configurations
- Font settings
- Callout definitions

### Pandoc Configuration (`config/pandoc-defaults.yaml`)

Pandoc-specific settings:
- PDF/X-1a compliance settings
- Font configuration
- LaTeX packages
- Output options

### Environment Variables

- `REPO_BASE_URL`: Override the default repository base URL

## Output Formats

### PDF (Print-Ready)
- PDF/X-1a compliant
- 300 DPI images
- Atkinson Hyperlegible font
- Professional typography
- Clickable links with footnotes

### Web (HTML)
- Responsive design
- Syntax highlighting
- Interactive callouts
- External links open in new tabs

### Development
- Fast build times
- Local file links
- Simplified styling
- Live reload support

### EPUB
- E-reader compatible
- Reflowable text
- Embedded fonts
- Chapter navigation

## Troubleshooting

### Common Issues

1. **"Pandoc not found"**
   ```bash
   brew install pandoc
   pandoc --version
   ```

2. **"XeLaTeX not found"**
   ```bash
   brew install --cask mactex
   # Restart terminal
   xelatex --version
   ```

3. **"Font not found"**
   ```bash
   npm run fonts:install
   npm run fonts:check
   ```

4. **Build fails with LaTeX errors**
   ```bash
   # Try verbose mode to see detailed errors
   npm run build:pdf -- --verbose
   ```

### Getting Help

- Check the build logs for specific error messages
- Verify all prerequisites are installed
- Ensure fonts are properly installed
- Try building a single chapter first

## Development

### Adding New Scripts

1. Create script in `scripts/` directory
2. Add to `package.json` scripts section
3. Follow existing patterns for error handling and logging

### Modifying Templates

- **LaTeX template**: `templates/book.latex`
- **Metadata**: `templates/metadata.yaml`
- **Filters**: `templates/filters/`

### Testing Changes

```bash
# Test with a single chapter
npm run build:development -- --chapter ch1.md

# Validate output
npm run validate

# Check fonts
npm run fonts:check
```

## License

MIT License - see the main project LICENSE file.
