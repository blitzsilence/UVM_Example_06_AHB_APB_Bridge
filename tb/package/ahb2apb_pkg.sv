`ifndef AHB2APB_PKG
`define AHB2APB_PKG

package ahb2apb_pkg;

  `include "uvm_macros.svh"
	import uvm_pkg::*;

  import ahbl_mst_pkg::*;
  import apb_slv_pkg::*;

  `include "func_cov.sv"
  `include "ahb2apb_scb.sv"
  `include "ahb2apb_env.sv"

endpackage

`endif
