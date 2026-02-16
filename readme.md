## 4-Bit Adder UVM Verification Structure

```test
adder_4bit_verification/
├── env/
│   ├── agents/
│   │   └── adder_4_bit_agent/
│   │       ├── adder_4_bit_agent.sv
│   │       ├── adder_4_bit_agent_pkg.sv
│   │       ├── adder_4_bit_defines.svh
│   │       ├── adder_4_bit_driver.sv
│   │       ├── adder_4_bit_monitor.sv
│   │       ├── adder_4_bit_sequencer.sv
│   │       └── adder_4_bit_transaction.sv
│   ├── ref_model/
│   │   ├── adder_4_bit_ref_model.sv
│   │   └── adder_4_bit_ref_model_pkg.sv
│   └── top/
│       ├── adder_4_bit_coverage.sv
│       ├── adder_4_bit_env.sv
│       ├── adder_4_bit_env_pkg.sv
│       └── adder_4_bit_scoreboard.sv
├── tb/
│   └── src/
│       ├── adder_4_bit_interface.sv
│       └── adder_4_bit_tb_top.sv
└── tests/
    ├── sequence_lib/
    │   └── src/
    │       ├── adder_4_bit_basic_seq.sv
    │       └── adder_4_bit_seq_list.sv
    └── src/
        ├── adder_4_bit_basic_test.sv
        └── adder_4_bit_test_list.sv
```