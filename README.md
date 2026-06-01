# UVM_Example_AHB_APB_Bridge

## Intro
參考網上 路克驗證的課程

首先分別建立AHB_Master_Agent 跟APB_Slave_Agent 的VIP環境

再建立一個AHB2APB的Env

其中加入AHB_Master_Agent, APB_Slave_Agent, Scoreboard

使用single及burst testcse進行測試，並進行Coverage

## Verification Environment
```
    Project_root
    │
    ├── README.md
    │    
    ├── doc
    │   └── xxxx
    │
    ├── rtl
    │   └── cmsdk_ahb_to_apb.sv
    │
    ├── sim
    │   ├── Makefile
    │   └── runlist
    │ 
    └── tb
        ├── env
        │   ├── agent.sv
        │   ├── env.sv
        │   ├── monitor.sv
        │   ├── ref_model.sv
        │   ├── scoreboard.sv
        │   ├── sequencer.sv
        │   ├── sequencer.sv
        │   └── transaction.sv
        │ 
        ├── interface
        │   └── reset_if.sv
        │ 
        ├── package
        │   ├── ahb2apb_pkg.sv
        │   ├── ahbl_mst_pkg.sv
        │   └── apb_slv_pkg.sv
        │
        ├── testcase
        │   ├── ahbl_mst_burst_nrdy.sv
        │   ├── ahbl_mst_burst_slverr.sv
        │   ├── ahbl_mst_read_single32.sv
        │   └── ahbl_mst_write_single32_nrdy.sv
        │    
        ├── top
        │   ├── tb_top.sv
        │   ├── rtl.f
        │   └── tb.f
        │
        └── vip
            ├── ahbl_mst
            │   ├── ahbl_if.sv
            │   ├── ahbl_mst_agt.sv
            │   ├── ahbl_mst_drv.sv
            │   ├── ahbl_mst_mon.sv
            │   ├── ahbl_mst_seqlib.sv
            │   ├── ahbl_mst_sqr.sv
            │   └── ahbl_tran.sv
            │
            └── apb_slv
                ├── apb_if.sv
                ├── apb_mem.sv
                ├── apb_slv_agt.sv
                ├── apb_slv_drv.sv
                ├── apb_slv_mon.sv
                ├── apb_slv_seqlib.sv
                ├── apb_slv_sqr.sv
                └── apb_tran.sv

```

## Makefile excution
make comp 

make all TESTNAME=basetest

make sim TESTNAME=my_case0

make sim TESTNAME=my_case1


## UVM testbench topology
```
------------------------------------------------------------------
Name                       Type                        Size  Value
------------------------------------------------------------------
uvm_test_top               ahb2apb_base_test           -     @470 
  env                      ahb2apb_env                 -     @478 
    ahb2apb_scb_i          ahb2apb_scb                 -     @503 
      ahbl_port            uvm_blocking_get_port       -     @617 
      apb_port             uvm_blocking_get_port       -     @626 
    ahbl_mst_agt_i         ahbl_mst_agt                -     @487 
      ahbl_mst_drv_i       ahbl_mst_drv                -     @640 
        rsp_port           uvm_analysis_port           -     @657 
        seq_item_port      uvm_seq_item_pull_port      -     @648 
      ahbl_mst_mon_i       ahbl_mst_mon                -     @789 
        ap                 uvm_analysis_port           -     @798 
      ahbl_mst_sqr_i       ahbl_mst_sqr                -     @666 
        rsp_export         uvm_analysis_export         -     @674 
        seq_item_export    uvm_seq_item_pull_imp       -     @780 
        arbitration_queue  array                       0     -    
        lock_queue         array                       0     -    
        num_last_reqs      integral                    32    'd1  
        num_last_rsps      integral                    32    'd1  
    ahblagt_scb_fifo       uvm_tlm_analysis_fifo #(T)  -     @511 
      analysis_export      uvm_analysis_imp            -     @555 
      get_ap               uvm_analysis_port           -     @546 
      get_peek_export      uvm_get_peek_imp            -     @528 
      put_ap               uvm_analysis_port           -     @537 
      put_export           uvm_put_imp                 -     @519 
    apb_slv_agt_i          apb_slv_agt                 -     @495 
      apb_slv_drv_i        apb_slv_drv                 -     @812 
        rsp_port           uvm_analysis_port           -     @829 
        seq_item_port      uvm_seq_item_pull_port      -     @820 
      apb_slv_mon_i        apb_slv_mon                 -     @961 
        ap                 uvm_analysis_port           -     @971 
      apb_slv_sqr_i        apb_slv_sqr                 -     @838 
        rsp_export         uvm_analysis_export         -     @846 
        seq_item_export    uvm_seq_item_pull_imp       -     @952 
        arbitration_queue  array                       0     -    
        lock_queue         array                       0     -    
        num_last_reqs      integral                    32    'd1  
        num_last_rsps      integral                    32    'd1  
    apbagt_scb_fifo        uvm_tlm_analysis_fifo #(T)  -     @564 
      analysis_export      uvm_analysis_imp            -     @608 
      get_ap               uvm_analysis_port           -     @599 
      get_peek_export      uvm_get_peek_imp            -     @581 
      put_ap               uvm_analysis_port           -     @590 
      put_export           uvm_put_imp                 -     @572 
------------------------------------------------------------------
```



