class apb_slv_drv extends uvm_driver#(apb_tran);

  virtual apb_if vif;
  apb_tran trans;
  apb_mem mem;
  `uvm_component_utils(apb_slv_drv)

  function new(string name="apb_slv_drv", uvm_component parent);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
  extern task drive_one_pkt(apb_tran trans);

endclass

function void apb_slv_drv::build_phase(uvm_phase phase);

  super.build_phase(phase);
  `uvm_info("apb_slv_drv","build_phase is called",UVM_LOW)
  mem = apb_mem::type_id::create("mem"); 
  if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
    `uvm_fatal("apb_slv_drv","virtual interface must be set for vif!!!")

endfunction

task apb_slv_drv::main_phase(uvm_phase phase);

  `uvm_info("apb_slv_drv","main_phase is called",UVM_LOW)

  // drive DUT
  while(1) begin
    @(vif.apb_slv_cb);
    if(!vif.PRESETN) begin
      vif.apb_slv_cb.PREADY  <= 1'b1;
      vif.apb_slv_cb.PSLVERR <= 1'b0;
    end
    else if (vif.apb_slv_cb.PSEL && !vif.apb_slv_cb.PENABLE) begin
      seq_item_port.get_next_item(req);
      drive_one_pkt(req);
      seq_item_port.item_done();
    end
  end

endtask

task apb_slv_drv::drive_one_pkt(apb_tran trans);
  
  int nready_num=trans.nready_num;
  `uvm_info("apb_slv_drv","begin to drive one pkt",UVM_LOW)

  while(nready_num != 0) begin    
    vif.apb_slv_cb.PREADY <= 1'b0;
    nready_num--;
    @(vif.apb_slv_cb);
  end

  vif.apb_slv_cb.PREADY  <= 1'b1;
  vif.apb_slv_cb.PSLVERR <= trans.PSLVERR;

  if(vif.apb_slv_cb.PWRITE) begin
    if(!vif.PSLVERR)
      mem.put_data(vif.apb_slv_cb.PADDR, vif.apb_slv_cb.PWDATA);
  end
  else begin
    if(!vif.PSLVERR) 
      vif.apb_slv_cb.PRDATA <= mem.get_data(vif.apb_slv_cb.PADDR);
    else
      vif.apb_slv_cb.PRDATA <= $urandom_range(0,32'hFFFF_FFFF);
  end

  @(vif.apb_slv_cb);
  vif.apb_slv_cb.PREADY  <= 1'b1;
  vif.apb_slv_cb.PSLVERR <= 1'b0;
endtask
