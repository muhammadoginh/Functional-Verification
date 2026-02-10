`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2026 06:08:14 PM
// Design Name: 
// Module Name: tb_tutorial2
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

class base_driver extends uvm_driver;
    `uvm_component_utils(base_driver)
    
    function new(string name = "base_driver", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class driver1 extends base_driver;
    `uvm_component_utils(driver1)
    
    function new(string name = "driver1", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class base_agent extends uvm_agent;
    `uvm_component_utils(base_agent)
    
    base_driver bdh;
    
    function new(string name = "base_agent", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        bdh = base_driver::type_id::create("bdh", this);
    endfunction
    
    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_string("agent_type", "BASE_AGENT");
    endfunction
endclass

class child_agent extends base_agent;
    `uvm_component_utils(child_agent)
    
    function new(string name = "child_agent", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_string("agent_type", "CHILD_AGENT");  // Override indicator
    endfunction
endclass

class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    base_agent bagent_h;
    
    function new(string name = "my_env", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        bagent_h = base_agent::type_id::create("bagent_h", this);
        super.build_phase(phase);
    endfunction
endclass

class test extends uvm_test;
    `uvm_component_utils(test);
    
    my_env envh;
    
    function new(string name = "test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      uvm_factory factory = uvm_factory::get();

      envh = my_env::type_id::create("envh", this);
      super.build_phase(phase);
      // set_type_override_by_type(base_agent::get_type(), child_agent::get_type());
      // set_type_override_by_type(base_driver::get_type(), driver1::get_type());
        
      set_inst_override_by_type("envh.bagent_h", driver1::get_type(), base_driver::get_type());
      factory.print();
    endfunction

endclass

module tb_tutorial2();
    initial begin
        run_test("test"); 
    end
endmodule
