//`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ahbl_mst_pkg.sv"
`include "apb_slv_pkg.sv"
`include "ahb2apb_pkg.sv"
import ahbl_mst_pkg::*;
import apb_slv_pkg::*; 
import ahb2apb_pkg::*;

`include "reset_if.sv"
`include "ahb2apb_base_test.sv"
`include "ahbl_mst_burst_nrdy.sv"
`include "ahbl_mst_burst_slverr.sv"
`include "ahbl_mst_write_single32_nrdy.sv"
`include "ahbl_mst_read_single32.sv"

module tb_top;

	logic HCLK;
	logic HRESETn;
	logic PCLKEN;
	logic APBACTIVE;
	logic PCLK;	
		
	reset_if	reset_if_i 	(HCLK);
	ahbl_if 	ahbl_if_i		(HCLK, HRESETn);
	apb_if		apb_if_i		(PCLK, HRESETn);
	
  cmsdk_ahb_to_apb #(
    .ADDRWIDTH(32),
    .REGISTER_RDATA(1),
    .REGISTER_WDATA(0)
  ) dut(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .PCLKEN(PCLKEN),

    .HSEL   		(ahbl_if_i.HSEL),  
    .HADDR  		(ahbl_if_i.HADDR), 
    .HTRANS 		(ahbl_if_i.HTRANS),
    .HSIZE  		(ahbl_if_i.HSIZE), 
    .HPROT  		(ahbl_if_i.HPROT), 
    .HWRITE 		(ahbl_if_i.HWRITE),
    .HREADY 		(ahbl_if_i.HREADYOUT),
    .HWDATA 		(ahbl_if_i.HWDATA),   

    .HREADYOUT 	(ahbl_if_i.HREADYOUT), 
    .HRDATA    	(ahbl_if_i.HRDATA),   
    .HRESP     	(ahbl_if_i.HRESP),    
              
    .PADDR   		(apb_if_i.PADDR),    
    .PENABLE 		(apb_if_i.PENABLE),  
    .PWRITE  		(apb_if_i.PWRITE),   
    .PSTRB   		(apb_if_i.PSTRB),    
    .PPROT   		(apb_if_i.PPROT),    
    .PWDATA  		(apb_if_i.PWDATA),   
    .PSEL    		(apb_if_i.PSEL),     
              
    .APBACTIVE 	(APBACTIVE),
               
    .PRDATA  		(apb_if_i.PRDATA),   
    .PREADY  		(apb_if_i.PREADY),   
    .PSLVERR 		(apb_if_i.PSLVERR) 
  );
	
	assign HRESETn = reset_if_i.HRESETn;
	
	parameter simulation_cycle = 100;		// 100ns: clk=10MHz
	
	bit[1:0] value;
	int unsigned ratio;

	initial begin
		value = $urandom_range(0,3);
		
		case(value)
			0: ratio = 1;
			1: ratio = 2;
			2: ratio = 4;
			3: ratio = 8;
			default: ratio = 1;
		endcase
	end
	
	bit[3:0] cnt;
   always @(posedge HCLK or negedge HRESETn) begin
      if(!HRESETn) cnt <= 0;
      else if( cnt == (ratio-1)) cnt <= 0;
      else cnt <= cnt + 1'b1;
   end
   always @(negedge HCLK or negedge HRESETn) begin
     if(!HRESETn) PCLKEN <= 0;
     else if( cnt == (ratio-1) ) PCLKEN <= 1'b1;
     else PCLKEN <= 0;
   end
   assign PCLK = PCLKEN && HCLK;

	// CLOCK generation
	initial begin
		HCLK = 0;
		forever
				#(simulation_cycle/2) HCLK = ~HCLK;	// 10MHz
	end

	
	// Configuration
	initial begin
		// Format for time display
		$timeformat(-9, 2, "ns", 10);
		
		// Interface configuration from tb_top (HW) to verification env (SW)
		uvm_config_db #(virtual reset_if)::set(null, "uvm_test_top", "vif", reset_if_i);
		uvm_config_db #(virtual ahbl_if)::set(null, "uvm_test_top.env.ahbl_mst_agt_i.ahbl_mst_drv_i", "vif", ahbl_if_i);
		uvm_config_db #(virtual ahbl_if)::set(null, "uvm_test_top.env.ahbl_mst_agt_i.ahbl_mst_mon_i", "vif", ahbl_if_i);
		uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top.env.apb_slv_agt_i.apb_slv_drv_i", "vif", apb_if_i);
		uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top.env.apb_slv_agt_i.apb_slv_mon_i", "vif", apb_if_i);
	end
	
	
	initial begin
		run_test("ahb2apb_base_test");
	end


	// assertion
	property psel_high_then_apbactive_high;
		@(posedge PCLK) disable iff(!HRESETn)
		apb_if_i.PSEL |-> APBACTIVE;
	endproperty

	property apbactive_high_then_psel_high;
		@(posedge PCLK) disable iff(!HRESETn)
		$rose(APBACTIVE) |=> apb_if_i.PSEL;
	endproperty

	property hresp_hready;
		@(posedge PCLK) disable iff(!HRESETn)
		ahbl_if_i.HRESP |-> ahbl_if_i.HREADYOUT && !$past(ahbl_if_i.HREADYOUT);
	endproperty

	a_psel_high_then_apbactive_high: assert property(psel_high_then_apbactive_high);
	a_apbactive_high_then_psel_high: assert property(apbactive_high_then_psel_high);
	a_hresp_hready:                  assert property(hresp_hready);

	// ratio coverpoint
	covergroup hclk_pclk_ratio;
		option.per_instance = 1;
		option.name = "hclk_pclk_ratio";
		ratio_clk: coverpoint ratio;
	endgroup

	hclk_pclk_ratio hclk_pclk_ratio_i = new();

	always @(posedge PCLK) begin
		hclk_pclk_ratio_i.sample();
	end

	// Dump fsdb
	`ifdef DUMP_FSDB
	initial begin : FSDB_generation
		string testname;
		
		$display("DUMP FSDB START!");
		if ($value$plusargs("UVM_TESTNAME=%s", testname) && testname != "") begin
			$fsdbDumpfile({testname, "_sim_dir/", testname, ".fsdb"});
		end else begin
			$fsdbDumpfile("tb.fsdb");
		end
		
		$fsdbDumpvars(0, tb_top);
		$fsdbDumpvars(0, tb_top.dut);
	end
	`endif

endmodule
