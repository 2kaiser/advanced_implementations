module tb();
  timeunit 1ns;
  timeprecision 1ns;

  /****************************** Generate Clock *******************************/
  bit clk;
  always #1 clk = clk === 1'b0;
logic rst;
//from cpu
logic [31:0] mem_addr;
//from L1 control
logic priority_level, addr_exists,test_resp_i,insert_resp_i,resp_o;


EAF dut(.*);

initial begin
  rst = 1; #3;
  rst = 0; mem_addr = 1; insert_resp_i = 1; #4;
  insert_resp_i = 0; #4;
  test_resp_i = 1; #2;
  test_resp_i = 0; #2;

end
endmodule : tb
