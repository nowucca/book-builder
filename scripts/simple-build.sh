#!/bin/bash

# Simple Build Script for Constellize Book
# Usage: ./simple-build.sh <input-file> [format] [output-name]

set -e

# Configuration
TEXLIVE_PATH="/usr/local/texlive/2025/bin/universal-darwin"
BUILD_DIR="../build"
REPO_BASE_PDF="https://github.com/yourusername/yourrepo/blob/main"
REPO_BASE_DEV="file://$(pwd)/../"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_usage() {
    echo -e "${BLUE}🚀 Simple Build Script for Constellize Book${NC}"
    echo ""
    echo "Usage: $0 <input-file> [format] [output-name]"
    echo ""
    echo "Arguments:"
    echo "  input-file    Path to markdown file (relative to book root)"
    echo "  format        Output format: pdf, html, epub, development, all (default: pdf)"
    echo "  output-name   Output filename without extension (default: derived from input)"
    echo ""
    echo "Examples:"
    echo "  $0 ../ch1.md pdf chapter1"
    echo "  $0 ../example-chapter.md html example"
    echo "  $0 ../ch1.md all chapter1"
    echo ""
    echo "Formats:"
    echo "  pdf          - PDF with Atkinson Hyperlegible fonts"
    echo "  html         - Web-ready HTML"
    echo "  epub         - EPUB e-book format"
    echo "  development  - HTML with local file links"
    echo "  all          - Generate all formats"
}

validate_prerequisites() {
    echo -e "${BLUE}🔍 Validating prerequisites...${NC}"
    
    if ! command -v pandoc &> /dev/null; then
        echo -e "${RED}❌ Pandoc not found. Please install Pandoc.${NC}"
        exit 1
    fi
    
    echo "Pandoc: $(pandoc --version | head -n1)"
    
    if [ -d "$TEXLIVE_PATH" ]; then
        if command -v "$TEXLIVE_PATH/xelatex" &> /dev/null; then
            echo "XeLaTeX: $($TEXLIVE_PATH/xelatex --version | head -n1)"
        else
            echo -e "${YELLOW}⚠️  XeLaTeX not found. PDF generation may fail.${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  TeX Live not found at expected path. PDF generation may fail.${NC}"
    fi
}

ensure_build_directories() {
    for dir in pdf html epub development; do
        mkdir -p "$BUILD_DIR/$dir"
    done
}

process_content() {
    local input_file="$1"
    local format="$2"
    local temp_file="$BUILD_DIR/temp-input.md"
    
    echo -e "${BLUE}📝 Processing $input_file for $format...${NC}"
    
    # Read content and replace repository base URLs
    local repo_base
    case "$format" in
        development)
            repo_base="$REPO_BASE_DEV"
            ;;
        *)
            repo_base="$REPO_BASE_PDF"
            ;;
    esac
    
    # Simple sed replacement for {REPO_BASE}
    sed "s|{REPO_BASE}|$repo_base|g" "$input_file" > "$temp_file"
    
    echo "$temp_file"
}

build_format() {
    local input_file="$1"
    local format="$2"
    local output_name="$3"
    
    local temp_file
    temp_file=$(process_content "$input_file" "$format")
    
    local output_dir="$BUILD_DIR/$format"
    local output_file
    
    echo -e "${BLUE}📚 Generating $(echo $format | tr '[:lower:]' '[:upper:]')...${NC}"
    
    case "$format" in
        pdf)
            output_file="$output_dir/${output_name}.pdf"
            PATH="$TEXLIVE_PATH:$PATH" pandoc "$temp_file" \
                -o "$output_file" \
                --pdf-engine=xelatex \
                --template=templates/book.latex \
                --metadata title="Constellize Book" \
                --metadata author="Your Name" \
                --dpi=300 \
                --standalone
            ;;
        html)
            output_file="$output_dir/${output_name}.html"
            pandoc "$temp_file" \
                -o "$output_file" \
                --metadata title="Constellize Book" \
                --css=../styles/book.css \
                --standalone \
                --toc
            ;;
        development)
            output_file="$output_dir/${output_name}.html"
            pandoc "$temp_file" \
                -o "$output_file" \
                --metadata title="Constellize Book (Development)" \
                --css=../styles/book.css \
                --standalone \
                --toc
            ;;
        epub)
            output_file="$output_dir/${output_name}.epub"
            pandoc "$temp_file" \
                -o "$output_file" \
                --metadata title="Constellize Book" \
                --metadata author="Your Name" \
                --toc
            ;;
        *)
            echo -e "${RED}❌ Unknown format: $format${NC}"
            return 1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $(echo $format | tr '[:lower:]' '[:upper:]') generated: $output_file${NC}"
        echo "$output_file"
    else
        echo -e "${RED}❌ Failed to generate $(echo $format | tr '[:lower:]' '[:upper:]')${NC}"
        return 1
    fi
    
    # Clean up temp file
    rm -f "$temp_file"
}

main() {
    if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_usage
        exit 0
    fi
    
    local input_file="$1"
    local format="${2:-pdf}"
    local output_name="${3:-$(basename "$input_file" .md)}"
    
    if [ ! -f "$input_file" ]; then
        echo -e "${RED}❌ Input file not found: $input_file${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}🚀 Building $input_file as $format${NC}"
    
    validate_prerequisites
    ensure_build_directories
    
    if [ "$format" = "all" ]; then
        local formats=("pdf" "html" "epub" "development")
        local outputs=()
        
        for fmt in "${formats[@]}"; do
            if output=$(build_format "$input_file" "$fmt" "$output_name"); then
                outputs+=("$output")
            else
                echo -e "${YELLOW}⚠️  Failed to build $fmt, continuing...${NC}"
            fi
        done
        
        echo ""
        echo -e "${GREEN}🎉 Build complete!${NC}"
        echo "Generated files:"
        for output in "${outputs[@]}"; do
            echo "  - $output"
        done
    else
        if output=$(build_format "$input_file" "$format" "$output_name"); then
            echo ""
            echo -e "${GREEN}🎉 Build complete: $output${NC}"
        else
            echo ""
            echo -e "${RED}❌ Build failed${NC}"
            exit 1
        fi
    fi
}

main "$@"
