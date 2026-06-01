# File list
TOP       = tb_top
RTL				= ../tb/top/rtl.f
TB		    = ../tb/top/tb.f

# Incdir list
INC_DIR   = +incdir+../tb/env
INC_DIR  += +incdir+../tb/interface
INC_DIR  += +incdir+../tb/package
INC_DIR  += +incdir+../tb/testcase
INC_DIR  += +incdir+../tb/top
INC_DIR  += +incdir+../tb/vip/ahbl_mst
INC_DIR  += +incdir+../tb/vip/apb_slv

#Compilation option
COMP_OPTS = -sverilog -debug_access+all -kdb -lca -timescale=1ns/1ps
UVM_VER   = -ntb_opts uvm  

UVM_DEFINE = UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR

#Simulation option
TESTNAME ?= ahb2apb_base_test
VERBOSITY = UVM_LOW

## Configuration
SEED 		 ?= random
DUMP_EN  ?= 0

# Enable Dump FSDB & Generate FSDB file
ifeq ($(DUMP_EN), 1)
	FSDB = +define+DUMP_FSDB
	
	ifeq ($(TESTNAME),)
		FSDB_FILE = tb.fsdb
	else
		FSDB_FILE = $(TESTNAME)_sim_dir/$(TESTNAME).fsdb
	endif
		
else
	FSDB =
	FSDB_FILE =
endif


## Makefile Target
all: clean comp sim

comp:
	vcs -full64 $(COMP_OPTS) $(UVM_VER) $(FSDB) $(COV_COMP_OPT) \
			+define+$(UVM_DEFINE) \
			-f $(RTL) -f $(TB) \
			$(INC_DIR) \
			-top $(TOP) \
			-l $(TESTNAME)_comp.log
	
sim:
	@mkdir -p $(TESTNAME)_sim_dir
	./simv $(SIM_OPT) $(COV_SIM_OPT) \
				+ntb_random_seed=$(SEED) \
				+UVM_TESTNAME=$(TESTNAME) +UVM_VERBOSITY=$(VERBOSITY) \
				+UVM_NO_RELNOTES \
				-l $(TESTNAME)_sim_dir/$(TESTNAME)_sim.log
				
verdi:
	@echo "[INFO] Open FSDB: $(FSDB_FILE)"
	@if [ ! -f "$(FSDB_FILE)" ]; then \
		echo "[ERROR] FSDB not found: $(FSDB_FILE)"; \
		exit 1; \
	fi
	verdi -ssf $(FSDB_FILE) -simflow -simBin ./simv -nologo &


.PHONY: all comp sim verdi clean cleanall

clean:
	rm -rf csrc simv simv.* *.fsdb *.log *.daidir
	
cleanall: clean	
	rm -rf novas* ucli.key vc_hdrs.h *_sim_dir
	rm -rf coverage merge.vdb urgReport vdCovLog verdiLog 
