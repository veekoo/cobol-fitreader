# Compiler settings
COBC = cobc
COBFLAGS = -Wno-dialect
# COBFLAGS = -Wno-dialect -O2 -free
# COBFLAGS = -Wall -Wno-dialect -O2 -free

RUSTC = cargo

# Directories
RSSRCDIR = rs/src
RSBINDIR = rs/target/debug
SRCDIR = src
BINDIR = bin

# Source and Executable mapping
RSSOURCES = $(wildcard $(RSSRCDIR)/*.rs)
RSTARGETS = $(patsubst $(RSSRCDIR)/%.rs, $(RSBINDIR)/%, $(RSSOURCES))
SOURCES = $(wildcard $(SRCDIR)/*.cob)
TARGETS = $(patsubst $(SRCDIR)/%.cob, $(BINDIR)/%, $(SOURCES))

# Default target to build all binaries
all: $(TARGETS) $(RSTARGETS)

# Rule to build binaries from COBOL source files
$(BINDIR)/%: $(SRCDIR)/%.cob
	@mkdir -p $(BINDIR)
	$(COBC) $(COBFLAGS) -x -o $@ $<

# Add rust build
$(RSBINDIR)/%: $(RSSRCDIR)/%.rs
	@mkdir -p $(RSBINDIR)
	# $(RUSTC) build -o $@ $<
	( cd rs && cargo build )


# Clean target to clear built binaries
clean:
	rm -rf $(BINDIR)
	rm -rf $(RSBINDIR)

.PHONY: all clean
