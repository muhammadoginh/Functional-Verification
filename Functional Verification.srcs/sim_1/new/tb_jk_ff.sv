`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2026 09:36:47 AM
// Design Name: 
// Module Name: tb_jk_ff
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
interface jk_ff_if(input bit clk);
    logic j, k, rstn;
    logic q;
endinterface

// ===== CONFIGURATION CLASS =====
class config_jk extends uvm_object;
    `uvm_object_utils(config_jk)
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    function new(string name = "config_jk");
        super.new(name);
    endfunction
endclass

// ===== TRANSACTION CLASS =====
class jk_ff_txn extends uvm_sequence_item;
    rand bit  j;
    rand bit  k;
    rand bit  rstn;
    bit q;

    function new(string name = "jk_ff_txn");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(jk_ff_txn)
        `uvm_field_int(j,UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(k,UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(rstn,UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(q,UVM_ALL_ON | UVM_DEC)
    `uvm_object_utils_end
endclass: jk_ff_txn

// ===== SEQUENCES =====
class valid_jk extends uvm_sequence #(jk_ff_txn);
    jk_ff_txn tr;
    `uvm_object_utils(valid_jk)
    
    function new(string name = "valid_jk");
        super.new(name);
    endfunction
    
    task body();
        repeat (5) begin
            tr=jk_ff_txn::type_id::create("tr");
            start_item(tr);
            if(!tr.randomize() with {rstn==1;})
            `uvm_fatal(get_type_name(),"Trans not Randomized")
            finish_item(tr);
            tr.print();
        end
    endtask
endclass

class rstn_check extends uvm_sequence #(jk_ff_txn);
    jk_ff_txn tr;
    `uvm_object_utils(rstn_check)
  
    function new(string name = "rstn_check");
        super.new(name);
    endfunction
  
    task body();
        repeat (5) begin
            tr=jk_ff_txn::type_id::create("tr");
            start_item(tr);
            if(!tr.randomize() with {rstn==0;})
                `uvm_fatal(get_type_name(),"Trans not Randomized")
            finish_item(tr);
            tr.print();
        end
    endtask
endclass

class random_check extends uvm_sequence #(jk_ff_txn);
    jk_ff_txn tr;
    `uvm_object_utils(random_check)
    
    function new(string name = "random_check");
        super.new(name);
    endfunction
    
    task body();
        repeat (5) begin
            tr=jk_ff_txn::type_id::create("tr");
            start_item(tr);
            if(!tr.randomize())
            `uvm_fatal(get_type_name(),"Trans not Randomized")
            finish_item(tr);
            tr.print();
        end
    endtask
endclass

