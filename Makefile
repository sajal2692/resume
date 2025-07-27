# Makefile for resume generation

# Variables
LATEX = pdflatex
CONVERT = magick convert
FILENAME = resume

# Load environment variables if .env.local exists
ifneq (,$(wildcard .env.local))
    include .env.local
    export
endif

# Default target - build both versions
all: public private

# Public version (no phone number) - default resume
public: $(FILENAME).pdf $(FILENAME).png

# Private version (with phone number)
private: $(FILENAME)-private.pdf $(FILENAME)-private.png

# Generate public PDF (no phone) - main resume file
$(FILENAME).pdf: $(FILENAME).tex
	sed 's/PHONESECTIONPLACEHOLDER//g' $(FILENAME).tex > $(FILENAME)-temp.tex
	$(LATEX) $(FILENAME)-temp.tex
	mv $(FILENAME)-temp.pdf $(FILENAME).pdf
	rm $(FILENAME)-temp.tex $(FILENAME)-temp.aux $(FILENAME)-temp.log $(FILENAME)-temp.out 2>/dev/null || true

# Generate private PDF (with phone)
$(FILENAME)-private.pdf: $(FILENAME).tex .env.local
	@if [ -z "$(PHONE_NUMBER)" ]; then echo "Error: PHONE_NUMBER not set in .env.local"; exit 1; fi
	sed 's/PHONESECTIONPLACEHOLDER/$(PHONE_NUMBER) $$|$$ /g' $(FILENAME).tex > $(FILENAME)-private.tex
	$(LATEX) $(FILENAME)-private.tex
	rm $(FILENAME)-private.tex $(FILENAME)-private.aux $(FILENAME)-private.log $(FILENAME)-private.out 2>/dev/null || true

# Generate public PNG - main resume PNG
$(FILENAME).png: $(FILENAME).pdf
	$(CONVERT) -density 300 $(FILENAME).pdf -background white -flatten -quality 90 $(FILENAME).png

# Generate private PNG
$(FILENAME)-private.png: $(FILENAME)-private.pdf
	$(CONVERT) -density 300 $(FILENAME)-private.pdf -background white -flatten -quality 90 $(FILENAME)-private.png

# Clean auxiliary files
clean:
	rm -f $(FILENAME)*.aux $(FILENAME)*.log $(FILENAME)*.out $(FILENAME)*.fdb_latexmk $(FILENAME)*.fls $(FILENAME)*.synctex.gz

# Clean all generated files
clean-all: clean
	rm -f $(FILENAME).pdf $(FILENAME).png $(FILENAME)-private.pdf $(FILENAME)-private.png

# Force rebuild
rebuild: clean all

# Install dependencies (macOS with Homebrew)
install-deps:
	brew install --cask mactex
	brew install imagemagick

# Help target
help:
	@echo "Available targets:"
	@echo "  all         - Build both public and private versions (default)"
	@echo "  public      - Build public version as resume.pdf/png (no phone number)"
	@echo "  private     - Build private version as resume-private.pdf/png (with phone number)"
	@echo "  clean       - Remove auxiliary files"
	@echo "  clean-all   - Remove all generated files"
	@echo "  rebuild     - Clean and rebuild all"
	@echo "  install-deps- Install required dependencies"
	@echo "  help        - Show this help message"

# Aliases for backward compatibility
pdf: $(FILENAME).pdf
png: $(FILENAME).png

.PHONY: all public private clean clean-all rebuild install-deps help pdf png
