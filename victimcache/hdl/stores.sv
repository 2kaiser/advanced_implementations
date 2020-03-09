module stores #(
parameter s_offset = 5,
  parameter s_index  = 3,
  parameter s_tag    = 32 - s_offset - s_index,
  parameter s_mask   = 2**s_offset,
  parameter s_line   = 8*s_mask,
  parameter num_sets = 2**s_index,
  parameter rv32word = 32,
  parameter burst_size = 64,
  parameter tag_width = 24,
  parameter size_of_vc = 8,
  parameter num_mux_sel_bits = 4,
  parameter num_of_plru_bits = $clog2(size_of_vc)
)
(
//global sigs
clk, rst,
//from VCC
  //tag signals
vc_tag_store_datain, vc_tag_store_ld_mask,vc_tag_write,
  //data store signals
vc_datastore_datain, vc_datastore_ld_mask,
  //meta signals
vc_valid_ld, vc_dirty_ld, vc_plru_read, vc_plru_ld,vc_valid_datain, vc_dirty_datain, vc_plru_datain,
  //read signals to arrays
vc_tag_cmp, vc_datastore_read, vc_valid_read, vc_dirty_read,

//to VCC
vc_valid_dataout, vc_dirty_dataout,
vc_plru_dataout,
//to L1 cache
vc_vcmem_rdata256

);
/************************************************************************************************************************/
input clk, rst;
//tag signals
input [tag_width-1:0] vc_tag_store_datain;
input [size_of_vc-1:0] vc_tag_store_ld_mask;
//data store signals
input [s_line-1:0] vc_datastore_datain;
input [size_of_vc-1:0] vc_datastore_ld_mask;
//meta signals
input [size_of_vc-1:0] vc_valid_ld, vc_dirty_ld;
input vc_valid_datain, vc_dirty_datain;
input [num_of_plru_bits-1:0] vc_plru_datain;
//read signals to arrays
input vc_tag_cmp, vc_datastore_read,vc_plru_ld, vc_valid_read, vc_dirty_read, vc_plru_read,vc_tag_write;
//to VCC
output logic [size_of_vc-1:0] vc_valid_dataout, vc_dirty_dataout;
output logic [num_of_plru_bits-1:0] vc_plru_dataout;
//to L1 cache
output logic [s_line-1:0] vc_vcmem_rdata256;
/************************************************************************************************************************/
/************************************************************************************************************************/
logic [num_mux_sel_bits-1:0] vc_datamux_sel;
//internal sig declaration
/************************************************************************************************************************/
logic [s_line-1:0] cacheline8, cacheline1, cacheline2, cacheline3, cacheline4, cacheline5, cacheline6, cacheline7;
/************************************************************************************************************************/
//modules tag, data, and meta stores

vc_data_store VC_DS(.*);
vc_metadata_store VC_MDS(.*);
vc_tag_store VC_TS(.*);

//add mux here


always_comb begin : MUXES
  unique case (vc_datamux_sel)
      4'b0000: vc_vcmem_rdata256 = cacheline1;
      4'b0001: vc_vcmem_rdata256 = cacheline1;
      4'b0010: vc_vcmem_rdata256 = cacheline1;
      4'b0011: vc_vcmem_rdata256 = cacheline1;
      4'b0100: vc_vcmem_rdata256 = cacheline1;
      4'b0101: vc_vcmem_rdata256 = cacheline1;
      4'b0110: vc_vcmem_rdata256 = cacheline1;
      4'b0111: vc_vcmem_rdata256 = cacheline1;
      default: vc_vcmem_rdata256 = cacheline1;

    //  default: `BAD_MUX_SEL;
  endcase

end

endmodule : stores
