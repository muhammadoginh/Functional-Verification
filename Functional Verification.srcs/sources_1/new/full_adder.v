`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2026 06:34:46 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder(
        input x,y,cin,
        output s,cout
    );
    
    wire s1,c1,c2;
    
    half_adder ha1(x,y,s1,c1);
    half_adder ha2(cin,s1,s,c2);
    or(cout,c1,c2);

endmodule
