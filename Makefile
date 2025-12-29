# Makefile for Book-Builder
# Reusable book publishing system

SHELL := /bin/zsh
PATH := /Library/TeX/texbin:$(PATH)
export PATH

# Directories
SCRIPTS_DIR := scripts
TEMPLATES_DIR := templates
FONTS_DIR := fonts
CONFIG_DIR := config

# Node dependencies
NODE_MODULES := node_modules

.PHONY: all help verify build clean install test

# Default target
all: verify

# Help
help:
	@echo "Book-Builder - Available targets:"
	@echo ""
	@echo "  make verify    - Verify prerequisites and setup"
	@echo "  make install   - Install npm dependencies"
	@echo "  make test      - Run validation tests"
	@echo "  make clean     - Clean build artifacts"

# Verify prerequisites
verify: check-pandoc check-xelatex check-node check-fonts check-npm-deps
	@echo "✅ All prerequisites verified!"

check-pandoc:
	@echo -n "Checking Pandoc... "
	@which pandoc > /dev/null 2>&1 || (echo "❌ FAILED"; echo "Install: brew install pandoc"; exit 1)
	@pandoc --version | head -1
	@echo "✅ Pandoc found"

check-xelatex:
	@echo -n "Checking XeLaTeX... "
	@which xelatex > /dev/null 2>&1 || (echo "❌ FAILED"; echo "Install: brew install --cask mactex"; exit 1)
	@xelatex --version | head -1
	@echo "✅ XeLaTeX found"

check-node:
	@echo -n "Checking Node.js... "
	@which node > /dev/null 2>&1 || (echo "❌ FAILED"; echo "Install: brew install node"; exit 1)
	@node --version
	@echo "✅ Node.js found"

check-fonts:
	@echo -n "Checking fonts... "
	@if [ -d "$(FONTS_DIR)" ] && [ "$$(ls -1 $(FONTS_DIR)/*.ttf 2>/dev/null | wc -l)" -gt 0 ]; then \
		echo "✅ Fonts found ($$(ls -1 $(FONTS_DIR)/*.ttf | wc -l) TTF files)"; \
	else \
		echo "❌ FAILED - Fonts directory missing or empty"; \
		exit 1; \
	fi

check-npm-deps:
	@echo -n "Checking npm dependencies... "
	@if [ -d "$(NODE_MODULES)" ]; then \
		echo "✅ Dependencies installed"; \
	else \
		echo "⚠️  Not installed - run 'make install'"; \
	fi

# Install dependencies
install:
	@echo "📦 Installing npm dependencies..."
	npm install
	@echo "✅ Dependencies installed!"

# Run validation tests
test: verify
	@echo "🧪 Running validation tests..."
	@if [ -f "$(SCRIPTS_DIR)/validate-emojis.js" ]; then \
		node $(SCRIPTS_DIR)/validate-emojis.js; \
	fi
	@if [ -f "$(SCRIPTS_DIR)/validate-links.js" ]; then \
		node $(SCRIPTS_DIR)/validate-links.js; \
	fi
	@echo "✅ Tests passed!"

# Build (book-builder doesn't build itself, just verifies)
build: verify
	@echo "✅ Book-builder verified and ready!"

# Clean
clean:
	@echo "🧹 Cleaning book-builder artifacts..."
	@# No build artifacts in book-builder itself
	@echo "✅ Clean complete!"

# Development helpers
lint:
	@echo "🔍 Linting JavaScript files..."
	@find $(SCRIPTS_DIR) -name "*.js" -exec node --check {} \;
	@echo "✅ Lint check passed!"

check-templates:
	@echo "🔍 Checking LaTeX templates..."
	@if [ -f "$(TEMPLATES_DIR)/book-digital.latex" ]; then \
		echo "✅ book-digital.latex found"; \
	else \
		echo "❌ book-digital.latex missing"; \
		exit 1; \
	fi
	@if [ -f "$(TEMPLATES_DIR)/book-print.latex" ]; then \
		echo "✅ book-print.latex found"; \
	else \
		echo "❌ book-print.latex missing"; \
		exit 1; \
	fi

check-config:
	@echo "🔍 Checking configuration files..."
	@if [ -f "$(CONFIG_DIR)/book.config.js" ]; then \
		echo "✅ book.config.js found"; \
	else \
		echo "❌ book.config.js missing"; \
		exit 1; \
	fi
	@if [ -f "$(CONFIG_DIR)/pandoc-defaults.yaml" ]; then \
		echo "✅ pandoc-defaults.yaml found"; \
	else \
		echo "❌ pandoc-defaults.yaml missing"; \
		exit 1; \
	fi
