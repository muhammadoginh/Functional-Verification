`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2026 09:26:42 AM
// Design Name: 
// Module Name: jk_ff
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


module jk_ff(
        input       clk,
        input       rstn,
        input       j,
        input       k,
        output reg  q
    );
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            q <= 1'b0;
        end else begin
            case ({j,k})
                2'b00: ;        // no assignment (hold state)
                2'b01: q <= 1'b0;  // reset state
                2'b10: q <= 1'b1;  // set state
                2'b11: q <= ~q; // toggle state
                default: ;
            endcase
        end
    end
    
endmodule
