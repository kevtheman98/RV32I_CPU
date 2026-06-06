// Allows bundling of wires to go through cb & allows use of <= in tb because of cb
interface data_mem_if (input logic clk);
    logic WE;
    logic [31:0] address;
    logic [31:0] RD, WD;

    // Clocking prevents many NBA & Active race condtions
    clocking cb @(posedge clk);
        default input #1step output #0; // input 1 step before clock, output on nba region
        input RD;
        output address, WE, WD;
    endclocking
endinterface