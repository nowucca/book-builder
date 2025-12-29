# Active Context: Book-Builder

**Last Updated**: December 28, 2024
**Current Version**: 1.0.0
**Status**: Production Ready

---

## Current Focus

### Recent Completion: Minted Integration & Python Dependency Management ✅

**What Was Completed** (December 28, 2024):
- ✅ Added Python dependency management via uv package manager
- ✅ Created pyproject.toml with Pygments dependency
- ✅ Integrated Minted package for syntax highlighting with automatic line breaking
- ✅ Created minted-filter.lua to convert code blocks to Minted environments
- ✅ Updated LaTeX templates to use Minted with breaklines configuration
- ✅ Modified build script to pass --shell-escape to XeLaTeX
- ✅ Extended PATH to include .venv/bin for Pygments access
- ✅ Updated Makefile with Python verification and installation targets
- ✅ Configured code callouts with reduced horizontal margins (0.5em)
- ✅ Tested and validated: Lines break automatically with ↪ continuation indicator

**Previous Work** (December 28, 2024):
- ✅ Fixed all path references for submodule structure (book-builder/ instead of tools/)
- ✅ Added 29 TTF fonts from book-backup for XeLaTeX compatibility
- ✅ Updated LaTeX templates with correct font paths
- ✅ Fixed build-book.js path resolution using __dirname
- ✅ Updated book.config.js, pandoc-defaults.yaml with correct paths
- ✅ Updated metadata.yaml with correct appendices and online resources
- ✅ All build formats tested and working
- ✅ External references verified (constellize.com/book/metrics)
- ✅ Emoji validation enhancement (December 25, 2024)

**Status**: Production-ready with complete syntax highlighting and line breaking solution

---

## Recent Decisions

### Decision 1: Minted + UV for Syntax Highlighting
**Date**: December 28, 2024
**Context**: Code blocks in callouts were overflowing margins, needed line breaking with syntax highlighting

**Decision**: Use Minted package with Python/Pygments, managed via uv

**Alternatives Considered**:
- Listings package: Supports breaklines but inferior syntax highlighting
- Manual line breaks: Too much maintenance burden
- Smaller fonts only: Insufficient for longest lines

**Implementation**:
- Python dependencies isolated to book-builder/.venv via uv
- Custom Lua filter (minted-filter.lua) converts code blocks to Minted
- LaTeX templates configured with breaklines, hook arrow continuation
- Build script passes --shell-escape and extends PATH to .venv/bin
- Code callouts get reduced horizontal margins (0.5em) for more space

**Rationale**:
- Minted provides best-in-class syntax highlighting via Pygments
- Automatic line breaking with customizable continuation indicators
- UV keeps Python ecosystem isolated and fast
- Reusable pattern for future book projects

**Result**: Professional code rendering with automatic wrapping

### Decision 2: Node Modules Exclusion Strategy
**Date**: December 25, 2024
**Context**: Emoji validation was scanning node_modules causing false positives

**Decision**: Multi-layered exclusion approach in validate-emojis.js

**Implementation**:
- Enhanced glob ignore patterns with comprehensive list
- Added explicit shouldProcessFile() checks
- Multiple pattern variations for reliability
- Excludes: node_modules, book-backup, build, dist, .git

**Rationale**:
- Single layer (glob ignore) insufficient in some contexts
- Defense-in-depth ensures reliability across environments
- Prevents validation of dependency code
- Maintains integrity for actual content validation

**Result**: Validation correctly processes 23 book files, 0 violations

### Decision 2: Submodule Path Resolution Strategy
**Date**: December 28, 2024
**Context**: After repo separation, hardcoded "tools/" paths broke builds

**Decision**: Use __dirname-based path resolution in build scripts

**Implementation**:
- Changed `toolsDir = path.resolve(rootDir, "tools")`
- To: `toolsDir = path.resolve(__dirname, "..")`
- Updated all config files to use "book-builder/" prefix
- LaTeX templates use relative paths: `./book-builder/fonts/`

**Rationale**:
- Makes book-builder work from any location
- Doesn't depend on parent directory structure
- Enables true standalone usage as submodule
- Scripts always find their own resources

**Result**: All builds working correctly from submodule location

### Decision 3: Font Format Requirements
**Date**: December 28, 2024
**Context**: XeLaTeX requires TTF/OTF fonts, WOFF2 doesn't work

**Decision**: Include all TTF fonts, gitignore only >100MB files

**Implementation**:
- Copied 29 TTF fonts from book-backup (48-68K each)
- Included NotoColorEmoji.ttf (9.7M)
- Gitignored AppleColorEmoji.ttf (180M)
- LaTeX templates reference TTF files directly

**Rationale**:
- XeLaTeX fontspec package requires TTF/OTF format
- WOFF2 only for web, not usable for PDF generation
- Small fonts (<10M) acceptable in repo for self-containment
- Very large fonts (>100M) excluded via gitignore

**Result**: PDF builds successfully with all required fonts

### Decision 4: Metadata Consistency
**Date**: December 28, 2024
**Context**: metadata.yaml had old appendix names after Phase 3 cleanup

**Decision**: Update metadata to reflect actual book structure

**Implementation**:
- Changed appendices to: "Constellize Method Summary", "A Manifesto for Constellize"
- Added online_resources section with 5 website URLs
- Removed references to deleted appendices (A, D, E, F, G)

**Rationale**:
- Metadata should accurately describe book contents
- Online resources documented for reference
- Consistency between code and metadata prevents confusion

**Result**: Metadata matches actual book structure

---

## Next Steps

