// Allows bundling of wires to go through cb & allows use of <= in tb because of cb
interface reg_file_if (input logic clk);
    logic reset, WE3;
    logic [4:0] A1, A2, A3;
    logic [31:0] WD3, RD1, RD2;

    // Clocking prevents many NBA & Active race condtions
    clocking cb @(posedge clk);
        default input #1step output #0; // input 1step before clock, output on nba region
        input RD1, RD2;
        output reset, WE3, A1, A2, A3, WD3;
    endclocking
endinterface