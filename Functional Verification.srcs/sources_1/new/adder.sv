`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 04:29:07 PM
// Design Name: 
// Module Name: adder
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


module adder(
        input [3:0] a,
        input [3:0] b,
        output [4:0] sum
    );
    
    assign sum = a + b;
    
endmodule

interface intf;
    logic [3:0] a, b;
    logic [4:0] sum;
endinterface
