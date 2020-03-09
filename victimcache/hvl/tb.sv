module tb();
  timeunit 1ns;
  timeprecision 1ns;

  /****************************** Generate Clock *******************************/
  bit clk;
  always #1 clk = clk === 1'b0;
logic rst;
//from cpu
logic [31:0] mem_address;
//from L1 control
logic vc_write,vc_read; //asserted on memory access by cacheline adapter
//from L1 cache
logic [255:0] mem_wdata;
logic  rdata_exists;
logic is_mem_wdata_dirty;

//OUTS
//to cache
logic [255:0] vc_vcmem_rdata256; //output line

victimcache dut(.*);

initial begin
  rst = 1; #3;
  rst = 0;  mem_address = 1; mem_wdata = 1; vc_write = 1; is_mem_wdata_dirty = 0;  #2;
  vc_write = 0; #2;
  vc_read = 0; #2;
  vc_read = 0; #6;



end
endmodule : tb
