class apb_slv_mon extends uvm_monitor;

  virtual apb_if vif;
  apb_tran trans;
  `uvm_component_utils(apb_slv_mon)
  uvm_analysis_port #(apb_tran) ap;

  function new(string name="apb_slv_mon", uvm_component parent);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
  extern task collect_one_pkt(apb_tran trans);

endclass

function void apb_slv_mon::build_phase(uvm_phase phase);

  super.build_phase(phase);
  `uvm_info("apb_slv_mon","build_phase is called",UVM_LOW) 
  ap = new("ap",this);
  if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
    `uvm_fatal("apb_slv_mon","virtual interface must be set for vif!!!")

endfunction

task apb_slv_mon::main_phase(uvm_phase phase);

  `uvm_info("apb_slv_mon","main_phase is called",UVM_LOW)

  while(1) begin
    collect_one_pkt(trans);
  end

endtask

task apb_slv_mon::collect_one_pkt(apb_tran trans);

  `uvm_info("apb_slv_mon","begin to collect one pkt",UVM_LOW)
 
  @(vif.mon_cb);
  if(vif.mon_cb.PSEL && vif.mon_cb.PENABLE && vif.mon_cb.PREADY && vif.PRESETN) begin
  
    trans=new("trans");
    trans.PADDR = vif.mon_cb.PADDR;
    trans.PSTRB = vif.mon_cb.PSTRB;
    trans.PPROT = vif.mon_cb.PPROT;
    trans.operation = vif.mon_cb.PWRITE ? WRITE:READ;
    if(trans.operation == WRITE)
      trans.PWDATA = vif.mon_cb.PWDATA;
    else
      trans.PRDATA = vif.mon_cb.PRDATA;
    trans.PREADY = vif.mon_cb.PREADY;
    trans.PSLVERR = vif.mon_cb.PSLVERR;
  
    `uvm_info("apb_slv_mon","collect one pkt end and print:",UVM_LOW);
    trans.print();
    `uvm_info("apb_slv_mon", $sformatf("Sending transaction to analysis_port: PADDR=%0h", trans.PADDR), UVM_LOW)
    ap.write(trans);

  end

endtask
