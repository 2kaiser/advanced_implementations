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
  parameter first_prime_pow_2 = 2,
  parameter second_prime_pow_2 = 4,
  parameter third_prime_pow_2 = 8,
  parameter fourth_prime_pow_2 = 32,
  parameter fifth_prime_pow_2 = 128,
  parameter sixth_prime_pow_2 = 2048,
  parameter seventh_prime_pow_2 = 8192,
parameter num_of_BF_entries = 4096,
parameter addr_length = 32,
parameter num_of_index_bits = $clog2(num_of_BF_entries),
parameter max_num_of_entries = 8, //size of cache
parameter num_of_counter_bits = $clog2(max_num_of_entries)
)
(
//global
clk, rst,
//to cache
priority_level, //asserted if it exists in bloom filter so it should be placed in the MRU position in the cache
//from cache
//addresses from cache to insert and test to see if it exists in bloom filter
mem_addr, insert_resp_i, //asserted when you want to insert a line
test_resp_i //asserted when you want to test to see if a line is in the bloom filter
);
/******************************************************************************************************************8*/
//global
iniput clk, rst;
//from cache
//addresses from cache to insert and test to see if it exists in bloom filter
input [31:0] mem_addr; //asserted when you want to insert a line
input insert_resp_i, test_resp_i; //asserted when you want to test to see if a line is in the bloom filter
logic [31:0] inter_val_one,inter_val_two; //asserted when you want to insert a line
logic one_zero_const = 8'h55555555; //alternating 0's and 1's
logic inv_golden_ratio_const = 8'h9e3779b9; //the inverse of teh golden ratio
/******************************************************************************************************************8*/
//internal sigs
output first_prime_index;
output [1:0] second_prime_index;
output [2:0] third_prime_index;
output [4:0] fourth_prime_index;
output [6:0] fifth_prime_index;
output [10:0] sixth_prime_index;
output [12:0] seventh_prime_index;
/******************************************************************************************************************8*/
always_comb begin
  inter_val_one = (mem_addr ^ {16'b0000000000000000,mem_addr[31:16]}) * one_zero_const;
  inter_val_two = (inter_val_one ^ {16'b0000000000000000,inter_val_one[31:16]}) * inv_golden_ratio_const;
  first_prime_index = inter_val_two % first_prime_pow_2;
  second_prime_index = inter_val_two % second_prime_pow_2;
  third_prime_index = inter_val_two % third_prime_pow_2;
  fourth_prime_index = inter_val_two % fourth_prime_pow_2;
  fifth_prime_index = inter_val_two % fifth_prime_pow_2;
  sixth_prime_index = inter_val_two % sixth_prime_pow_2;
  seventh_prime_index = inter_val_two % seventh_prime_pow_2;
end
endmodule : EAF_hash_functions
