`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 04:32:47 PM
// Design Name: 
// Module Name: tb_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "uvm_macros.svh"
import uvm_pkg::*;

// ===== INTERFACE DEFINITION =====
interface adder_if;
    logic [3:0] a, b;
    logic [4:0] sum;
endinterface

// ===== TRANSACTION CLASS =====
class adder_txn extends uvm_sequence_item;

    rand bit [3:0] a;
    rand bit [3:0] b;
    bit      [4:0] sum;
    
    `uvm_object_utils_begin(adder_txn)
        `uvm_field_int(a, UVM_ALL_ON + UVM_DEC)
        `uvm_field_int(b, UVM_ALL_ON + UVM_DEC)
        `uvm_field_int(sum, UVM_ALL_ON + UVM_DEC)
    `uvm_object_utils_end

    function new(string name = "adder_txn");
        super.new(name);
    endfunction
endclass

class seq extends uvm_sequence #(adder_txn);
    adder_txn transh;
    
    `uvm_object_utils(seq)
    
    function new(string name = "seq");
        super.new(name);
    endfunction
    
    task body();
        repeat (10) begin
            transh = adder_txn::type_id::create("transh");
            start_item(transh);
            if (!transh.randomize()) begin
                `uvm_fatal(get_type_name(), "Transaction not randomized")
            end
            finish_item(transh);
            
            transh.print();
        end
    endtask
endclass  

class adder_sequencer extends uvm_sequencer #(adder_txn);
    `uvm_component_utils(adder_sequencer)
    
    function new(string name = "adder_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class adder_driver extends uvm_driver #(adder_txn);
    `uvm_component_utils(adder_driver)
    
    virtual adder_if inf;
    adder_txn req;

    function new(string name = "adder_driver", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual adder_if)::get(this, "", "inf", inf)) begin
            `uvm_fatal(get_type_name(), "Config db not set")
        end
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            sent_to_dut(req);
            seq_item_port.item_done();
        end
    endtask
    
    task sent_to_dut(adder_txn transh);
        inf.a <= transh.a;
        inf.b <= transh.b;
        #10;
    endtask
endclass

class adder_monitor extends uvm_monitor;
    `uvm_component_utils(adder_monitor)
    
    uvm_analysis_port #(adder_txn) send;
    
    adder_txn transh;
    virtual adder_if inf;
    
    function new(string name = "adder_monitor", uvm_component parent);
        super.new(name, parent);
        
        send = new("send", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db #(virtual adder_if)::get(this, "", "inf", inf)) begin
            `uvm_fatal(get_type_name(), "Config db not set in monitor")
        end
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            #10;
            get_from_dut();
        end
    endtask
    
    task get_from_dut();
        transh = adder_txn::type_id::create("transh", this);
        transh.a = inf.a;
        transh.b = inf.b;
        transh.sum = inf.sum;
        send.write(transh);
    endtask
endclass

class adder_agent extends uvm_agent;
    `uvm_component_utils(adder_agent)
    
    adder_driver drvh;
    adder_monitor monh;
    adder_sequencer sncrh;
    
    function new(string name = "adder_agent", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drvh = adder_driver::type_id::create("drvh", this);
        monh = adder_monitor::type_id::create("monh", this);
        sncrh = adder_sequencer::type_id::create("sncrh", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drvh.seq_item_port.connect(sncrh.seq_item_export);
    endfunction
endclass

class adder_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(adder_scoreboard)
    
    uvm_analysis_imp #(adder_txn, adder_scoreboard) receive;  // Handle name
    
    int pass_count = 0;
    int fail_count = 0;
    int total_count = 0;
    
    function new(string name = "adder_scoreboard", uvm_component parent);
        super.new(name, parent);  
        receive = new("receive", this);  
    endfunction
    
    function void write(adder_txn transh);
        total_count++;
        if (transh.sum == (transh.a + transh.b)) begin
            pass_count++;
            `uvm_info(get_type_name(), $sformatf("PASS [%0d]: %0d + %0d = %0d", 
                total_count, transh.a, transh.b, transh.sum), UVM_LOW)
        end else begin
            fail_count++;
            `uvm_error(get_type_name(), $sformatf("FAIL [%0d]: %0d + %0d != %0d (expected %0d)", 
                total_count, transh.a, transh.b, transh.sum, transh.a+transh.b))
        end
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        $display("\n" + {"="*60});
        $display("SCOREBOARD SUMMARY");
        $display({"="*60});
        $display("Total Transactions : %0d", total_count);
        $display("PASS Count        : %0d (%0.2f%%)", pass_count, (pass_count*100.0)/total_count);
        $display("FAIL Count        : %0d (%0.2f%%)", fail_count, (fail_count*100.0)/total_count);
        $display({"="*60});
        
        if (fail_count == 0)
            `uvm_info(get_type_name(), "TEST PASSED", UVM_NONE)
        else
            `uvm_error(get_type_name(), $sformatf("TEST FAILED with %0d errors", fail_count))
    endfunction
    
endclass

class adder_env extends uvm_env;
    `uvm_component_utils(adder_env)
    
    adder_scoreboard scbh;
    adder_agent agnh;
    
    function new(string name = "adder_env", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        scbh = adder_scoreboard::type_id::create("scbh", this);
        agnh = adder_agent::type_id::create("agnh", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agnh.monh.send.connect(scbh.receive);  // ? Critical connection!
    endfunction
    
endclass

class adder_test extends uvm_test;
    `uvm_component_utils(adder_test)
    
    adder_env envh;
    seq seqh;
    
    function new(string name = "adder_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        envh = adder_env::type_id::create("envh", this);
        seqh = seq::type_id::create("seqh", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this, "Test stimulus");
        seqh.start(envh.agnh.sncrh);
        #100;
        phase.drop_objection(this, "Test stimulus");
    endtask
endclass

module tb_adder();
    adder_if inf();
    
    adder dut(
        .a(inf.a), 
        .b(inf.b), 
        .sum(inf.sum));
        
    initial begin
        uvm_config_db #(virtual adder_if)::set(null, "*", "inf", inf);
        run_test("adder_test");
    end
    
    
endmodule
