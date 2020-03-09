module vc_tag_store #(
    parameter tag_width = 24,
    parameter vc_size = 8,
    parameter num_mux_sel_bits = 4
)
(
    //global sigs
    clk, rst,
    //from vc controlvc_tag_write
   vc_tag_store_ld_mask, vc_tag_cmp, vc_tag_write,
    //new tag
    vc_tag_store_datain, //tag to be inserted or compared
    //output select to vc_data_mux
    vc_datamux_sel
);
/**********************************************************************************************/
//global sigs
input clk, rst, vc_tag_cmp,vc_tag_write;
//from vc control
input [vc_size-1:0] vc_tag_store_ld_mask ;
//new tag from control
input [tag_width-1:0] vc_tag_store_datain;
//output tags to be compared
output logic [num_mux_sel_bits-1:0] vc_datamux_sel;
/**********************************************************************************************/
logic [tag_width-1:0] tag_array [vc_size-1:0];
logic [tag_width-1:0] data [vc_size-1:0] /* synthesis ramstyle = "logic" */;
logic [num_mux_sel_bits-1:0] _vc_datamux_sel;
assign vc_datamux_sel = _vc_datamux_sel;
/**********************************************************************************************/
always_ff @(posedge clk)
begin
    if (rst) begin
        for (int i = 0; i < vc_size; ++i)  data[i] <= '0;
    end
    else begin
      //  if(load)  data[windex] <= datain;
        //todo should i have another write signal here?
        //should I have a read signal too?
        if(vc_tag_write) for (int i = 0; i < vc_size; ++i) if(vc_tag_store_ld_mask[i]) data[i] <= vc_tag_store_datain;
    end
end
/**********************************************************************************************/
//do comparisons and make select logic which selects a cacheline from vc_data_store
always_comb begin
  _vc_datamux_sel = 4'b1000; //dont care at first and will change if we are comparing tags/ prevent inferred latches
  if(vc_tag_cmp) begin
    for (int i = 0; i < vc_size; ++i) if(data[i] == vc_tag_store_datain) _vc_datamux_sel = i;
  end
end
endmodule : vc_tag_store
