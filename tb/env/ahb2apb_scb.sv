class ahb2apb_scb extends uvm_scoreboard;

  uvm_blocking_get_port #(ahbl_tran) ahbl_port;
  uvm_blocking_get_port #(apb_tran)  apb_port;
  
  ahbl_tran except_queue[$]; 
  func_cov cov;

  `uvm_component_utils(ahb2apb_scb)

  function new(string name="ahb2apb_scb", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

endclass

function void ahb2apb_scb::build_phase(uvm_phase phase);

  super.build_phase(phase);
  ahbl_port = new("ahbl_port",this);
  apb_port  = new("apb_port", this);
  cov = new("cov");

endfunction

task ahb2apb_scb::main_phase(uvm_phase phase);

  ahbl_tran ahbl_pkt;
  apb_tran  apb_pkt;

  bit result;
  `uvm_info("ahb2apb_scb","main_phase is called",UVM_LOW)
 
  while(1) begin
    `uvm_info("ahb2apb_scb", "Waiting for AHB transaction...", UVM_LOW)
    ahbl_port.get(ahbl_pkt);      
    apb_port.get(apb_pkt);
    result = 1;
    
    cov.cg.sample(ahbl_pkt, apb_pkt);

    // addr compare
    if(ahbl_pkt.HADDR[31:2] != apb_pkt.PADDR[31:2]) begin
      `uvm_error("ahb2apb_scb",$sformatf("Address mismatch: ahbl-addr[31:2][%0h], apb-addr[31:2][%0h]",ahbl_pkt.HADDR[31:2], apb_pkt.PADDR[31:2]))
      result = 0;
    end

    // size&strb compare
    if(ahbl_pkt.HWRITE) begin
      if(ahbl_pkt.HSIZE==Byte && ((ahbl_pkt.HADDR[1:0]==2'b00 && apb_pkt.PSTRB!=4'b0001) | (ahbl_pkt.HADDR[1:0]==2'b01 && apb_pkt.PSTRB!=4'b0010) | (ahbl_pkt.HADDR[1:0]==2'b10 && apb_pkt.PSTRB!=4'b0100) | (ahbl_pkt.HADDR[1:0]==2'b11 && apb_pkt.PSTRB!=4'b1000))) begin
        `uvm_error("ahb2apb_scb",$sformatf("Hsize/Haddr/Pstrb mismatch: ahbl-size: byte, ahbl-addr[1:0][%0h],apb-pstrb[%0h]",ahbl_pkt.HADDR[1:0],apb_pkt.PSTRB))
        result = 0;
      end
      if(ahbl_pkt.HSIZE==Halfword && ((ahbl_pkt.HADDR[1:0]==2'b00 && apb_pkt.PSTRB!=4'b0011) | (ahbl_pkt.HADDR[1:0]==2'b10 && apb_pkt.PSTRB!=4'b1100))) begin
        `uvm_error("ahb2apb_scb",$sformatf("Hsize/Haddr/Pstrb mismatch: ahbl-size: halfword, ahbl-addr[1:0][%0h],apb-pstrb[%0h]",ahbl_pkt.HADDR[1:0],apb_pkt.PSTRB))
        result = 0;
      end
      if (ahbl_pkt.HSIZE==Word && ahbl_pkt.HADDR[1:0]==2'b00 && apb_pkt.PSTRB!=4'b1111) begin
      `uvm_error("ahb2apb_scb",$sformatf("Hsize/Haddr/Pstrb mismatch: ahbl-size: word, ahbl-addr[1:0][%0h],apb-pstrb[%0h]",ahbl_pkt.HADDR[1:0],apb_pkt.PSTRB))
        result = 0;
      end
    end

   // prot compare
   if(ahbl_pkt.HPROT[1] != apb_pkt.PPROT[0]) begin
     `uvm_error("ahb2apb_scb",$sformatf("Prot mismatch: ahbl-prot[1][%0d], apb-prot[0][%0d]",ahbl_pkt.HPROT[1],apb_pkt.PPROT[0]))
     result = 0;
   end
   if((~ahbl_pkt.HPROT[0]) != apb_pkt.PPROT[2]) begin
     `uvm_error("ahb2apb_scb",$sformatf("Prot mismatch: ahbl-prot[0][%0d], apb-prot[2][%0d]",ahbl_pkt.HPROT[0],apb_pkt.PPROT[2]))
     result = 0;
   end

   // write compare
   if(ahbl_pkt.HWRITE & apb_pkt.operation==READ) begin
     `uvm_error("ahb2apb_scb","Write mismatch: ahbl-write, apb-read")
     result = 0;
   end
   if(!ahbl_pkt.HWRITE & apb_pkt.operation==WRITE) begin
     `uvm_error("ahb2apb_scb","Write mismatch: ahbl-read, apb-write")
     result = 0;
   end

   // data compare
   if(ahbl_pkt.HWRITE) begin
      if(ahbl_pkt.HWDATA != apb_pkt.PWDATA) begin
        `uvm_error("ahb2apb_scb",$sformatf("Wdata mismatch: ahbl-wdata[%0h], apb-wdata[%0h]",ahbl_pkt.HWDATA,apb_pkt.PWDATA))
        result = 0;
      end
    end
    else if(!ahbl_pkt.HWRITE) begin
      if(ahbl_pkt.HRDATA != apb_pkt.PRDATA) begin
        `uvm_error("ahb2apb_scb",$sformatf("Rdata mismatch: ahbl-rdata[%0h], apb-rdata[%0h]",ahbl_pkt.HRDATA,apb_pkt.PRDATA))
        result = 0;
      end
    end

    // response compare
    if(ahbl_pkt.HRESP != apb_pkt.PSLVERR) begin
      `uvm_error("ahb2apb_scb",$sformatf("Response mismatch: ahbl-resp[%0d], apb-slverr[%0d]",ahbl_pkt.HRESP,apb_pkt.PSLVERR))
      result = 0;
    end
   
    if(result) begin
      `uvm_info("ahb2apb_scb","Pkt compare PASS!!!",UVM_LOW)
      ahbl_pkt.print();
      apb_pkt.print();
    end
    else begin
      `uvm_error("ahb2apb_scb","Pkt compare FAILED!!!")
    end
  end

endtask
