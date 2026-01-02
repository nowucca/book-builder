# Product Context: Book-Builder

**Last Updated**: January 2, 2026
**Project**: Reusable Book Publishing System
**Context**: Why book-builder exists and what problems it solves

---

## Problem Statement

Technical book authors face significant challenges when trying to produce professional-quality books from Markdown source:

### Problem 1: Complex Toolchain Setup
**Current State**: Authors must manually configure Pandoc, XeLaTeX, fonts, templates, and build scripts.

**Pain Points**:
- Steep learning curve for Pandoc and LaTeX
- Difficult to get fonts working correctly
- Template customization requires LaTeX expertise
- No standardized approach across projects
- Hard to maintain consistent quality

**Impact**: Authors spend more time fighting tools than writing content.

### Problem 2: Multi-Format Publishing
**Current State**: Each output format (PDF, HTML, EPUB) requires different configuration and testing.

**Pain Points**:
- Different templates for each format
- Inconsistent styling across formats
- Hard to maintain feature parity
- Testing burden increases with formats
- Manual process for each build

**Impact**: Authors typically only produce one format, limiting reader accessibility.

### Problem 3: Professional Quality Bar
**Current State**: Achieving print-ready, professional quality requires extensive LaTeX knowledge.

**Pain Points**:
- Typography requires expert knowledge
- Code highlighting is complex to set up
- Callout boxes need custom LaTeX packages
- PDF/X-1a compliance for printing is difficult
- Citation management requires BibTeX expertise

**Impact**: Self-published technical books often look amateurish.

### Problem 4: Not Reusable
**Current State**: Most book projects have custom build systems that can't be reused.

**Pain Points**:
- Each book project starts from scratch
- Can't share improvements across projects
- No community standardization
- Lost time reinventing the wheel
- Difficult to maintain multiple books

**Impact**: Authors duplicate effort and can't benefit from collective improvements.

---

## Solution Approach

### Turnkey Book Publishing System

**Core Strategy**: Provide a complete, self-contained build system that handles all complexity and works as a git submodule.

#### Key Components

**1. Comprehensive Font Package**
- Atkinson Hyperlegible font family (~10MB)
- Includes all weights and styles
- Both TTF (for PDF) and WOFF2 (for web)
- Optimized for readability

**2. Professional Templates**
- LaTeX templates for PDF (digital and print)
- HTML template for web viewing
- EPUB template for e-readers
- Customizable but with sensible defaults

**3. Advanced Filters**
- Lua filters for Pandoc processing
- Callout box rendering with colored backgrounds
- Code syntax highlighting with Minted
- Link processing and validation
- Chapter image injection

**4. Build Automation**
- Node.js build scripts
- Single command for each format
- Validation tools (emoji, links, structure)
- Error handling and troubleshooting
- Progress reporting

**5. Configuration System**
- metadata.yaml for book-specific settings
- pandoc-defaults.yaml for build configuration
- book.config.js for advanced customization
- Environment-specific settings

---

## Target Audience

### Primary: Technical Book Authors

**Needs**:
- Professional-quality output
- Easy setup and integration
- Multi-format publishing
- Focus on writing, not tooling

**Goals**:
- Publish books independently
- Maintain consistent quality
- Support multiple formats
- Reuse across book projects

### Secondary: Publishers

**Needs**:
- Standardized production pipeline
- Print-ready PDF output
- Consistent branding across books
- Scalable to multiple authors

**Goals**:
- Reduce production costs
- Ensure quality consistency
- Support multiple formats
- Streamline publishing workflow

### Tertiary: Technical Writers

**Needs**:
- Documentation that looks professional
- Multi-format output for different contexts
- Easy integration with existing workflows

**Goals**:
- Produce high-quality documentation
- Support web and PDF versions
- Maintain with minimal effort

---

## User Stories

### As a Technical Author

**Story 1: First Book**
- As a first-time author, I want a complete build system
- So that I can focus on content, not tooling
- And produce professional-quality output immediately

**Story 2: Multiple Books**
- As an experienced author, I want to reuse my build system
- So that my second book is easier than my first
- And improvements benefit all my books

**Story 3: Professional Quality**
- As an author, I want print-ready PDF output
- So that I can use print-on-demand services
- And my book looks professionally published

### As a Publisher

**Story 4: Consistent Quality**
- As a publisher, I want all authors using the same system
- So that books have consistent quality and branding
- And production costs are predictable

**Story 5: Multi-Format Support**
- As a publisher, I want PDF, EPUB, and web versions
- So that readers can choose their preferred format
- And we maximize distribution channels

---

## Success Metrics

### Adoption Metrics
- Number of books using book-builder
- GitHub stars and forks
- Community contributions
- Integration examples shared

### Quality Metrics
- PDF builds without errors
- All formats render correctly
- Professional appearance ratings
- Print-on-demand compatibility

### Efficiency Metrics
- Time from setup to first build
- Build time for typical book
- Ease of customization
- Documentation clarity

---

## Value Proposition

### Before book-builder
- Complex toolchain setup (days)
- Custom build system per book (weeks)
- Difficult to achieve professional quality
- Limited to one format
- No reusability across projects

### After book-builder
- Setup in minutes (git submodule + npm install)
- Ready-to-use build system
- Professional quality by default
- Three formats (PDF, HTML, EPUB)
- Reusable across unlimited books
- Community improvements benefit everyone

---

## Competitive Context

### Compared to Custom Solutions

**Custom Pandoc + LaTeX**:
- Requires extensive expertise
- Time-consuming to set up
- Hard to maintain
- Not reusable

**book-builder**:
- Turnkey solution
- Quick setup
- Well-maintained
- Fully reusable

**Advantage**: Dramatically lower barrier to entry, professional quality without expertise.

### Compared to Other Tools

**Leanpub, GitBook, etc.**:
- Proprietary platforms
- Limited customization
- Lock-in
- Monthly fees

**book-builder**:
- Open source
- Full customization
- Own your output
- No recurring costs

**Advantage**: Complete control, no platform lock-in, professional quality.

### Compared to Word/InDesign

**Microsoft Word / Adobe InDesign**:
- Not version-control friendly
- Expensive software
- Not reproducible
- Manual formatting

**book-builder**:
- Git-friendly Markdown
- Open source tools
- Reproducible builds
- Automated formatting

**Advantage**: Developer-friendly workflow, version control, automation.

---

## Key Insights

### Insight 1: Markdown Is Not Enough
Raw Markdown doesn't produce professional books. You need proper typography, templates, and processing. book-builder provides the missing pieces.

### Insight 2: Self-Contained Wins
Including fonts and templates (even at 10MB+) is better than requiring authors to install and configure dependencies. Self-contained means it just works.

### Insight 3: Git Submodule Sweet Spot
Git submodules allow book-builder to evolve independently while being integrated into book projects. Updates are opt-in but easy.

### Insight 4: Validation Saves Time
Catching issues (broken links, unapproved emojis, missing references) early in the build process saves hours of debugging later.

### Insight 5: Examples Are Essential
A working example book is worth more than pages of documentation. Show, don't just tell.

---

## Future Considerations

### Potential Enhancements
- Additional font options
- More template variants
- Interactive features for HTML
- Automated deployment options
- Community template marketplace

### Scalability
- Support for multi-volume works
- Internationalization support
- Advanced cross-referencing
- Bibliography management improvements

### Community
- Accept contributions from other authors
- Build ecosystem of extensions
- Share best practices and templates
- Create community showcase

---

**Document Owner**: Steve Atkinson
**Last Updated**: January 2, 2026
**Next Review**: After community feedback or major version release
