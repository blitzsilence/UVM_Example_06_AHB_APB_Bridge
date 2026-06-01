`ifndef APB_SLV_PKG
`define APB_SLV_PKG

`include "apb_if.sv"

package apb_slv_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  typedef enum {WRITE,READ} operation_e;

  `include "apb_tran.sv"
  `include "apb_mem.sv"
  `include "apb_slv_seqlib.sv"
  `include "apb_slv_sqr.sv"
  `include "apb_slv_drv.sv"
  `include "apb_slv_mon.sv"
  `include "apb_slv_agt.sv"

endpackage

`endif
