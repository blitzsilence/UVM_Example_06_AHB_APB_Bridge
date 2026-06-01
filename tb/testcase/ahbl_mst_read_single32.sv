class ahbl_mst_read_single32 extends ahb2apb_base_test;

  ahbl_mst_read_single_word_seq  ahbl_mst_seq_i;
  apb_slv_rdy_seq                apb_slv_seq_i;

  `uvm_component_utils(ahbl_mst_read_single32)

  function new(string name="ahbl_mst_read_single32", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

endclass

function void ahbl_mst_read_single32::build_phase(uvm_phase phase);
  super.build_phase(phase);
  ahbl_mst_seq_i = ahbl_mst_read_single_word_seq::type_id::create("ahbl_mst_seq_i");
  apb_slv_seq_i  = apb_slv_rdy_seq::type_id::create("apb_slv_seq_i");
endfunction

task ahbl_mst_read_single32::main_phase(uvm_phase phase);
  phase.raise_objection(this);
  super.main_phase(phase);

  #40ns;
  fork
    ahbl_mst_seq_i.start(env.ahbl_mst_agt_i.ahbl_mst_sqr_i);
    apb_slv_seq_i.start(env.apb_slv_agt_i.apb_slv_sqr_i);
  join

  #1us;

  phase.drop_objection(this);
endtask
