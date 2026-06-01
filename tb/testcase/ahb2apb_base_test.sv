class ahb2apb_base_test extends uvm_test;

  ahb2apb_env env;
  virtual reset_if rif;
  `uvm_component_utils(ahb2apb_base_test)

  function new(string name="ahb2apb_base_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  extern virtual function void build_phase (uvm_phase phase);
	extern virtual function void end_of_elaboration_phase (uvm_phase phase);
  extern virtual task main_phase (uvm_phase phase);
  extern virtual function void report_phase (uvm_phase phase);

endclass

function void ahb2apb_base_test::build_phase(uvm_phase phase);

  super.build_phase(phase);
  env = ahb2apb_env::type_id::create("env",this);
  if(!uvm_config_db #(virtual reset_if)::get(this,"","vif",rif))
    `uvm_fatal("ahb2apb_base_test","virtual interface must be set for reset!")

endfunction

function void ahb2apb_base_test::end_of_elaboration_phase (uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction

task ahb2apb_base_test::main_phase(uvm_phase phase);
  rif.reset_dut();
  phase.phase_done.set_drain_time(this,2us);
endtask

function void ahb2apb_base_test::report_phase (uvm_phase phase);
  
  uvm_report_server server;
  int err_num;
  server = get_report_server();
  err_num = server.get_severity_count(UVM_ERROR);

  if(err_num !=0) begin
    $display("TEST FAIlED");
  end
  else begin
    $display("TEST PASS!!!");
  end

endfunction
