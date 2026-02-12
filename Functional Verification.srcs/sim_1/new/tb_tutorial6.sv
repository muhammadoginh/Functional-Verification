`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 11:36:51 AM
// Design Name: 
// Module Name: tb_tutorial6
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

// Monitor component (passive observation)
class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    function new(string name = "monitor", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "BUILD PHASE CALLED FROM MONITOR COMPONENT", UVM_LOW)
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("CONNECT_PHASE", "CONNECT  PHASE CALLED FROM MONITOR COMPONENT", UVM_LOW);
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("END_OF_ELABORATION", "END OF ELABORATION CALLED FROM MONITOR COMPONENT", UVM_LOW);
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        `uvm_info("RUN_PHASE", "RUN PHASE RAISE OBJECTION CALLED FROM MONITOR COMPONENT", UVM_LOW);
        
        #50;
        phase.drop_objection(this);
        `uvm_info("RUN_PHASE", "RUN PHASE DROP OBJECTION CALLED FROM MONITOR COMPONENT", UVM_LOW);
    endtask
    
endclass

// Driver component (active stimulus)
class driver extends uvm_driver;
    
    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "BUILD PHASE CALLED FROM DRIVER COMPONENT", UVM_LOW)
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("CONNECT_PHASE", "CONNECT PHASE CALLED FROM DRIVER COMPONENT", UVM_LOW);
    endfunction
    
endclass

// Agent component (container for driver + monitor)
class agent extends uvm_agent;
    `uvm_component_utils(agent)
    
    driver drvh;
    monitor monh;
    
    function new(string name = "agent", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "BUILD PHASE CALLED FROM AGENT COMPONENT", UVM_LOW)
        
        drvh = driver::type_id::create("drvh", this);
        monh = monitor::type_id::create("monh", this);
    endfunction
    
endclass

// Environment component (container for agents)
class env extends uvm_env;
    `uvm_component_utils(env)
    
    agent agnth;
    
    function new(string name = "env", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "BUILD PHASE CALLED FROM ENV COMPONENT", UVM_LOW)
        
        agnth = agent::type_id::create("agnth", this);
    endfunction
    
endclass

class test extends uvm_test;
    `uvm_component_utils(test)
    
    env envh;
    
    function new(string name = "test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "BUILD PHASE CALLED FROM TEST COMPONENT", UVM_LOW);
        
        envh = env::type_id::create("envh", this);
    endfunction
    
endclass

module tb_tutorial6();
    initial begin
        run_test("test");
    end
endmodule
