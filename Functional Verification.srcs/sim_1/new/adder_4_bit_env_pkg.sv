`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2026 07:47:35 PM
// Design Name: 
// Module Name: adder_4_bit_env_pkg
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
`ifndef ADDER_4_BIT_ENV_PKG
`define ADDER_4_BIT_ENV_PKG

package adder_4_bit_env_pkg;
   
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // importing packages : agent,ref model, register ...
   /////////////////////////////////////////////////////////
   import adder_4_bit_agent_pkg::*;
   import adder_4_bit_ref_model_pkg::*;

   //////////////////////////////////////////////////////////
   // include top env files 
   /////////////////////////////////////////////////////////
  `include "adder_4_bit_coverage.sv"
  `include "adder_4_bit_scoreboard.sv"
  `include "adder_4_bit_env.sv"

endpackage

`endif

