# Compiler settings
COBC = cobc
COBFLAGS = -Wno-dialect -O2 -free
# COBFLAGS = -Wall -Wno-dialect -O2 -free

# Directories
SRCDIR = src
BINDIR = bin

# Source and Executable mapping
SOURCES = $(wildcard $(SRCDIR)/*.cob)
TARGETS = $(patsubst $(SRCDIR)/%.cob, $(BINDIR)/%, $(SOURCES))

# Default target to build all binaries
all: $(TARGETS)

# Rule to build binaries from COBOL source files
$(BINDIR)/%: $(SRCDIR)/%.cob
	@mkdir -p $(BINDIR)
	$(COBC) $(COBFLAGS) -x -o $@ $<

# Clean target to clear built binaries
clean:
	rm -rf $(BINDIR)

.PHONY: all clean
