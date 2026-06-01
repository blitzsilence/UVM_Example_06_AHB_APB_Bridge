class ahb2apb_env extends uvm_env;

  uvm_tlm_analysis_fifo #(ahbl_tran) ahblagt_scb_fifo;
  uvm_tlm_analysis_fifo #(apb_tran)  apbagt_scb_fifo;
  `uvm_component_utils(ahb2apb_env)

  ahbl_mst_agt ahbl_mst_agt_i;
  apb_slv_agt  apb_slv_agt_i;
  ahb2apb_scb  ahb2apb_scb_i;

  function new(string name="ahb2apb_env", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase); 

endclass

function void ahb2apb_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
	
  ahbl_mst_agt_i = ahbl_mst_agt::type_id::create("ahbl_mst_agt_i",this);
  apb_slv_agt_i  = apb_slv_agt::type_id::create("apb_slv_agt_i",this);
  ahb2apb_scb_i  = ahb2apb_scb::type_id::create("ahb2apb_scb_i",this);

  ahblagt_scb_fifo = new("ahblagt_scb_fifo",this);
  apbagt_scb_fifo  = new("apbagt_scb_fifo",this);

  ahbl_mst_agt_i.is_active = UVM_ACTIVE;
  apb_slv_agt_i.is_active  = UVM_ACTIVE;
endfunction

function void ahb2apb_env::connect_phase(uvm_phase phase);
  ahbl_mst_agt_i.ap.connect(ahblagt_scb_fifo.analysis_export);
  ahb2apb_scb_i.ahbl_port.connect(ahblagt_scb_fifo.blocking_get_export);

  apb_slv_agt_i.ap.connect(apbagt_scb_fifo.analysis_export);
  ahb2apb_scb_i.apb_port.connect(apbagt_scb_fifo.blocking_get_export);
endfunction
