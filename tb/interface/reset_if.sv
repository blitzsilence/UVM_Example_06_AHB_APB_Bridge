`ifndef RESET_IF_SV
`define RESET_IF_SV

interface reset_if (input HCLK);

	logic HRESETn;
	
	task reset_dut();
		HRESETn = 1'b1;
		#10ns;
		HRESETn = 1'b0;
		repeat(100) @(posedge HCLK);
		HRESETn = 1'b1;
	endtask
	
endinterface

`endif