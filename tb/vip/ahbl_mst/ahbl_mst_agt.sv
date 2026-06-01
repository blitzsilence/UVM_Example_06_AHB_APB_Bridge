class ahbl_mst_agt extends uvm_agent;

  ahbl_mst_drv ahbl_mst_drv_i;
  ahbl_mst_mon ahbl_mst_mon_i;
  ahbl_mst_sqr ahbl_mst_sqr_i;

  `uvm_component_utils(ahbl_mst_agt)
  uvm_analysis_port #(ahbl_tran) ap;

  function new(string name="ahbl_mst_agt", uvm_component parent);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass

function void ahbl_mst_agt::build_phase(uvm_phase phase);

  super.build_phase(phase);
  `uvm_info("ahbl_mst_agt","build_phase is called",UVM_LOW)
	
  if(is_active == UVM_ACTIVE) begin
    ahbl_mst_drv_i = ahbl_mst_drv::type_id::create("ahbl_mst_drv_i",this);
    ahbl_mst_sqr_i = ahbl_mst_sqr::type_id::create("ahbl_mst_sqr_i",this);
  end
	
  ahbl_mst_mon_i = ahbl_mst_mon::type_id::create("ahbl_mst_mon_i",this);
endfunction

function void ahbl_mst_agt::connect_phase(uvm_phase phase);

  if(is_active == UVM_ACTIVE) begin
    ahbl_mst_drv_i.seq_item_port.connect(ahbl_mst_sqr_i.seq_item_export);
  end
	
  ap = ahbl_mst_mon_i.ap;
endfunction
