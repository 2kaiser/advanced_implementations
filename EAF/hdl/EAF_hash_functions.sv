//Notes
//xor hashing functions from the paper "Efficient Hardware Hashing Functions for High Performance Computers" by M.V. Ram. E Fu, and E. Bah.


/*
Here I will detail the hashing algorithm.  It involves one hash function H(mem_adddress) and several modulus operations.
These results are the index to severa bit arrays that are 2 to the power of the first 7 consecutive primes - i.e. 7 bit arrays of sizes 2^1, 2^2, 2^3, 2^5, 2^7, 2^11, and 2^13

For the number of hash functions (k) and the total bits needed (m) was based off an acceptable false positive rate (p) of .01 and expected 16 elements (n) to be inserted (size of the L1 cache).

Using those variables the formulas are:
m = -nln(p)
k = (m/n) * ln(2)
which comes out to about 156 = m and k = 7

The hash functions do ONE HASHING BLOOM FILTER
which involves doing a combination of multiplications by constants, xors, and logical right shifts.
*/
module EAF_hash_functions #(
parameter addr_length = 32,
parameter one_zero_const = 1431655765, //alternanting 1's and 0's
//parameter inv_golden_ratio_const = 2654435769, //inverse of the golden ration
parameter inv_golden_ratio_const = 2654435769, //inverse of the golden ration
parameter first_prime_pow_2 = 2,
parameter second_prime_pow_2 = 4,
parameter third_prime_pow_2 = 8,
parameter fourth_prime_pow_2 = 32,
parameter fifth_prime_pow_2 = 128,
parameter sixth_prime_pow_2 = 2048,
parameter seventh_prime_pow_2 = 8192

)
(
//global
clk, rst,insert_resp_i,test_resp_i,
//from cache
//addresses from cache to insert and test to see if it exists in bloom filter
mem_addr, first_prime_index, second_prime_index, third_prime_index,fourth_prime_index, fifth_prime_index,sixth_prime_index,seventh_prime_index
);
/******************************************************************************************************************8*/
//global
input clk, rst;
//from cache
//addresses from cache to insert and test to see if it exists in bloom filter
input [addr_length-1:0] mem_addr; //asserted when you want to insert a line
input insert_resp_i, test_resp_i; //asserted when you want to test to see if a line is in the bloom filter
logic [addr_length-1:0] inter_val_one,inter_val_two,first_prime_index_int, second_prime_index_int, third_prime_index_int, fourth_prime_index_int, fifth_prime_index_int, sixth_prime_index_int,seventh_prime_index_int; //asserted when you want to insert a line
/******************************************************************************************************************8*/
//assignments
//internal sigs
//
output first_prime_index;
output [1:0] second_prime_index;
output [2:0] third_prime_index;
output [4:0] fourth_prime_index;
output [6:0] fifth_prime_index;
output [10:0] sixth_prime_index;
output [12:0] seventh_prime_index;

//just do bit selection for index bits
assign first_prime_index = inter_val_two[0]; //then I do bit selection and a modulus operation for hte index
assign second_prime_index = inter_val_two[1:0];
assign third_prime_index = inter_val_two[2:0];
assign fourth_prime_index = inter_val_two[4:0];
assign fifth_prime_index = inter_val_two[6:0];
assign sixth_prime_index =inter_val_two[10:0];
assign seventh_prime_index = inter_val_two[12:0];
/******************************************************************************************************************8*/
always_comb begin
  inter_val_one = (mem_addr ^ {16'b0000000000000000,mem_addr[31:16]}) * one_zero_const;
  inter_val_two = ((inter_val_one ^ {16'b0000000000000000,inter_val_one[31:16]}) * inv_golden_ratio_const)>>16;
end
endmodule : EAF_hash_functions
