module vc_metadata_store #(
  parameter num_output_bits = 3, //log2(plru_array_size+1)
  parameter tag_width = 24,
  parameter vc_size = 8,
  parameter num_idx_bits = $clog2(vc_size),
  parameter num_mux_sel_bits = 3
)
(
//global sigs
clk, rst,
//from control to vc_valid_array
vc_valid_read, vc_valid_ld, vc_valid_datain,
//from control to vc_drity array
vc_dirty_read, vc_dirty_ld, vc_dirty_datain,
//from control to vc_plru_register
vc_plru_read, vc_plru_ld, vc_plru_datain,

//OUTS
//to control logic
vc_dirty_dataout, vc_valid_dataout, vc_plru_dataout

);
/**********************************************************************************************/
//global sigs
input clk, rst;
//from control to vc_valid_array
input vc_valid_read, vc_valid_datain;
input [vc_size-1:0] vc_valid_ld;
//from control to vc_drity array
input vc_dirty_read, vc_dirty_datain;
input [vc_size-1:0] vc_dirty_ld;
//from control to vc_plru_register
input vc_plru_read, vc_plru_ld;
input [num_idx_bits-1:0] vc_plru_datain;
//to control logic
output logic [vc_size-1:0] vc_dirty_dataout;
output logic [vc_size-1:0]  vc_valid_dataout;
output logic [num_idx_bits-1:0] vc_plru_dataout;
/**********************************************************************************************/
vc_metadata_array valid_array(.*, .read(vc_valid_read), .load(vc_valid_ld), .datain(vc_valid_datain), .dataout(vc_valid_dataout));
vc_metadata_array dirty_array(.*, .read(vc_dirty_read), .load(vc_dirty_ld), .datain(vc_dirty_datain), .dataout(vc_dirty_dataout));
vc_plru_array plru_array(.*, .read(vc_plru_read), .load(vc_plru_ld), .datain(vc_plru_datain), .dataout(vc_plru_dataout));

/**********************************************************************************************/
endmodule : vc_metadata_store
