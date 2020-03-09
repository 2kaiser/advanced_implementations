//notes
module victimcache #(
  parameter s_offset = 5,
  parameter s_index  = 3,
  parameter s_tag    = 32 - s_offset - s_index,
  parameter s_mask   = 2**s_offset,
  parameter s_line   = 8*s_mask,
  parameter num_sets = 2**s_index,
  parameter rv32word_length = 32,
  parameter burst_size = 64,
  parameter size_of_vc = 8,
  parameter tag_width = 24,
  parameter num_of_plru_bits = $clog2(size_of_vc),
  parameter num_read_bits = 1,
  parameter num_mux_sel_bits = 4
)
(
//INS
clk, rst,
//from cpu
mem_address,
//from L1 control
vc_write,vc_read, //asserted on miss (vc_read) for a line or eviction (vc_write) by L1
//data from L1 cache and you have to indicate with is_mem_wdata_dirty if the line is dirty
mem_wdata, is_mem_wdata_dirty,

//OUTS
//to cache
vc_vcmem_rdata256, //output cache line data
rdata_exists //asserted when the write or read operation is done
);
/************************************************************************************************************************/
//I/O declarations
//INS
input clk, rst;
//from cpu
input [rv32word_length-1:0] mem_address;
//from L1 control
input vc_write,vc_read,is_mem_wdata_dirty; //asserted to write to the cache and read from it for a line if it exists
//from L1 cache
input [s_line-1:0] mem_wdata;

//OUTS
//to cache
output logic [s_line-1:0] vc_vcmem_rdata256;
output logic rdata_exists;
/************************************************************************************************************************/
//internal sig declaration
/*************************signals from VCC to STORES***********************************/
//tag signals
logic [tag_width-1:0] vc_tag_store_datain;
logic [size_of_vc-1:0] vc_tag_store_ld_mask;
//data store signals
logic [s_line-1:0] vc_datastore_datain;
logic [size_of_vc-1:0] vc_datastore_ld_mask;
//meta signals
logic [size_of_vc-1:0] vc_valid_ld, vc_dirty_ld;
logic vc_plru_read,vc_plru_ld;
logic vc_valid_datain, vc_dirty_datain;
logic [num_of_plru_bits-1:0] vc_plru_datain;
logic [num_mux_sel_bits-1:0] vc_datamux_sel;

//read signals to arrays
logic vc_tag_cmp, vc_datastore_read, vc_valid_read, vc_dirty_read,vc_tag_write;
/*************************signals from STORES to VCC***********************************/
logic [size_of_vc-1:0] vc_valid_dataout, vc_dirty_dataout;
logic [num_of_plru_bits-1:0] vc_plru_dataout;
/************************************************************************************************************************/
// data, meta, and tag stores
stores STORES(.*);
//victim cache control for data, meta, and tag stores
//also processes pseudo LRU logic
vc_control VCC(.*);
endmodule : victimcache
