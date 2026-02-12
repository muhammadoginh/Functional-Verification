`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 11:08:27 AM
// Design Name: 
// Module Name: tb_tutorial5
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

class packet extends uvm_object;
    rand int data;
    reg [3:0] addr;
    rand logic enable;
    
    `uvm_object_utils_begin(packet)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_NOCOPY)
        `uvm_field_int(enable, UVM_NOCOMPARE)
    `uvm_object_utils_end
    
    function new(string name = "packet");
        super.new(name);
    endfunction
    
    function void display(string handle);
        $display("%s the value of data is %d and the value of addr is %d and the value of enable is %d", handle, data, addr, enable);
    endfunction
endclass

module tb_tutorial5();
    packet p1_h, p2_h;
    
    initial begin
        p1_h = packet::type_id::create("p1_h");
        p2_h = packet::type_id::create("p2_h");
        
        p1_h.randomize();
        p1_h.addr = $random;
        p2_h.addr = $random;
        
        p2_h.copy(p1_h);
        p1_h.display("p1_h");
        p2_h.display("p2_h");
    end
endmodule
