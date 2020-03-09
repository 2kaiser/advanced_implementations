module vc_plru_logic (
  //global sigs
    input                   clk,
    input                   rst,
//from control
    input                   acc_en,     // access indication
//from vc_plru_array
    input [2:0]             acc_idx,    // index to accessed entry
//to select data/tag/meta data lines for eviction and changes
    output logic [2:0]      lru_idx     // index to LRU entry
);

    // tree node
    logic h0, h1, h2, h3, h4, h5, h6;

    always_ff @(posedge clk)
        if (rst)
            h0 <= '0;
        else if (acc_en)
            h0 <= ~h0;                  // always flip h0 if there's an access
    always_ff @(posedge clk )
        if (rst)
            h1 <= '0;
        else if (acc_en & ~acc_idx[2])
            h1 <= ~h1;                  // flip h1 if acc_if~dx == 0/1/2/3

    always_ff @(posedge clk)
        if (rst)
            h2 <= '0;
        else if (acc_en & acc_idx[2])
            h2 <= ~h2;                  // flip h2 if acc_idx == 4/5/6/7

    always_ff @(posedge clk)
        if (rst)
            h3 <= '0;
        else if (acc_en & (acc_idx[2:1] == 2'b00))
            h3 <= ~h3;                  // flip h3 if acc_idx == 0/1

    always_ff @(posedge clk)
        if (rst)
            h4 <= '0;
        else if (acc_en & (acc_idx[2:1] == 2'b01))
            h4 <= ~h4;                  // flip h4 if acc_idx == 2/3

    always_ff @(posedge clk)
        if (rst)
            h5 <= '0;
        else if (acc_en & (acc_idx[2:1] == 2'b10))
            h5 <= ~h5;                  // flip h5 if acc_idx == 4/5

    always_ff @(posedge clk)
        if (rst)
            h6 <= '0;
        else if (acc_en & (acc_idx[2:1] == 2'b11))
            h6 <= ~h6;                  // flip h6 if acc_idx == 6/7

    // lru_idx assignment
    assign lru_idx[2] = h0;
    assign lru_idx[1] = ~h0 & h1 | h0 & h2;
    assign lru_idx[0] = (~h0 & ~h1 & ~h3) | (~h0 & h1 & ~h4) | (h0 & ~h2 & ~h5) | (~h0 & h2 & ~h6);


endmodule: vc_plru_logic
