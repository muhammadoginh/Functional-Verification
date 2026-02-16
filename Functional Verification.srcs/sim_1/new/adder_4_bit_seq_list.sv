`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2026 07:51:43 PM
// Design Name: 
// Module Name: adder_4_bit_seq_list
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
`ifndef ADDER_4_BIT_SEQ_LIST 
`define ADDER_4_BIT_SEQ_LIST

package adder_4_bit_seq_list;

 import uvm_pkg::*;
 `include "uvm_macros.svh"

 import adder_4_bit_agent_pkg::*;
 import adder_4_bit_ref_model_pkg::*;
 import adder_4_bit_env_pkg::*;

 //////////////////////////////////////////////////////////////////////////////
 // including adder_4_bit test list
 //////////////////////////////////////////////////////////////////////////////

 `include "adder_4_bit_basic_seq.sv"

endpackage

`endif
