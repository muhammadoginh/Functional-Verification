`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2026 07:42:47 PM
// Design Name: 
// Module Name: adder_4_bit_sequencer
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
`ifndef ADDER_4_BIT_SEQUENCER
`define ADDER_4_BIT_SEQUENCER

class adder_4_bit_sequencer extends uvm_sequencer#(adder_4_bit_transaction);
 
  `uvm_component_utils(adder_4_bit_sequencer)
 
  ///////////////////////////////////////////////////////////////////////////////
  //constructor
  ///////////////////////////////////////////////////////////////////////////////
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
   
endclass

`endif


