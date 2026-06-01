class apb_tran extends uvm_sequence_item;
  
  bit [31:0] PADDR;
  bit [3:0]  PSTRB;
  bit [2:0]  PPROT;
  bit [31:0] PWDATA;
	
  operation_e operation;   			// WRITE or READ
	
  rand bit   PREADY;
  rand bit   PSLVERR;
  rand bit [31:0] PRDATA;
  rand int unsigned nready_num; // PREADY=0 cycles
  
  `uvm_object_utils_begin(apb_tran)
    `uvm_field_int(PADDR,UVM_ALL_ON)
    `uvm_field_int(PSTRB,UVM_ALL_ON)
    `uvm_field_int(PPROT,UVM_ALL_ON)
    `uvm_field_int(PWDATA,UVM_ALL_ON)
    `uvm_field_int(PREADY,UVM_ALL_ON)
    `uvm_field_int(PSLVERR,UVM_ALL_ON)
    `uvm_field_int(PRDATA,UVM_ALL_ON)
    `uvm_field_enum(operation_e,operation,UVM_ALL_ON)
    `uvm_field_int(nready_num,UVM_ALL_ON|UVM_NOPRINT)
  `uvm_object_utils_end	
	
  function new(string name="apb_tran");
    super.new(name);
  endfunction



endclass
