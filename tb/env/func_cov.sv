class func_cov extends uvm_object;

  `uvm_object_utils(func_cov)

  covergroup cg with function sample (ahbl_tran ahbl_pkt, apb_tran apb_pkt);
    option.per_instance=1;
    haddr: coverpoint ahbl_pkt.HADDR[31:0] {
      bins a1  = {32'h0000_0001};
      bins a2  = {32'h0000_0002};
      bins a3  = {32'h0000_0003};
      bins a4  = {32'h0000_0004};
      bins a5  = {32'hffff_ffff};
      bins a6  = {32'hffff_fffe};
      bins a7  = {32'hffff_fffd};
      bins a8  = {32'hffff_fffc};
      bins a9[4]  = {[32'h0000_0005:32'hffff_fffb]};
    }
    hwrite: coverpoint ahbl_pkt.HWRITE;
    hsize : coverpoint ahbl_pkt.HSIZE;
    hburst: coverpoint ahbl_pkt.HBURST;

    cross haddr,hwrite,hsize,hburst;
  endgroup

  function new(string name="func_cov");
    super.new(name);
    cg = new();
  endfunction

endclass