### Immediate (Complete)
- ✅ Emoji validation fixed (Dec 25)
- ✅ Memory bank created (Dec 25)
- ✅ Phase 4 build validation complete (Dec 28)
- ✅ All path issues resolved (Dec 28)
- ✅ Fonts added and working (Dec 28)

### Short Term
- Ready for Phase 5: Memory Banks (create for all repos)
- Ready for book project Phase 6: Website Deployment
- Monitor usage in Constellize Book project
- Gather feedback on build performance

### Medium Term
- Consider additional validation tools
- Explore template improvements
- Version 1.1 planning with enhanced features

---

## Active Patterns

### Build System Design
- **Script Organization**: Separate scripts for each concern (build, validate, process)
- **Configuration**: External metadata.yaml keeps code generic
- **Validation**: Run before builds to catch issues early
- **Error Handling**: Clear messages guide users to solutions

### Git Workflow
- **Standalone First**: Make changes in standalone repo
- **Push to GitHub**: Central source of truth
- **Submodule Pull**: Users update via git pull in submodule
- **Semantic Versioning**: Major.minor.patch for releases

### Quality Standards
- **Validation Before Build**: Catch issues early
- **Multi-layered Checks**: Don't rely on single mechanism
- **Clear Error Messages**: Help users fix issues
- **Documentation**: Examples and troubleshooting guides

---

## Important Learnings

### Learning 1: Glob Ignore Patterns Not Sufficient
**Discovered**: December 25, 2024
**Issue**: glob ignore patterns alone didn't always exclude node_modules
**Solution**: Added explicit path checking as safety layer
**Application**: Always use defense-in-depth for critical exclusions

### Learning 2: Git Submodule Workflow
**Context**: Book-builder used as submodule in book project
**Insight**: Edit standalone repo, push, then pull in submodule
**Benefit**: Maintains proper git relationships, avoids confusion
**Application**: Document this workflow clearly for users

### Learning 3: Font Inclusion Worth the Size
**Context**: Including ~10MB of fonts in repo
**Value**: Makes system self-contained, easier for users
**Trade-off**: Larger repo size acceptable for convenience
**Application**: Self-contained trumps minimal repo size

### Learning 4: XeLaTeX Font Format Requirements
**Discovered**: December 28, 2024
**Issue**: XeLaTeX requires TTF/OTF fonts, not WOFF2
**Solution**: Include TTF fonts in repo, gitignore only >100MB files
**Application**: Font format matters - web fonts (WOFF2) don't work for PDF
**Insight**: Self-contained with proper formats better than minimal repo

### Learning 5: Submodule Independence Requires Dynamic Paths
**Discovered**: December 28, 2024
**Issue**: Hardcoded "tools/" paths broke after submodule extraction
**Solution**: Use __dirname for path resolution relative to script location
**Application**: Scripts should find resources relative to themselves
**Insight**: True reusability requires eliminating assumptions about parent structure

---

## Current State

### Repository
- **Location**: https://github.com/nowucca/book-builder
- **Branch**: main
- **Status**: Clean, all changes committed
- **Latest Commits**:
  - f6886c8 (metadata.yaml update)
  - 73be206 (font path fixes)
  - Multiple commits for Phase 4 fixes

### Build System
- **PDF**: Working (24MB digital output tested)
- **HTML**: Working (330KB output tested)
- **EPUB**: Working (108KB output tested)
- **Validation**: All tools working correctly
- **Fonts**: 29 TTF fonts included and working

### Dependencies
- **Pandoc**: 3.0+ required
- **XeLaTeX**: TeX Live required
- **Node.js**: 16+ required
- **npm packages**: All in package.json

### Known Issues
- None currently

---

## Integration Status

### Constellize Book Project
- ✅ Integrated as git submodule at book/book-builder/
- ✅ All builds working
- ✅ Validation passing
- ✅ Ready for Phase 1 (CodePromptu separation)

### Potential Other Projects
- Ready for use by other technical book authors
- Can be used as submodule or standalone
- Documented for reuse

---

## Metrics to Track

### Build Performance
- Build time for different book sizes
- Memory usage during builds
- Success rate of builds

### Validation Effectiveness
- False positive rate (should be 0)
- False negative rate (emojis that should fail)
- Files correctly excluded (node_modules, etc.)

### User Experience
- Setup time for new projects
- Number of configuration errors
- Common pain points

---

## Communication Notes

### For Future Maintainers
**Getting Started**:
1. Read projectbrief.md for overview
2. Review scripts/ directory for build system
3. Check examples/ for usage patterns
4. Test with example projects before using on real book

**Making Changes**:
1. Test with example projects first
2. Update documentation
3. Update version number (semantic versioning)
4. Commit with clear messages
5. Push to GitHub
6. Update submodule references in dependent projects

---

## Environmental Context

### Development Environment
- **Primary Platform**: macOS
- **Tested On**: macOS (Darwin 25.1.0)
- **Node.js**: v23.11.0 (but requires 16+)
- **Pandoc**: 3.7+
- **XeLaTeX**: TeX Live 2025

### Repository Structure
```
book-builder/
├── fonts/           # Atkinson Hyperlegible fonts (~10MB)
├── scripts/         # Build and validation scripts
├── templates/       # LaTeX templates and Lua filters
├── styles/          # CSS and citation styles
├── examples/        # Sample projects
├── memory-bank/     # This documentation
├── package.json     # Dependencies and scripts
└── README.md        # User documentation
```

---

**Document Owner**: Steve Atkinson
**Last Updated**: December 25, 2024
**Next Update**: After significant changes or monthly review