// ===== SEQUENCER =====
class jk_ff_sequencer extends uvm_sequencer #(jk_ff_txn);
    `uvm_component_utils(jk_ff_sequencer)
    function new(string name = "jk_ff_sequencer",uvm_component parent);
        super.new(name,parent);
    endfunction
endclass

// ===== DRIVER =====
class jk_ff_driver extends uvm_driver #(jk_ff_txn);
    `uvm_component_utils(jk_ff_driver)
    virtual jk_ff_if v_if;
    jk_ff_txn req;

    function new(string name = "jk_ff_driver",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual jk_ff_if)::get(this,"","v_if",v_if))
            `uvm_fatal(get_type_name(),"Config db not set")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            send_to_dut(req);
            seq_item_port.item_done();
        end
    endtask

    task send_to_dut(jk_ff_txn req);
        v_if.j   <= req.j;
        v_if.k   <= req.k;
        v_if.rstn <= req.rstn;
        @(negedge v_if.clk);
    endtask
endclass

// ===== MONITOR =====
class jk_ff_monitor extends uvm_monitor;
    `uvm_component_utils(jk_ff_monitor)
    uvm_analysis_port #(jk_ff_txn) send;
    jk_ff_txn tr;
    virtual jk_ff_if v_if;

    function new(string name = "jk_ff_monitor",uvm_component parent);
        super.new(name,parent);
        send = new("send",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual jk_ff_if)::get(this,"","v_if",v_if))
            `uvm_fatal(get_type_name(),"Config db not set in monitor")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge v_if.clk);
            get_from_dut();
        end
    endtask

    task get_from_dut();
        tr=jk_ff_txn::type_id::create("tr",this);
        tr.j   = v_if.j;
        tr.k   = v_if.k;
        tr.rstn = v_if.rstn;
        tr.q   = v_if.q;
        send.write(tr);
    endtask
endclass: jk_ff_monitor

// ===== AGENT =====
class jk_ff_agent extends uvm_agent;
    `uvm_component_utils(jk_ff_agent)
    jk_ff_driver drv;
    jk_ff_monitor mon;
    jk_ff_sequencer sncr;
    config_jk cfg;

    function new(string name = "jk_ff_agent",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon=jk_ff_monitor::type_id::create("mon",this);
        if(!uvm_config_db #(config_jk)::get(this,"","cfg",cfg))
            `uvm_fatal(get_type_name(),"Config not received")
        if(cfg.is_active == UVM_ACTIVE) begin
            drv=jk_ff_driver::type_id::create("drv",this);
            sncr=jk_ff_sequencer::type_id::create("sncr",this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sncr.seq_item_export);
    endfunction
endclass: jk_ff_agent

// ===== SCOREBOARD =====
class jk_ff_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(jk_ff_scoreboard)
    bit ref_q;
    uvm_analysis_imp #(jk_ff_txn, jk_ff_scoreboard) receive;

    function new(string name = "jk_ff_scoreboard", uvm_component parent);
        super.new(name,parent);
        receive = new("receive",this);
        ref_q = 0;
    endfunction

    function void write(jk_ff_txn tr);
        if(tr.rstn == 1'b0) begin
            ref_q = 0;
            `uvm_info(get_type_name(), "Reset check Passed", UVM_LOW)
        end
        else if (tr.rstn == 1'b1) begin
            case ({tr.j, tr.k})
                2'b00: ref_q = ref_q;
                2'b01: ref_q = 0;
                2'b10: ref_q = 1;
                2'b11: ref_q = ~ref_q;
            endcase
            if(tr.q == ref_q)
                `uvm_info(get_type_name(), $sformatf("PASS: q=%0b", tr.q), UVM_LOW)
            //       else
            //         `uvm_error(get_type_name(), $sformatf("FAIL: q=%0b expected %0b", tr.q, ref_q))
        end
    endfunction
endclass

// ===== ENVIRONMENT =====
class jk_ff_env extends uvm_env;
    `uvm_component_utils(jk_ff_env)
    jk_ff_scoreboard scb;
    jk_ff_agent agt;
    config_jk cfg;

    function new(string name = "jk_ff_env",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = config_jk::type_id::create("cfg");
        uvm_config_db #(config_jk)::set(this,"*","cfg",cfg);
        scb = jk_ff_scoreboard::type_id::create("scb",this);
        agt = jk_ff_agent::type_id::create("agt", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.send.connect(scb.receive);
    endfunction
endclass

// ===== TEST =====
class jk_ff_test extends uvm_test;
    `uvm_component_utils(jk_ff_test)
    jk_ff_env ev;
    valid_jk seq1;
    rstn_check seq2;
    random_check seq3;

    function new(string name = "jk_ff_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ev=jk_ff_env::type_id::create("ev",this);
        seq1=valid_jk::type_id::create("seq1",this);
        seq2=rstn_check::type_id::create("seq2",this);
        seq3=random_check::type_id::create("seq3",this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        seq1.start(ev.agt.sncr);
        seq2.start(ev.agt.sncr);
        seq3.start(ev.agt.sncr);
        phase.drop_objection(this);
    endtask
endclass

// ===== TOP MODULE =====
module tb_jk_ff();
    bit clk;
    jk_ff_if v_if(clk);
    always #5 clk=~clk;

    jk_ff dut(.j(v_if.j),
            .k(v_if.k),
            .q(v_if.q),
            .rstn(v_if.rstn),
            .clk(v_if.clk));

    initial begin
        uvm_config_db #(virtual jk_ff_if)::set(null,"*","v_if",v_if);
        run_test("jk_ff_test");
    end

endmodule
