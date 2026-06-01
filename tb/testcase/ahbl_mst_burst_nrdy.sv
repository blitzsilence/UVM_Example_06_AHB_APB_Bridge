class ahbl_mst_burst_nrdy extends ahb2apb_base_test;

  ahbl_mst_burst_seq  ahbl_mst_seq_i;
  apb_slv_nrdy_seq  apb_slv_seq_i;
  int cnt;

  `uvm_component_utils(ahbl_mst_burst_nrdy)

  function new(string name="ahbl_mst_burst_nrdy", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

endclass

function void ahbl_mst_burst_nrdy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  ahbl_mst_seq_i = ahbl_mst_burst_seq::type_id::create("ahbl_mst_seq_i");
  apb_slv_seq_i  = apb_slv_nrdy_seq::type_id::create("apb_slv_seq_i");
endfunction

task ahbl_mst_burst_nrdy::main_phase(uvm_phase phase);
  phase.raise_objection(this);
  super.main_phase(phase);
    
  #20ns;
  fork
    begin
      ahbl_mst_seq_i.start(env.ahbl_mst_agt_i.ahbl_mst_sqr_i);
    end
    begin
      cnt = 0;
      while(1) begin
        apb_slv_seq_i.start(env.apb_slv_agt_i.apb_slv_sqr_i);
        if(cnt>=ahbl_mst_seq_i.trans.get_beats()) break;      
        else cnt++;
      end
    end
  join

  phase.drop_objection(this);
endtask
