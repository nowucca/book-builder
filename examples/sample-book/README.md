# Sample Book Example

This is a minimal example demonstrating how to use book-builder.

## Structure

```
sample-book/
├── metadata.yaml    # Book metadata and configuration
├── chapter1.md      # Sample chapter content
└── README.md        # This file
```

## Building the Sample

From the book-builder root directory:

```bash
# Build PDF
node scripts/build-book.js examples/sample-book --target pdf

# Build HTML
node scripts/build-book.js examples/sample-book --target web

# Build all formats
node scripts/build-book.js examples/sample-book --target all
```

The output will be in `examples/sample-book/build/`.

## Creating Your Own Book

1. Copy this sample-book directory as a template
2. Update `metadata.yaml` with your book information
3. Replace `chapter1.md` with your own chapters
4. Add more chapter files as needed
5. Build using the commands above

## Next Steps

See the main book-builder README for:
- Full documentation
- Advanced features
- Template customization
- Troubleshooting