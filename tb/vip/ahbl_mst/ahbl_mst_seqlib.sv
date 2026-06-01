// basic sequence
class ahbl_mst_basic_seq extends uvm_sequence#(ahbl_tran);

  ahbl_tran trans;
  `uvm_object_utils(ahbl_mst_basic_seq)

  function new(string name="ahbl_mst_basic_seq");
    super.new(name);
  endfunction

  virtual task pre_body();
    if (starting_phase != null)
      starting_phase.raise_objection(this);
  endtask

  virtual task post_body();
    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask

endclass


// read single word
class ahbl_mst_read_single_word_seq extends ahbl_mst_basic_seq;

  `uvm_object_utils(ahbl_mst_read_single_word_seq)

  function new(string name="ahbl_mst_read_single_word_seq");
    super.new(name);
  endfunction

  virtual task body();
    repeat(3) begin
      `uvm_do_with(trans,{trans.HSEL==1; trans.HTRANS==NONSEQ; trans.HSIZE==Word; trans.HWRITE==1'b0; trans.HBURST==SINGLE;})
    end
  endtask

endclass

// write single word
class ahbl_mst_write_single_word_seq extends ahbl_mst_basic_seq;

  `uvm_object_utils(ahbl_mst_write_single_word_seq)

  function new(string name="ahbl_mst_write_single_word_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(trans,{trans.HSEL==1'b1; trans.HTRANS==NONSEQ; trans.HSIZE==Word; trans.HWRITE==1'b1; trans.HBURST==SINGLE;})
  endtask

endclass

// write/read burst(4/8/16)
class ahbl_mst_burst_seq extends ahbl_mst_basic_seq;

  `uvm_object_utils(ahbl_mst_burst_seq)

  function new(string name="ahbl_mst_burst_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(trans,{trans.HSEL==1; !(trans.HBURST inside {SINGLE});})
  endtask

endclass

