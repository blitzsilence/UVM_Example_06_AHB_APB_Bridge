class ahbl_mst_mon extends uvm_monitor;

  virtual ahbl_if vif;
  uvm_analysis_port#(ahbl_tran) ap;
  ahbl_tran trans;

  `uvm_component_utils(ahbl_mst_mon)

  function new(string name="ahbl_mst_mon", uvm_component parent);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
  extern task collect_one_pkt(ahbl_tran trans);

endclass

function void ahbl_mst_mon::build_phase(uvm_phase phase);

  super.build_phase(phase);
  `uvm_info("ahbl_mst_mon","build_phase is called",UVM_LOW);
  ap = new("ap",this);
  if(!uvm_config_db#(virtual ahbl_if)::get(this,"","vif",vif))
    `uvm_fatal("ahbl_mst_mon","virtual interface must be set for vif!!!");

endfunction

task ahbl_mst_mon::main_phase(uvm_phase phase);

  `uvm_info("ahbl_mst_mon","main_phase is called",UVM_LOW);

  while (1) begin
    collect_one_pkt(trans);
  end
endtask

task ahbl_mst_mon::collect_one_pkt(ahbl_tran trans);
  `uvm_info("ahbl_mst_mon", "begin to collect one pkt", UVM_LOW);

  while(1) begin
    @(posedge vif.HCLK);
    if (vif.HRESETn && vif.mon_cb.HREADYOUT && 
        vif.mon_cb.HSEL && vif.mon_cb.HTRANS[1]) begin
      break;
    end
  end

  trans = new("trans");
  trans.HSEL    = vif.mon_cb.HSEL;
  trans.HADDR   = vif.mon_cb.HADDR;
  trans.HTRANS  = htrans_e'(vif.mon_cb.HTRANS);
  trans.HSIZE   = hsize_e'(vif.mon_cb.HSIZE);
  trans.HBURST  = hburst_e'(vif.mon_cb.HBURST);
  trans.HPROT   = vif.mon_cb.HPROT;
  trans.HWRITE  = vif.mon_cb.HWRITE;
  //trans.HREADY  = vif.mon_cb.HREADY;

  `uvm_info("ahbl_mst_mon", $sformatf("Address phase: HADDR=%0h, HWRITE=%0b", 
             trans.HADDR, trans.HWRITE), UVM_LOW);
 

    while(1) begin
      @(vif.mon_cb);
      if (vif.HRESETn && vif.mon_cb.HREADYOUT) begin
        break;
      end
    end
    
    if(trans.HWRITE)begin 
      trans.HWDATA = vif.mon_cb.HWDATA;
      `uvm_info("ahbl_mst_mon", $sformatf("Write data captured: HWDATA=%0h", trans.HWDATA), UVM_LOW);
    end
    else begin
      
      trans.HRDATA = vif.mon_cb.HRDATA;
      `uvm_info("ahbl_mst_mon", $sformatf("Read data sampled by Master: HRDATA=%0h", trans.HRDATA), UVM_LOW);
    end

  trans.HREADYOUT = vif.mon_cb.HREADYOUT;
  trans.HRESP     = vif.mon_cb.HRESP;

  `uvm_info("ahbl_mst_mon", "collect one pkt end", UVM_LOW)
  trans.print();
  ap.write(trans);

endtask
