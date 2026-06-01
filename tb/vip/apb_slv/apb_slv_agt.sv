class apb_slv_agt extends uvm_agent;

  apb_slv_drv apb_slv_drv_i;
  apb_slv_mon apb_slv_mon_i;
  apb_slv_sqr apb_slv_sqr_i;

  `uvm_component_utils(apb_slv_agt)
  uvm_analysis_port #(apb_tran) ap;

  function new(string name="apb_slv_agt", uvm_component parent);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass

function void apb_slv_agt::build_phase(uvm_phase phase);

  super.build_phase(phase);
  `uvm_info("apb_slv_agt","build_phase is called",UVM_LOW)
  if(is_active == UVM_ACTIVE) begin
    apb_slv_drv_i = apb_slv_drv::type_id::create("apb_slv_drv_i",this);
    apb_slv_sqr_i = apb_slv_sqr::type_id::create("apb_slv_sqr_i",this);
  end
  apb_slv_mon_i = apb_slv_mon::type_id::create("apb_slv_mon_i",this);

endfunction

function void apb_slv_agt::connect_phase(uvm_phase phase);

  if(is_active == UVM_ACTIVE) begin
    apb_slv_drv_i.seq_item_port.connect(apb_slv_sqr_i.seq_item_export);
  end
  ap = apb_slv_mon_i.ap;

endfunction
