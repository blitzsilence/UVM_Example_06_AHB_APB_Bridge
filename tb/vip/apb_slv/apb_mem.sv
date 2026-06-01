class apb_mem extends uvm_object;

  logic [31:0] mem[int];
  `uvm_object_utils(apb_mem)

  function new(string name="apb_mem");
    super.new(name);
  endfunction

  function bit [31:0] get_data(input bit[31:0] PADDR);
    if(mem.exists(PADDR)) begin
      get_data = mem[PADDR];
      `uvm_info("apb_mem",$sformatf("read define_data is 'h%0x, paddr is 'h%0x",get_data,PADDR),UVM_LOW);
    end
    else begin
      mem[PADDR] = $urandom_range(0,32'hFFFF_FFFF);
      get_data   = mem[PADDR];
      `uvm_info("apb_mem",$sformatf("read undefine_data is 'h%0x, paddr is 'h%0x",get_data,PADDR),UVM_LOW);
    end
  endfunction

  function void put_data(input bit[31:0] PADDR, bit[31:0] PWDATA);
    mem[PADDR] = PWDATA;
    `uvm_info("apb_mem",$sformatf("write_data is 'h%0x, paddr is 'h%0x",mem[PADDR],PADDR),UVM_LOW);
  endfunction

endclass
