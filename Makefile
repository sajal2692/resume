# Makefile for resume generation

# Variables
LATEX = pdflatex
CONVERT = magick convert
FILENAME = resume

# Default target
all: $(FILENAME).pdf $(FILENAME).png

# Generate PDF from LaTeX
$(FILENAME).pdf: $(FILENAME).tex
	$(LATEX) $(FILENAME).tex

# Generate PNG from PDF with white background
$(FILENAME).png: $(FILENAME).pdf
	$(CONVERT) -density 300 $(FILENAME).pdf -background white -flatten -quality 90 $(FILENAME).png

# Clean auxiliary files
clean:
	rm -f $(FILENAME).aux $(FILENAME).log $(FILENAME).out $(FILENAME).fdb_latexmk $(FILENAME).fls $(FILENAME).synctex.gz

# Clean all generated files
clean-all: clean
	rm -f $(FILENAME).pdf $(FILENAME).png

# Force rebuild
rebuild: clean all

# Install dependencies (macOS with Homebrew)
install-deps:
	brew install --cask mactex
	brew install imagemagick

# Help target
help:
	@echo "Available targets:"
	@echo "  all         - Build PDF and PNG (default)"
	@echo "  pdf         - Build PDF only"
	@echo "  png         - Build PNG only"
	@echo "  clean       - Remove auxiliary files"
	@echo "  clean-all   - Remove all generated files"
	@echo "  rebuild     - Clean and rebuild all"
	@echo "  install-deps- Install required dependencies"
	@echo "  help        - Show this help message"

# Aliases
pdf: $(FILENAME).pdf
png: $(FILENAME).png

.PHONY: all clean clean-all rebuild install-deps help pdf png