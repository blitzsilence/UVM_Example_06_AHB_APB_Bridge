class ahbl_mst_drv extends uvm_driver#(ahbl_tran);

  virtual ahbl_if vif;
  ahbl_tran pkt_apha = null;
  ahbl_tran pkt_dpha = null;
  `uvm_component_utils(ahbl_mst_drv)

  function new(string name="ahbl_mst_drv", uvm_component parent);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
  extern task drive_1cyc_apha(ref ahbl_tran trans);
  extern task drive_1cyc_dpha(ref ahbl_tran trans);
  extern task drive_1cyc_idle();

endclass

function void ahbl_mst_drv::build_phase(uvm_phase phase);
  
  super.build_phase(phase);
  `uvm_info("ahbl_mst_drv","build_phase is called",UVM_LOW)
  if(!uvm_config_db#(virtual ahbl_if)::get(this,"","vif",vif))
    `uvm_fatal("ahbl_mst_drv", "virtual interface must be set for vif!!!")

endfunction

task ahbl_mst_drv::main_phase(uvm_phase phase);

  `uvm_info("ahbl_mst_drv","main_phase is called",UVM_LOW)

  while(1) begin
  
    @(vif.ahbl_mst_cb);
    // RESET operation
    if(!vif.HRESETn) begin
      drive_1cyc_idle();
    end

    else begin
      
      // address phase
      if(pkt_apha != null) begin
        drive_1cyc_apha(pkt_apha);
      end
      else begin
        seq_item_port.get_next_item(pkt_apha);
        if( pkt_apha != null) begin
          drive_1cyc_apha(pkt_apha);
        end
        else begin
          drive_1cyc_idle();
        end
      end
      
      // data phase
      if(pkt_dpha != null) begin
        drive_1cyc_dpha(pkt_dpha);
        if((vif.ahbl_mst_cb.HREADYOUT && pkt_dpha.HBURST==SINGLE)|| pkt_dpha.last_beats()) begin
          seq_item_port.item_done();
          pkt_apha = null;
          pkt_dpha = null;
        end
      end

    end

  end

endtask

task ahbl_mst_drv::drive_1cyc_apha(ref ahbl_tran trans);

  //sample when HREADYOUT=1
  if(vif.ahbl_mst_cb.HREADYOUT) begin
    vif.ahbl_mst_cb.HSEL   <= trans.HSEL;
    vif.ahbl_mst_cb.HTRANS <= trans.next_trans();
    vif.ahbl_mst_cb.HSIZE  <= trans.HSIZE;
    vif.ahbl_mst_cb.HPROT  <= trans.HPROT;
    vif.ahbl_mst_cb.HWRITE <= trans.HWRITE;
    vif.ahbl_mst_cb.HADDR  <= ((trans.HTRANS != IDLE) && (trans.HTRANS != BUSY)) ? trans.next_addr():vif.HADDR;
    this.pkt_dpha = this.pkt_apha;
  end
  else begin
    //remain unchange
  end

endtask

task ahbl_mst_drv::drive_1cyc_dpha(ref ahbl_tran trans);
  
  if(vif.ahbl_mst_cb.HREADYOUT) begin
    if(trans.HWRITE)
      vif.ahbl_mst_cb.HWDATA <= ((trans.HTRANS != IDLE) && (trans.HTRANS != BUSY))? trans.next_wdata() : vif.HWDATA;
    else vif.ahbl_mst_cb.HWDATA <= 32'b0;
  end

endtask

task ahbl_mst_drv::drive_1cyc_idle();
  vif.ahbl_mst_cb.HSEL   <= 1'b0;
  vif.ahbl_mst_cb.HTRANS <= 2'b0;
  vif.ahbl_mst_cb.HSIZE  <= 3'b0;
  vif.ahbl_mst_cb.HPROT  <= 4'b0;
  vif.ahbl_mst_cb.HWRITE <= 1'b0;
  vif.ahbl_mst_cb.HWDATA <= 32'b0;
  vif.ahbl_mst_cb.HADDR  <= 32'b0;
  vif.ahbl_mst_cb.HBURST <= 3'b0;
endtask
