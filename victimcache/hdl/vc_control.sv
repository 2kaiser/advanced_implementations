module vc_control #(
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
  parameter num_bits_for_vc = $clog2(size_of_vc),
  parameter num_of_plru_bits = $clog2(size_of_vc),
  parameter num_mux_sel_bits = 4

)
(
//INS
//global sigs
clk, rst, mem_address,mem_wdata, vc_read,vc_write,is_mem_wdata_dirty,vc_vcmem_rdata256,
//from STORES
vc_valid_dataout, vc_dirty_dataout,
vc_plru_dataout,

//OUTS
//from stores
vc_tag_store_datain, vc_tag_store_ld_mask,vc_tag_write,
//data store signals
vc_datastore_datain, vc_datastore_ld_mask,
//meta signals
vc_valid_ld, vc_dirty_ld, vc_plru_read, vc_plru_ld, vc_valid_datain, vc_dirty_datain, vc_plru_datain,
//read signals to arrays
vc_tag_cmp, vc_datastore_read, vc_valid_read, vc_dirty_read, rdata_exists,vc_datamux_sel
);
/************************************************************************************************************************/
input clk, rst, vc_read, vc_write,is_mem_wdata_dirty;
input [rv32word-1:0] mem_address;
input [s_line-1:0] mem_wdata,vc_vcmem_rdata256;
input [num_mux_sel_bits-1:0] vc_datamux_sel;
//tag signals
output logic [tag_width-1:0] vc_tag_store_datain;
output logic [size_of_vc-1:0] vc_tag_store_ld_mask;
//data store signals
output logic [s_line-1:0] vc_datastore_datain;
output logic [size_of_vc-1:0] vc_datastore_ld_mask;
//meta signals
output logic vc_plru_read,vc_plru_ld;
output logic [size_of_vc-1:0] vc_valid_ld, vc_dirty_ld;
output logic vc_valid_datain, vc_dirty_datain;
output logic [num_of_plru_bits-1:0] vc_plru_datain;
//read signals to arrays
output logic vc_tag_cmp, vc_datastore_read, vc_valid_read, vc_dirty_read,vc_tag_write;
//to VCC
input [size_of_vc-1:0] vc_valid_dataout, vc_dirty_dataout;
input [num_of_plru_bits-1:0] vc_plru_dataout;
output logic rdata_exists;
enum int unsigned {
    /* List of states */
    idle, wr_line, RESET,rd_line
} state, next_states;
/************************************************************************************************************************/
//internal sig declaration
logic [num_bits_for_vc-1:0] acc_idx;
logic [num_bits_for_vc-1:0] lru_idx;
logic acc_en;
 logic [size_of_vc-1:0] vc_valid_mask;
 logic [num_mux_sel_bits-1:0] shift_amt;


/************************************************************************************************************************/
//modules plru and stores update logic
//vc_tag_data_cntrl VC_TD_C(*.); //prob dont need this
vc_plru_logic PLRUC(.*, .lru_idx(vc_plru_datain));

/************************************************************************************************************************/
//tag logic
assign vc_tag_store_datain = mem_address[31:8];
assign vc_tag_store_ld_mask = 8'b00000001 << shift_amt;
assign  vc_datastore_ld_mask = vc_tag_store_ld_mask;
assign vc_valid_mask = vc_datastore_ld_mask;
assign vc_datastore_datain = mem_wdata;
/************************************************************************************************************************/
//HELPER FUNCTIONS
function void set_defaults();
  acc_idx = 1'b0; //this is the MRU accessed idx of the VC
  acc_en = 1'b0;
  vc_plru_ld = 1'b0; //DONT LOAD INTO ANY ARRAYS
  vc_valid_ld = 1'b0;
  vc_dirty_ld = 1'b0;
  vc_valid_datain= 1'b0;
  vc_dirty_datain= 1'b0;
  vc_plru_read = 1'b0; //DONT READ ANY OF THE ARRAYS
  vc_tag_cmp = 1'b0;
  vc_datastore_read = 1'b0;
   vc_valid_read = 1'b0;
   vc_dirty_read = 1'b0;
   vc_tag_write = 1'b0;
  //to VCC
  rdata_exists = 1'b0; //nothing to compare
