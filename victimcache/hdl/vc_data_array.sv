module vc_data_array #(
    parameter s_line = 1,
    parameter s_mask = 1
)
(
    clk,
    rst,
    read,
    write_en,
    datain,
    dataout
);

input clk;
input rst;
input read;
input [s_mask-1:0] write_en;
input [s_line-1:0] datain;
output logic [s_line-1:0] dataout;

logic [s_line-1:0] data /* synthesis ramstyle = "logic" */;
logic [s_line-1:0] _dataout;
assign dataout = _dataout;

always_ff @(posedge clk)
begin
    if (rst) begin
      data <= '0;
    end
    else begin
        if (read)  _dataout <= (write_en) ?datain : data;



            data <= write_en ? datain :  data;

    end
end

endmodule : vc_data_array
