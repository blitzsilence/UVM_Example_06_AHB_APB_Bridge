`ifndef AHBL_MST_PKG
`define AHBL_MST_PKG

`include "ahbl_if.sv"

package ahbl_mst_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef enum bit [1:0]{
    IDLE   = 2'b00,
    BUSY   = 2'b01,
    NONSEQ = 2'b10,
    SEQ    = 2'b11
  } htrans_e;
  
  typedef enum bit [2:0] {
    Byte       = 3'b000,
    Halfword   = 3'b001,
    Word       = 3'b010,
    Doubleword = 3'b011,
    Qword      = 3'b100,
    Oword      = 3'b101,
    Sword      = 3'b110,
    Tword      = 3'b111
  } hsize_e;
  
  typedef enum bit [2:0] {
    SINGLE = 3'b000,
    INCR   = 3'b001,
    INCR4  = 3'b010,
    WRAP4  = 3'b011,
    INCR8  = 3'b100,
    WRAP8  = 3'b101,
    INCR16 = 3'b110,
    WRAP16 = 3'b111
  } hburst_e;

  `include "ahbl_tran.sv"
  `include "ahbl_mst_seqlib.sv"
  `include "ahbl_mst_sqr.sv"
  `include "ahbl_mst_drv.sv"
  `include "ahbl_mst_mon.sv"
  `include "ahbl_mst_agt.sv"

endpackage

`endif