endfunction
/************************************************************************************************************************/
//MAIN FUNCTION CALLS
function void RST();
  set_defaults();
  //load in 0 plru and reset plru logic
endfunction
//MAIN FUNCTION CALLS
function void IDLE();
  set_defaults();
  if(vc_write || vc_read) begin
      vc_plru_read = 1'b1;  //we need to check plru on either write or read
      vc_plru_read = '1; //read for index so it's ready on next cycle during write/cmp(read)
      //check valid array
      vc_datastore_read = 1'b1;

    end
  if(vc_read)  begin
      vc_tag_cmp = 1'b1;  //we also need to check tag store on read
      vc_valid_read = '1;
    end
  //otherwise don't do anything
endfunction
function void WRLine();
  //load in the mem_wdata line to vc_plru_datain index and update the same index on all
  //other arrays set rdata_exists when vc_datastore_dataout is the same as the input mem_wdata
  set_defaults();
  acc_idx = vc_plru_dataout; //this is the MRU accessed idx of the VC
  acc_en = 1'b1;
  vc_plru_ld = 1'b1; //load new plru index
  vc_valid_ld = 1'b1;
  if(is_mem_wdata_dirty) vc_dirty_ld = 1'b1;
  else vc_dirty_ld = 1'b0;
  vc_valid_datain= 1'b1;
  if(is_mem_wdata_dirty) vc_dirty_datain= 1'b1;
  else vc_dirty_datain= 1'b0;
  vc_tag_cmp = 1'b0;
  vc_datastore_read = 1'b1;
   vc_valid_read = 1'b0;
   vc_dirty_read = 1'b0;
   vc_tag_write = 1'b1; //load in new tag
  //to VCC
  shift_amt = {1'b0,vc_plru_dataout};//we want to shift the masks by how much the current plru

  if(mem_wdata == vc_vcmem_rdata256) rdata_exists = 1'b1; //we indicate we are done
  else rdata_exists = '0;
endfunction
function void RDLine();
  //if the tag matches assert rdata_exists for a cycle
  set_defaults();
  acc_idx = vc_plru_dataout; //this is the MRU accessed idx of the VC
  acc_en = 1'b1;
  vc_plru_ld = 1'b1; //load new plru index
  vc_valid_ld = 1'b1;
  if(is_mem_wdata_dirty) vc_dirty_ld = 1'b1;
  else vc_dirty_ld = 1'b0;
  vc_valid_datain= 1'b1;
  if(is_mem_wdata_dirty) vc_dirty_datain= 1'b1;
  else vc_dirty_datain= 1'b0;
  vc_tag_cmp = 1'b1;
  vc_datastore_read = 1'b1;
   vc_valid_read = 1'b1;
   vc_dirty_read = 1'b0;
   vc_tag_write = 1'b0; //no need to load in tag
  //to VCC
  shift_amt = vc_datamux_sel;//otherwise we want to shift by how much we matched by -1 since the first index is all the way to the right
  if((vc_datamux_sel != 4'b1000) && (vc_valid_dataout == vc_valid_mask)) rdata_exists = 1'b1; //set when it exists and is valid
  else rdata_exists = 1'b0;
endfunction
/************************************************************************************************************************/
always_comb
begin : state_logic
     case(state)
       RESET: RST();
       idle: IDLE();
       wr_line: WRLine();
       rd_line: RDLine();
     endcase
end
always_comb
begin : next_state_logic
     case(state)
       RESET: next_states = idle;
       idle: begin
         if(vc_read) next_states = rd_line;
         else if(vc_write) next_states = wr_line;
         else next_states = idle;
       end
       wr_line: begin
         if(vc_vcmem_rdata256 == mem_wdata)         next_states = idle;
         else next_states = wr_line;
       end
       rd_line: next_states = idle;
     endcase
end
always_ff @(posedge clk)
begin: state_assignment
    /* Assignment of next state on clock edge */
    if(rst) state <= RESET;
    else	state <= next_states;
end
endmodule : vc_control
