class ahbl_tran extends uvm_sequence_item;

  rand bit             HSEL;
  rand bit      [31:0] HADDR;
  rand htrans_e        HTRANS;
  rand hsize_e         HSIZE;
  rand hburst_e        HBURST;
  rand bit       [3:0] HPROT;
  rand bit             HWRITE;
  bit                  HREADY;
  rand bit      [31:0] HWDATA;
  
  bit        HREADYOUT;
  bit        HRESP;
  bit [31:0] HRDATA;

  rand int unsigned   bst_beats;       // record burst number
  rand bit     [31:0] haddr_a[];       // haddr array to transmit
  rand htrans_e       htrans_a[];      // htrans array to transmit
  rand bit     [31:0] hwdata_a[];      // hwdata array to transmit
  rand bit     [31:0] hrdata_a[];      // hrdata array to transmit

  int unsigned addr_idx  = 0;
  int unsigned trans_idx = 0;
  int unsigned wdata_idx = 0;

  function new(string name="ahbl_tran");
    super.new(name);
    HSEL      = 1'b0;
    HADDR     = 32'b0;
    HTRANS    = NONSEQ;
    HSIZE     = Byte;
    HBURST    = SINGLE;
    HPROT     = 4'b0;
    HWRITE    = 1'b0;
    HREADYOUT = 1'b1;
    HREADY    = HREADYOUT;
    HWDATA    = 32'b0;
    HRESP     = 1'b0;
    HRDATA    = 32'b0;
  endfunction

  `uvm_object_utils_begin(ahbl_tran)
    `uvm_field_int  (HSEL,             UVM_ALL_ON)
    `uvm_field_int  (HADDR,            UVM_ALL_ON)
    `uvm_field_enum (htrans_e, HTRANS, UVM_ALL_ON)
    `uvm_field_enum (hsize_e,  HSIZE,  UVM_ALL_ON)
    `uvm_field_enum (hburst_e, HBURST, UVM_ALL_ON)
    `uvm_field_int  (HPROT,            UVM_ALL_ON)
    `uvm_field_int  (HWRITE,           UVM_ALL_ON)
    `uvm_field_int  (HREADY,           UVM_ALL_ON)
    `uvm_field_int  (HWDATA,           UVM_ALL_ON)

    `uvm_field_int  (HREADYOUT,        UVM_ALL_ON)
    `uvm_field_int  (HRESP,            UVM_ALL_ON)
    `uvm_field_int  (HRDATA,           UVM_ALL_ON)

    `uvm_field_int        (bst_beats,          UVM_ALL_ON)
    `uvm_field_array_int  (haddr_a,            UVM_ALL_ON)
    `uvm_field_array_enum (htrans_e, htrans_a, UVM_ALL_ON)
    `uvm_field_array_int  (hwdata_a,           UVM_ALL_ON)
    `uvm_field_array_int  (hrdata_a,           UVM_ALL_ON)

    `uvm_field_int  (addr_idx,          UVM_ALL_ON)
    `uvm_field_int  (trans_idx,         UVM_ALL_ON)
    `uvm_field_int  (wdata_idx,         UVM_ALL_ON)
  `uvm_object_utils_end

  constraint haddr_cons{
    (HSIZE == Halfword) -> (HADDR  [0] == 1'b0 );
    (HSIZE == Word)     -> (HADDR[1:0] == 2'b00);
    solve HSIZE before HADDR;
  }

  constraint htrans_cons{
    (HTRANS == IDLE || HTRANS == BUSY) -> (HBURST == SINGLE);
    (HTRANS == SEQ)                    -> (HBURST != SINGLE);
    solve HTRANS before HBURST;
  }

  constraint hsize_cons{
    HSIZE inside {Byte, Halfword, Word};
  }

  constraint hburst_cons{
    (HBURST == SINGLE) -> (bst_beats == 1 );
    (HBURST == INCR  ) -> (bst_beats inside {[1:5]});
    (HBURST == WRAP4)  -> (bst_beats == 4 );
    (HBURST == INCR4)  -> (bst_beats == 4 );
    (HBURST == WRAP8)  -> (bst_beats == 8 );
    (HBURST == INCR8)  -> (bst_beats == 8 );
    (HBURST == WRAP16) -> (bst_beats == 16);
    (HBURST == INCR16) -> (bst_beats == 16);
    solve HBURST before bst_beats;
  }

  constraint wrap_addr_align {
    if(HBURST inside {WRAP4, WRAP8, WRAP16}) {HADDR % (bst_beats * (2**HSIZE)) == 0;}  
  }

  constraint size_dynamic {
    haddr_a .size() == bst_beats;
    hwdata_a.size() == bst_beats;
    hrdata_a.size() == bst_beats;
    htrans_a.size() == bst_beats;
  }

  function int get_hsize_bytes();
    case(HSIZE)
      Byte:     return 1;
      Halfword: return 2;
      Word:     return 4;
      default:  return 1;
    endcase
  endfunction

  function bit[31:0] next_addr();
    addr_idx++;
    return haddr_a[addr_idx-1];
  endfunction

  function bit[1:0] next_trans();
    trans_idx++;
    return htrans_a[trans_idx-1];
  endfunction

  function bit[31:0] next_wdata();
    wdata_idx++;
    return hwdata_a[wdata_idx-1];
  endfunction

  function bit last_beats();
    if(trans_idx == bst_beats)
      return 1;
    else 
      return 0;
  endfunction
	
	// add by W
	function int get_beats();
		return (bst_beats);
	endfunction


  function void post_randomize();
    int hbyte = get_hsize_bytes();

    haddr_a [0] = HADDR ;
    htrans_a[0] = NONSEQ;
    hwdata_a[0] = HWDATA;
    hrdata_a[0] = HRDATA;
    for(int i=1; i<bst_beats; i++) begin
      if(HBURST inside {WRAP4,WRAP8,WRAP16}) begin
        haddr_a[i] = haddr_a[0] + (i * hbyte) % (bst_beats * hbyte);
      end
      else begin
        haddr_a[i] = haddr_a[i-1] + hbyte;
      end
      htrans_a[i] = SEQ;
    end
  endfunction

endclass
