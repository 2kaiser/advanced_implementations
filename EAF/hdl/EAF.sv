///Notes

module EAF #(
parameter addr_length = 32,
parameter max_num_of_entries = 16, //size of cache
parameter num_of_counter_bits = $clog2(max_num_of_entries)
)
(
//INS
//global signals
clk, rst,
//SIGNALS from cache
mem_addr, //address from cache to insert into BF or test to see if it exists in BF
insert_resp_i, //asserted when you want to insert a line
test_resp_i, //asserted when you want to test to see if a line is in the bloom filter

//OUTS
//to cache
priority_level, //asserted if the line should be put in MRU otherwise 0 indicates LRU position
addr_exists,//asserted if it exists in bloom filter
resp_o //asserted when done with an operation
);
/******************************************************************************************************************8*/
//global
input clk, rst;
//to cache
output logic priority_level, addr_exists, resp_o;
//from cache
//addresses from cache to insert into the BF or tested to see if it exists in BF
input [addr_length-1:0] mem_addr;
input insert_resp_i, test_resp_i;
/******************************************************************************************************************8*/
//internal sigs
logic first_prime_index;
logic [1:0] second_prime_index;
logic [2:0] third_prime_index;
logic [4:0] fourth_prime_index;
logic [6:0] fifth_prime_index;
logic [10:0] sixth_prime_index;
logic [12:0] seventh_prime_index;
/******************************************************************************************************************8*/
//this determines the priority if you test a mem_adddress
//also updates the BF arrays on insert
//handles reset when BF arrays are full
EAF_PriorityLogic_and_ControlLogic EAF_PL_CL(.*);
//hash functions that access the BF arrays
EAF_hash_functions EAF_HF(.*);
endmodule : EAF
