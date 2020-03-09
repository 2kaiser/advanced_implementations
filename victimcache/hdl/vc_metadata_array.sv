module vc_metadata_array #(
  parameter vc_size = 8
  )
(
    //global sigs
    clk, rst,
    read,  load,
    datain,
    dataout
);
/**********************************************************************************************/
//global sigs
input clk, rst;
input read;
input [vc_size-1:0] load;
input datain;
output logic [vc_size-1:0] dataout;
/**********************************************************************************************/
logic  [vc_size-1:0] data; /* synthesis ramstyle = "logic" */
logic   [vc_size-1:0] _dataout;
assign dataout = _dataout;
/**********************************************************************************************/
always_ff @(posedge clk)
begin
    if (rst) begin
        for (int i = 0; i < vc_size; ++i)
            data[i] <= '0;
    end
    else begin
        if (read) begin
          for (int i = 0; i < vc_size; ++i) _dataout[i] <= (load) ? datain : data[i];
        end
        for (int i = 0; i < vc_size; ++i) begin
            if(load[i])  data[i] <= datain;
        end
    end
end
/**********************************************************************************************/
endmodule : vc_metadata_array
