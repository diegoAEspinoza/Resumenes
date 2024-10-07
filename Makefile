BUILD_DIR := ./build

TEX_FILES := $(shell find . -name '*.tex')

# Compila todos los archivos .tex en el directorio actual
.PHONY: all
all: $(patsubst %.tex,$(BUILD_DIR)/%.pdf,$(wildcard *.tex))

# Compilación de LaTeX
$(BUILD_DIR)/%.pdf: %.tex
	mkdir -p "$(dir $@)"
	pdflatex -interaction=batchmode -output-directory="$(dir $@)" "$<"

# Live reload
.PHONY: live
live:
	trap 'kill 0' EXIT; \
	python -m http.server 8000 & \
	watchexec --exts tex,sty,css,js make all & \
	wait

.PHONY: clean
clean:
	@if [ -z "$(BUILD_DIR)" ]; then \
		echo "Error: BUILD_DIR is not set."; \
		exit 1; \
	fi
	rm -rf "$(BUILD_DIR)"

.SECONDARY:
