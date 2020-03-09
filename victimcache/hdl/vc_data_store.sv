module vc_data_store #(
parameter s_offset = 5,
  parameter s_index  = 3,
  parameter s_tag    = 32 - s_offset - s_index,
  parameter s_mask   = 2**s_offset,
  parameter s_line   = 8*s_mask,
  parameter num_sets = 2**s_index,
  parameter rv32word = 32,
  parameter burst_size = 64,
  parameter size_of_vc = 8
)
(
//glb sigs
clk, rst,
//from vc_control
vc_datastore_read, vc_datastore_ld_mask,
//from L1 datapath (the line to be swapped)
vc_datastore_datain,
//all of the outputs to mux
cacheline8, cacheline1, cacheline2, cacheline3, cacheline4, cacheline5, cacheline6, cacheline7
);
//INIT SIGS /////////////////////////////////////////////////////////////
//glb sigs
input clk, rst;
//from vc_control
input vc_datastore_read;
input [size_of_vc-1:0] vc_datastore_ld_mask;
//from L1 datapath (the line to be swapped)
input [s_line-1:0] vc_datastore_datain;
//all of the outputs to mux
output logic [s_line-1:0] cacheline8, cacheline1, cacheline2, cacheline3, cacheline4, cacheline5, cacheline6, cacheline7;
/***********************************************************************/
vc_data_array data_array1(
.*, .read(vc_datastore_read), .dataout(cacheline1), .write_en(vc_datastore_ld_mask[0]), .datain(vc_datastore_datain[0])
);
vc_data_array data_array2(
.*, .dataout(cacheline2), .read(vc_datastore_read), .write_en(vc_datastore_ld_mask[1]), .datain(vc_datastore_datain[1])
);
vc_data_array data_array3(
.*, .dataout(cacheline3), .read(vc_datastore_read), .write_en(vc_datastore_ld_mask[2]), .datain(vc_datastore_datain[2])
);
vc_data_array data_array4(
.*, .dataout(cacheline4), .read(vc_datastore_read), .write_en(vc_datastore_ld_mask[3]), .datain(vc_datastore_datain[3])
);
vc_data_array data_array5(
.*, .read(vc_datastore_read), .dataout(cacheline5), .write_en(vc_datastore_ld_mask[4]), .datain(vc_datastore_datain[4])
);
vc_data_array data_array6(
.*, .dataout(cacheline6), .read(vc_datastore_read), .write_en(vc_datastore_ld_mask[5]), .datain(vc_datastore_datain[5])
);
vc_data_array data_array7(
.*, .dataout(cacheline7), .read(vc_datastore_read), .write_en(vc_datastore_ld_mask[6]), .datain(vc_datastore_datain[6])
);
vc_data_array data_array8(
.*, .dataout(cacheline8), .read(vc_datastore_read), .write_en(vc_datastore_ld_mask[7]), .datain(vc_datastore_datain[7])
);
/***********************************************************************/

endmodule : vc_data_store
