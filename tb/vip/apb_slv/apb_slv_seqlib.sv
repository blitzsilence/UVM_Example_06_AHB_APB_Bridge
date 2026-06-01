// basic sequence
class apb_slv_basic_seq extends uvm_sequence#(apb_tran);

  apb_tran trans;
  `uvm_object_utils(apb_slv_basic_seq)

  function new(string name="apb_slv_basic_seq");
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

// no wait sequence
class apb_slv_rdy_seq extends apb_slv_basic_seq;

  `uvm_object_utils(apb_slv_rdy_seq)

  function new(string name="apb_slv_rdy_seq");
    super.new(name);
  endfunction

  virtual task body(); 
    repeat(3) begin
      `uvm_do_with(trans,{trans.PREADY == 1;trans.PSLVERR == 0;trans.nready_num == 0;})
    end
  endtask

endclass

// wait sequence
class apb_slv_nrdy_seq extends apb_slv_basic_seq;
  
  `uvm_object_utils(apb_slv_nrdy_seq)


  function new(string name="apb_slv_nrdy_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(trans,{trans.PREADY ==0;trans.PSLVERR == 0;trans.nready_num inside {[1:5]};})
  endtask

endclass

// slverr sequence
class apb_slv_slverr_seq extends apb_slv_basic_seq;

  `uvm_object_utils(apb_slv_slverr_seq)

  function new(string name="apb_slv_slverr_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(trans,{trans.PREADY ==0;trans.PSLVERR == 1;trans.nready_num inside {[1:5]};})
  endtask

endclass

