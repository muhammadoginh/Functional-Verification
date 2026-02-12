`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 10:54:24 AM
// Design Name: 
// Module Name: tb_tutorial4_2
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


module tb_tutorial4_2();

    int a = 10;
    int b = 20;
    string msg;
    
    initial begin
        $display("the value of a is %d", a);
        
        msg = $sformatf("using $sformatf statement : b = %0d", b);
        
        $display(msg);
    end
    
endmodule
