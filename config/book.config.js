/**
 * Constellize Book Configuration
 * Main configuration for book processing with Pandoc
 */

const path = require('path');

module.exports = {
  // Book metadata
  book: {
    title: "The Constellize Method",
    subtitle: "Building Software Systems from Knowledge",
    author: "Steve Atkinson",
    version: "1.0.0",
    isbn: "", // To be filled when available
    publisher: "Constellize Press",
    year: new Date().getFullYear()
  },

  // Source paths (relative to project root)
  source: {
    root: path.resolve(__dirname, '../..'),
    foreword: 'foreword-faq.md', // Foreword comes first
    chapters: ['ch[1-9].md'], // Main chapters
    bibliography: 'references.json', // Bibliography database (CSL-JSON)
    appendices: ['app[A-D].md'], // Appendices
    codebase: './codepromptu',
    images: './images',
    media: './media',
    excludePatterns: [
      'tools/**',
      'build/**', 
      'node_modules/**',
      '.git/**',
      '*.tmp',
      'narrative-*.md',
      'chapter-image-design-plan.md',
      'ch1-revised.md',
      'ch4a.md',
      'example-chapter.md',
      'README-teaser.md',
      'tone.md',
      'references.md' // Exclude old manual references file
    ]
  },

  // Repository configuration for link processing
  repository: {
    // Base URL will be replaced in {REPO_BASE} placeholders
    baseUrl: process.env.REPO_BASE_URL || "https://github.com/yourusername/constellize-book/blob/main",
    localPath: "./codepromptu", // for development builds
    branch: "main"
  },

  // Output configurations for different targets
  outputs: {
    digital: {
      directory: './build/digital',
      repoBaseUrl: 'https://github.com/yourusername/constellize-book/blob/main',
      format: 'pdf',
      engine: 'xelatex',
      dpi: 300,
      pdfType: 'interactive', // Enable hyperlinks and bookmarks
      standalone: true
    },
    print: {
      directory: './build/print',
      repoBaseUrl: 'https://github.com/yourusername/constellize-book/blob/main',
      format: 'pdf',
      engine: 'xelatex',
      dpi: 300,
      pdfType: 'x1a', // PDF/X-1a compliance for printing
      colorProfile: 'FOGRA39',
      standalone: true
    },
    web: {
      directory: './build/web',
      repoBaseUrl: 'https://github.com/yourusername/constellize-book/blob/main',
      format: 'html5',
      standalone: true
    },
    development: {
      directory: './build/development',
      repoBaseUrl: 'file://' + path.resolve(__dirname, '../..'),
      format: 'html5',
      standalone: true
    },
    epub: {
      directory: './build/epub',
      repoBaseUrl: 'https://github.com/yourusername/constellize-book/blob/main',
      format: 'epub3',
      standalone: true
    },
    // Legacy alias for backward compatibility
    pdf: {
      directory: './build/digital', // Default to digital format
      repoBaseUrl: 'https://github.com/yourusername/constellize-book/blob/main',
      format: 'pdf',
      engine: 'xelatex',
      dpi: 300,
      pdfType: 'interactive',
      standalone: true
    }
  },

  // Pandoc configuration
  pandoc: {
    defaultsFile: 'tools/config/pandoc-defaults.yaml',
    template: 'tools/templates/book.latex',
    filters: [
      'tools/templates/filters/callout-filter.lua',
      'tools/templates/filters/link-filter.lua'
    ],
    metadata: 'tools/templates/metadata.yaml'
  },

  // Citation configuration
  citations: {
    bibliography: 'references.json', // Bibliography database file
    defaultStyle: 'apa', // Default citation style
    styles: {
      apa: 'tools/styles/citations/apa.csl',
      chicago: 'tools/styles/citations/chicago-author-date.csl',
      ieee: 'tools/styles/citations/ieee.csl'
    },
    // Style per output format (optional overrides)
    outputStyles: {
      pdf: 'apa',
      web: 'apa',
      development: 'apa',
      epub: 'apa'
    }
  },

  // Font configuration for Atkinson Hyperlegible
  fonts: {
    main: {
      name: "Atkinson Hyperlegible Next",
      path: "tools/fonts/",
      files: {
        // Using AtkinsonHyperlegibleNext fonts
        regular: "AtkinsonHyperlegibleNext-Regular",
        bold: "AtkinsonHyperlegibleNext-Bold", 
        italic: "AtkinsonHyperlegibleNext-RegularItalic",
        boldItalic: "AtkinsonHyperlegibleNext-BoldItalic"
      },
      formats: {
        pdf: "ttf",
        web: "woff2", // Preferred for web
        development: "woff2", // Use WOFF2 for development too
        fallback: "ttf"
      }
    },
    mono: {
      name: "Atkinson Hyperlegible Mono",
      path: "tools/fonts/",
      files: {
        regular: "AtkinsonHyperlegibleMono-Regular",
        bold: "AtkinsonHyperlegibleMono-Bold",
        italic: "AtkinsonHyperlegibleMono-RegularItalic", 
        boldItalic: "AtkinsonHyperlegibleMono-BoldItalic"
      },
      formats: {
        pdf: "ttf",
        web: "woff2",
        development: "woff2",
        fallback: "ttf"
      }
    }
  },

  // Callout system configuration
  callouts: {
    codeReference: {
      icon: "📁",
      title: "Code Reference",
      style: "info",
      color: "#0066cc"
    },
    architecture: {
      icon: "🏗️", 
      title: "System Architecture",
      style: "primary",
      color: "#6f42c1"
    },
    narrative: {
      icon: "📖",
      title: "Narrative Context", 
      style: "secondary",
      color: "#6c757d"
    },
    implementation: {
      icon: "⚡",
      title: "Implementation Pattern",
      style: "success", 
      color: "#28a745"
    },
    crossReference: {
      icon: "🔗",
      title: "Related Components",
      style: "warning",
      color: "#ffc107"
    }
  },

  // Image processing settings
  images: {
    dpi: 300,
    formats: ['png', 'jpg', 'jpeg', 'svg'],
    optimization: {
      quality: 90,
      progressive: true
    }
  },

  // Build settings
  build: {
    clean: true, // Clean build directory before building
    verbose: false,
    parallel: true, // Process chapters in parallel where possible
    watch: false // Enable file watching in development
  }
};
