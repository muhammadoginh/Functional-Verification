`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2026 09:02:25 PM
// Design Name: 
// Module Name: tb_tutorial3
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

class transaction extends uvm_object;

    bit [3:0] addr;
    bit [7:0] data;
    
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "transaction");
        super.new(name);
    endfunction
    
    function void display(string message);
        $display("[%s] : the value of addr %0d and the value fo the data is %0d", message, addr, data);
    endfunction
endclass

module tb_tutorial3();
    transaction t_h1, t_h2;
    initial begin
        t_h1 = transaction::type_id::create("t_h1");
//        t_h2 = transaction::type_id::create("t_h2");  // using clone no need declaration
        
        t_h1.data = 50;
        t_h1.addr = 10;
//        t_h2.data = 40;  // This will be overwritten by copy()
        
//        t_h2.copy(t_h1);
        $cast(t_h2, t_h1.clone());
        
        t_h1.display("t_h1");
        t_h2.display("t_h2");
    end
endmodule
