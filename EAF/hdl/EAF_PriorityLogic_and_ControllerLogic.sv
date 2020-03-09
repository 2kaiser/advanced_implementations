//Notes
//xor hashing functions from the paper "Efficient Hardware Hashing Functions for High Performance Computers" by M.V. Ram. E Fu, and E. Bah.


module EAF_PriorityLogic_and_ControlLogic #(
  parameter first_prime_pow_2 = 2,
  parameter second_prime_pow_2 = 4,
  parameter third_prime_pow_2 = 8,
  parameter fourth_prime_pow_2 = 32,
  parameter fifth_prime_pow_2 = 128,
  parameter sixth_prime_pow_2 = 2048,
  parameter seventh_prime_pow_2 = 4096,
parameter num_of_BF_entries = 4096,
parameter addr_length = 32,
parameter num_of_index_bits = $clog2(num_of_BF_entries),
parameter max_num_of_entries = 16, //size of cache
parameter num_of_counter_bits = $clog2(max_num_of_entries)
)
(
//global
clk, rst,
//to cache
priority_level, addr_exists,//asserted if it exists in bloom filter so it should be placed in the MRU position in the cache
//from hash logic
first_prime_index,second_prime_index,third_prime_index,fourth_prime_index,fifth_prime_index,sixth_prime_index,seventh_prime_index,
//addresses from cache to insert and test to see if it exists in bloom filter
mem_addr, insert_resp_i, //asserted when you want to insert a line
test_resp_i, resp_o //asserted when you want to test to see if a line is in the bloom filter
);

//global
input clk, rst;
//to cache
output logic resp_o,priority_level,addr_exists;
//from cache
//addresses from cache to insert and test to see if it exists in bloom filter
input [addr_length-1:0] mem_addr;
input insert_resp_i, test_resp_i;
input first_prime_index;
input [1:0] second_prime_index;
input [2:0] third_prime_index;
input [4:0] fourth_prime_index;
input [6:0] fifth_prime_index;
input [10:0] sixth_prime_index;
input [12:0] seventh_prime_index;
enum int unsigned {
    /* List of states */
    idle, insert_line, RESET,test_line
} state, next_states;
//a counter
logic [num_of_counter_bits-1:0] EAF_address_counter;
logic overflow;
//reset on rst or full EAF
//need bit arrays for the bloom filter
//we have bit arrays of size 2^1, 2^2, 2^3, 2^5, 2^7, and 2^11
logic  first_BF_array [first_prime_pow_2-1:0];
logic  second_BF_array [second_prime_pow_2-1:0];
logic  third_BF_array [third_prime_pow_2-1:0];
logic  fourth_BF_array [fourth_prime_pow_2-1:0];
logic  fifth_BF_array [fifth_prime_pow_2-1:0];
logic  sixth_BF_array [sixth_prime_pow_2-1:0];
logic  seventh_BF_array [seventh_prime_pow_2+seventh_prime_pow_2-1:0];
//helper functions
function void set_default();
  resp_o = 1'b0;
  priority_level = '0;
  addr_exists = '0;

endfunction
//peripheral logic to determine the priority given the policy0
//we assume for now that we place the line in LRU if it is not in the set
//otherwise we place it in the MRU position
function void RST();
  //CLEAR THE ARRAYS

  for(int i = 0; i <first_prime_pow_2; i++) first_BF_array[i] = '0;
  for(int i = 0; i <second_prime_pow_2; i++) second_BF_array[i] = '0;
  for(int i = 0; i <third_prime_pow_2; i++) third_BF_array[i] = '0;
  for(int i = 0; i <fourth_prime_pow_2; i++) fourth_BF_array[i] = '0;
  for(int i = 0; i <fifth_prime_pow_2; i++) fifth_BF_array[i] = '0;
  for(int i = 0; i <sixth_prime_pow_2; i++) sixth_BF_array[i] = '0;
  for(int i = 0; i <seventh_prime_pow_2; i++) seventh_BF_array[i] = '0;
  for(int i = seventh_prime_pow_2; i <seventh_prime_pow_2+seventh_prime_pow_2; i++) seventh_BF_array[i] = '0;
  set_default();
endfunction

function void IDLE();
  set_default();
  if(overflow) RST();
endfunction
function void TESTLine();
  //you want to check all of the bit arrays at the index calculated byt he hashing algorithm
  set_default();
  if((first_BF_array[first_prime_index] == 1'b1) && (second_BF_array[second_prime_index] == 1'b1) && (third_BF_array[third_prime_index] == 1'b1) && (fourth_BF_array[fourth_prime_index] == 1'b1) && (fifth_BF_array[fifth_prime_index] == 1'b1) && (sixth_BF_array[sixth_prime_index] == 1'b1) && (seventh_BF_array[seventh_prime_index] == 1'b1)) begin
    addr_exists = 1'b1;
    priority_level = 1'b1;
  end
endfunction
function void INSERTLine();
  set_default();

  first_BF_array[first_prime_index] = 1'b1;
  second_BF_array[second_prime_index] = 1'b1;
  third_BF_array[third_prime_index] = 1'b1;
  fourth_BF_array[fourth_prime_index] = 1'b1;
  fifth_BF_array[fifth_prime_index] = 1'b1;
  sixth_BF_array[sixth_prime_index] = 1'b1;
  seventh_BF_array[seventh_prime_index] = 1'b1;
endfunction
/************************************************************************************************************************/
always_comb
begin : state_logic
     case(state)
       RESET: RST();
       idle: IDLE();
       insert_line: INSERTLine();
       test_line: TESTLine();
     endcase
end
always_comb
begin : next_state_logic
     case(state)
       RESET: next_states = idle;
       idle: begin
         if(test_resp_i) next_states = test_line;
         else if(insert_resp_i) next_states = insert_line;
         else next_states = idle;
       end
       insert_line: next_states = idle;
       test_line: next_states = idle;
       endcase
end
always_ff @(posedge clk)
begin: state_assignment
    /* Assignment of next state on clock edge */
    if(rst) state <= RESET;
    else	state <= next_states;
end
always @ (posedge clk)
  begin: counter_update
    if (rst) begin
      EAF_address_counter <= 8'b0;
      overflow <= 1'b0;
    end

    else if (insert_resp_i) begin
      EAF_address_counter <= EAF_address_counter+1;
    end
    if (EAF_address_counter == 4'b1111) begin
      overflow <=1'b1;
    end
  end
endmodule : EAF_PriorityLogic_and_ControlLogic
