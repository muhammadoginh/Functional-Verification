`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2026 07:45:55 PM
// Design Name: 
// Module Name: adder_4_bit_ref_model_pkg
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
`ifndef ADDER_4_BIT_REF_MODEL_PKG
`define ADDER_4_BIT_REF_MODEL_PKG

package adder_4_bit_ref_model_pkg;

   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // importing packages : agent,ref model, register ...
   /////////////////////////////////////////////////////////
   import adder_4_bit_agent_pkg::*;

   //////////////////////////////////////////////////////////
   // include ref model files 
   /////////////////////////////////////////////////////////
  `include "adder_4_bit_ref_model.sv"

endpackage

`endif




