`ifndef AHBL_IF_SV
`define AHBL_IF_SV

interface ahbl_if (input HCLK, input HRESETn);

	logic [31:0] 	HADDR;
	logic					HSEL;
	logic [1:0] 	HTRANS;
	logic [2:0] 	HBURST;
	logic [2:0] 	HSIZE;
	logic					HWRITE;
	logic [31:0]	HWDATA;
	logic [2:0] 	HPROT;
	logic [31:0]	HRDATA;
	logic					HREADYOUT;
	logic					HRESP;

	clocking ahbl_mst_cb @(posedge HCLK);
		default input #1ps output #1ps;
		
		output		HADDR;
		output		HSEL;
		output		HTRANS;
		output		HBURST;
		output		HSIZE;
		output		HWRITE;
		output		HWDATA;
		output    HPROT;
							
		input			HRDATA;
		input			HREADYOUT;
		input			HRESP;
	endclocking
	
	clocking mon_cb @(posedge HCLK);
		default input #1ps output #1ps;
		
		input		HADDR;
		input   HSEL;
		input   HTRANS;
		input   HBURST;
		input   HSIZE;
		input   HWRITE;
		input   HWDATA;
		input   HPROT;
		input   HRDATA;
		input   HREADYOUT;
		input		HRESP;
	endclocking

endinterface

`endif