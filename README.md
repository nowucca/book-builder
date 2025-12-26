# Book Builder

A reusable Pandoc + XeLaTeX build system for creating professional technical books in PDF, HTML, and EPUB formats.

## Features

- **Multiple Output Formats**: PDF (print-ready), HTML (web), EPUB (e-readers)
- **PDF/X-1a Compliance**: Professional print-ready output
- **Atkinson Hyperlegible Font**: Excellent readability (~10MB fonts included)
- **Syntax Highlighting**: Beautiful code blocks with language-specific styling
- **Custom Callout System**: Note, warning, caution, info, and example boxes
- **Flexible Configuration**: YAML-based metadata and settings
- **Image Processing**: Automatic optimization and DPI handling
- **Link Processing**: Smart repository and cross-reference handling

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
   brew install node
   ```

## Installation

### As a Standalone Tool

```bash
# Clone the repository
git clone https://github.com/satkinson/book-builder.git
cd book-builder

# Install dependencies
npm install

# Verify setup
npm run pandoc:test
```

### As a Git Submodule (in your book project)

```bash
cd your-book-project
git submodule add https://github.com/satkinson/book-builder.git book-builder
git submodule update --init --recursive
cd book-builder
npm install
```

## Quick Start

### 1. Try the Example

```bash
# Build the sample book
node scripts/build-book.js examples/sample-book --target pdf
```

Output will be in `examples/sample-book/build/`.

### 2. Create Your Own Book

```bash
# Copy the example as a template
cp -r examples/sample-book my-book
cd my-book

# Edit metadata.yaml with your book information
# Add your chapter files (chapter1.md, chapter2.md, etc.)

# Build your book
node ../scripts/build-book.js . --target pdf
```

## Usage

### Building from Book-Builder Directory

```bash
# Build specific format
node scripts/build-book.js /path/to/book-content --target pdf
node scripts/build-book.js /path/to/book-content --target web
node scripts/build-book.js /path/to/book-content --target epub

# Build all formats
node scripts/build-book.js /path/to/book-content --target all
```

### Building from Your Book Directory (with submodule)

```bash
# From your book directory
node book-builder/scripts/build-book.js . --target pdf
```

## Directory Structure

### Book-Builder Structure

```
book-builder/
├── config/
│   └── pandoc-defaults.yaml    # Pandoc settings
├── scripts/
│   ├── build-book.js           # Main build script
│   ├── validate-links.js       # Link validation
│   └── process-images.js       # Image processing
├── templates/
│   ├── book-digital.latex      # PDF template (digital)
│   ├── book-print.latex        # PDF template (print)
│   └── filters/                # Pandoc Lua filters
│       ├── callout-filter.lua  # Process callouts
│       └── link-filter.lua     # Process repository links
├── fonts/                      # Atkinson Hyperlegible (~10MB)
├── styles/                     # CSS and styling
├── examples/
│   └── sample-book/            # Example book project
└── package.json               # Dependencies and scripts
```

### Your Book Project Structure

```
my-book/
├── metadata.yaml              # Book metadata (required)
├── chapter1.md                # Your chapters
├── chapter2.md
├── images/                    # Book images (optional)
├── build/                     # Generated output (created automatically)
└── book-builder/              # Submodule (if using)
```

## Book Metadata (metadata.yaml)

Create a `metadata.yaml` file in your book directory:

```yaml
---
title: "Your Book Title"
subtitle: "Optional Subtitle"
author: "Your Name"
date: "2024"
version: "1.0"
edition: "First Edition"
isbn: ""
isbn13: ""
publisher: "Your Publisher"
abstract: |
  A brief description of your book.
---
```

## Markdown Features

### Callouts

Create special callout boxes:

```markdown
::: note
This is a note callout with blue background.
:::

::: warning
This is a warning callout with orange background.
:::

::: caution
This is a caution callout with red background.
:::

::: info
This is an info callout with green background.
:::

::: example
This is an example callout with purple background.
:::
```

### Code Blocks

```markdown
\```javascript
function hello(name) {
  console.log(`Hello, ${name}!`);
}
\```
```

### Links and References

```markdown
See [Chapter 2](#chapter-2) for more details.
Check out the [documentation](https://example.com).
```

## Available npm Scripts

```bash
# From book-builder directory
npm run build:pdf        # Build PDF
npm run build:web        # Build HTML
npm run build:epub       # Build EPUB
npm run build:all        # Build all formats
npm run clean            # Clean build outputs
npm run pandoc:test      # Verify Pandoc and XeLaTeX installed
```

## Output Formats

### PDF (Print-Ready)
- PDF/X-1a compliant
- 300 DPI images
- Atkinson Hyperlegible font
- Professional typography
- Print-optimized

### HTML (Web)
- Responsive design
- Syntax highlighting
- Interactive navigation
- Web-optimized

### EPUB (E-Readers)
- E-reader compatible
- Reflowable text
- Embedded fonts
- Chapter navigation

## Customization

### Fonts

The Atkinson Hyperlegible font family is included (~10MB) in the `fonts/` directory. To use different fonts:

1. Add font files to `fonts/` directory
2. Update `templates/book-digital.latex` and `templates/book-print.latex`
3. Update font references in the templates

### Templates

- **PDF Template**: `templates/book-digital.latex` (digital) or `templates/book-print.latex` (print)
- **CSS**: `styles/book.css` (HTML output)
- **Filters**: `templates/filters/` (custom Pandoc processing)

### Callout Styles

Edit `templates/filters/callout-filter.lua` to customize callout appearance and behavior.

## Troubleshooting

### Common Issues

**"Pandoc not found"**
```bash
brew install pandoc
pandoc --version  # Should be 3.0+
```

**"XeLaTeX not found"**
```bash
brew install --cask mactex
# Restart terminal
xelatex --version
```

**"Font not found"**
- Fonts are included in the `fonts/` directory
- Verify fonts exist: `ls fonts/`

**Build fails with errors**
```bash
# Run with verbose output
node scripts/build-book.js /path/to/book --target pdf --verbose
```

## Examples

See `examples/sample-book/` for a complete working example.

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## Credits

- Built with [Pandoc](https://pandoc.org/)
- Uses [Atkinson Hyperlegible](https://brailleinstitute.org/freefont) font from the Braille Institute
- LaTeX typesetting via [XeLaTeX](https://www.latex-project.org/)

## Support

For issues, questions, or contributions:
- GitHub Issues: https://github.com/satkinson/book-builder/issues
- Documentation: https://github.com/satkinson/book-builder

---

**Created by Steve Atkinson** • Originally developed for "The Constellize Method" book