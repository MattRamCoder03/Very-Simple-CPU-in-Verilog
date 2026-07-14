module CPU(input logic clk, input logic rst);

  reg[1:0] IR;
  reg[5:0] PC, AR;
  reg[7:0] DR, AC;
  reg[7:0] memory [0:3];

  wire [7:0] shared_bus, MEM_bus, DR_bus;
  wire[5:0] PC_bus,
  
endmodule
