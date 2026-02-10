`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2026 06:00:52 PM
// Design Name: 
// Module Name: tb_tutorial1
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


// Code your testbench here
// or browse Examples
class wr_txn;
  rand logic [7:0] data_in;
  
  virtual function void display();
    $display("base_txn : data_in = %0d", data_in);
  endfunction
endclass

class wr_txn2 extends wr_txn;
  rand logic [15:0] data_in;
  
  function void display();
    $display("wr_txn2 : data_in = %0d", data_in);
  endfunction
endclass
  
class generator;
  wr_txn wtxnh;
  wr_txn txn_type;
  
  mailbox #(wr_txn) gen_drv_mb;
   
  function new(mailbox #(wr_txn) gen_drv_mb, wr_txn txn_type);
    this.gen_drv_mb = gen_drv_mb;
    wtxnh = txn_type;
  endfunction
    
  task send_packet();
    assert(wtxnh.randomize());
    wtxnh.display();
     
    gen_drv_mb.put(wtxnh);    
  endtask
endclass
  
class driver;
  mailbox#(wr_txn) gen_drv_mb;
    
  function new(mailbox #(wr_txn) gen_drv_mb);
    this.gen_drv_mb = gen_drv_mb;
  endfunction
    
  task drive_packet();
    wr_txn wtxnh;
    gen_drv_mb.get(wtxnh);
    wtxnh.display();
  endtask
endclass
  
class env;
  generator genh;
  driver drvh;
  wr_txn txn_type;
      
  mailbox #(wr_txn) mb;
      
  function new(wr_txn txn_type);
    mb = new();
    this.txn_type = txn_type;
    genh = new(mb,txn_type);
    drvh = new(mb);
  endfunction
      
  task run();
    genh.send_packet();
    drvh.drive_packet();
  endtask
endclass

module tb_tutorial1();
    env envh;
    wr_txn txnh;
    wr_txn2 txnh2;
    initial begin
        $display("start test");
        txnh = new();
        txnh2 = new();
        envh = new(txnh2);
        envh.run();
            
        $display("test completed");
    end
endmodule