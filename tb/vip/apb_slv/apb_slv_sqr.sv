class apb_slv_sqr extends uvm_sequencer#(apb_tran);

  `uvm_component_utils(apb_slv_sqr)

  function new(string name="apb_slv_sqr", uvm_component parent);
    super.new(name,parent);
  endfunction

endclass
