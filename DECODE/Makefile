# https://github.com/jimtremblay/ghdl-example/blob/master/Makefile
# VHDL files
FILES = src/*
TOP_F = top/*

# Test Bench files
TB_PATH = testbench/${TB_FILE}*
TB_FILE = ${TB}_tb
WORKDIR = work

# GHDL config

GHDL_CMD = ghdl
GHDL_FLAGS = -v --workdir=$(WORKDIR)

# Simulation options
STOP_TIME = 50ns
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)
WAVEFORM_VIEWER = gtkwave

all : make run view

all_top : make make_top run view

make :
# strip removes whitespace from TB argument
# ifeq checks if the argument is defined
ifeq ($(strip $(TB)),)
	@echo "TB not set. Use TB=<value> to set it."
	@echo "Example: make TB=adder"
	@exit 1
endif
# Create temporal work directory
	@mkdir -p $(WORKDIR)
# Analyze the files
	@$(GHDL_CMD) -a $(GHDL_FLAGS) $(FILES)
#@$(GHDL_CMD) -a $(GHDL_FLAGS) $(TOP_F)
	@$(GHDL_CMD) -a $(GHDL_FLAGS) $(TB_PATH)
# Elaborate (create executable)
	@$(GHDL_CMD) -e $(GHDL_FLAGS) $(TB_FILE)

make_top :

ifeq ($(strip $(TB)),)
	@echo "TB not set. Use TB=<value> to set it."
	@echo "Example: make TB=adder"
	@exit 1
endif
	@$(GHDL_CMD) -a $(GHDL_FLAGS) $(TOP_F)

run :
# Run the simulation
	@$(GHDL_CMD) -r --workdir=$(WORKDIR) $(TB_FILE) --vcd=$(TB_FILE).vcd $(GHDL_SIM_OPT)
# Move the .vcd file to the work directory
	@mv $(TB_FILE).vcd $(WORKDIR)/

view:
	@$(WAVEFORM_VIEWER) --dump=$(WORKDIR)/$(TB_FILE).vcd

# clean :
# # Remove the work directory
# 	@rm -rf $(WORKDIR)