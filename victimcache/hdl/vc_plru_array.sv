module vc_plru_array #(
  parameter num_output_bits = 3 //plru_array_size-1
  )
(
    //global sigs
    clk, rst,
    //from control
    read,  load,
    datain,
    //from vc lru logic control
    dataout
);
/**********************************************************************************************/
//global sigs
input clk, rst;
input read;
input load;
input [num_output_bits-1:0] datain;
output logic [num_output_bits-1:0] dataout;
/**********************************************************************************************/
logic [num_output_bits-1:0] data; /* synthesis ramstyle = "logic" */
logic [num_output_bits-1:0] _dataout;
assign dataout = _dataout;
/**********************************************************************************************/
always_ff @(posedge clk)
begin
    if (rst)  data <= '0;
    else begin
        if (read)  _dataout <= (load) ? datain : data;
        if(load)  data <= datain;
    end
end
/**********************************************************************************************/
endmodule : vc_plru_array
