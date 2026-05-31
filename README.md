# UVM_Example_AHB_APB_Bridge

#### Intro
參考網上 路克驗證的課程
首先，分別建立AHB_Master_Agent跟APB_Slave_Agent的VIP環境
再建立一個AHB2APB的Env
其中加入AHB_Master_Agent, APB_Slave_Agent, Scoreboard，並進行Coverage

#### Verification Environment
```
    Project_root
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

#### Makefile excution note
make comp 

make all TESTNAME=basetest

make sim TESTNAME=my_case0

make sim TESTNAME=my_case1


Dump FSDB:

make sim TESTNAME=my_case0 DUMP_EN=1

make sim TESTNAME=my_case1 DUMP_EN=1

