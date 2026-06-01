`ifndef APB_IF_SV
`define APB_IF_SV

interface apb_if (input PCLK, input PRESETN);

	logic [31:0] 	PADDR;
	logic					PSEL;
	logic					PENABLE;
	logic					PWRITE;
	logic [31:0]	PWDATA;
	logic [2:0] 	PSTRB;
	logic [2:0] 	PPROT;
	logic [31:0]	PRDATA;
	logic					PREADY;
	logic					PSLVERR;

	clocking apb_slv_cb @(posedge PCLK);
		default input #1ps output #1ps;
		
		input		PADDR;
		input		PSEL;
		input		PENABLE;
		input		PWRITE;
		input		PWDATA;
		input		PSTRB;
		input		PPROT;
		
		output	PRDATA;
		output	PREADY;
		output	PSLVERR;
	endclocking
	
	clocking mon_cb @(posedge PCLK);
		default input #1ps output #1ps;
		
		input		PADDR;
		input   PSEL;
		input   PENABLE;
		input   PWRITE;
		input   PWDATA;
		input   PSTRB;
		input   PPROT;
		input   PRDATA;
		input   PREADY;
		input   PSLVERR;
	endclocking

endinterface

`endif