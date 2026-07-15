module CPU(input logic clk, input logic start, input logic rst);

  reg[1:0] IR;
  reg[5:0] PC, AR;
  reg[7:0] DR, AC;
  reg[7:0] memory [0:3];

  wire[1:0] next_IR;
  wire[5:0] next_PC, next_AR;
  wire[7:0] next_DR, next_AC;

reg [3:0] state, next_state;
parameter IDLE=4'd0, FETCH1=4'd1, FETCH2=4'd2, FETCH3=4'd3, ADD1=4'd4, ADD2=4'd5;
// AND1=4'd6, AND2=4'd7, JMP=4'd8, INC=4'd9;

  //always block for state transitions, ctrl signals are input 

  //always block for sequential and reset

//reset logic
  always_ff(posedge clk) begin 
  if (rst) begin 
        state<=IDLE;
      end 
  else begin 
        state<=next_state;
      end 
    end 

//combinational logic for next state
always_comb begin 
  case(state) 
    IDLE: begin 
    if (start) begin 
      next_state = FETCH1;
        end 
    else begin 
        next_state = IDLE;
    end 
    end 
    FETCH1: begin 
      next_state = FETCH2;
    end 
    FETCH2: begin 
      next_state = FETCH3;
    end
    FETCH3: begin 
      next_state = ADD1;
    end
    ADD1: begin 
      next_state = ADD2;
    end
    ADD2: begin 
      next_state = IDLE;
    end 
    default: next_state = IDLE;
  endcase
end 

//combinational logic for next outputs 
always_comb begin 
  case(state) 
    IDLE: begin 
      next_AR = 6'd0;
      next_DR = 8'd0;
      next_PC = 6'd0;
      next_IR = 2'd0;
      next_AC = 8'd0;
    end 
    FETCH1: begin 
      next_AR = 6'd0;
      next_DR = 8'd0;
      next_PC = 6'd0;
      next_IR = 2'd0;
      next_AC = 8'd0;
    end 
    FETCH2: begin
      next_AR = 6'd0;
      next_DR = 8'd0;
      next_PC = 6'd0;
      next_IR = 2'd0;
      next_AC = 8'd0;
    end 
    FETCH3: begin       
      next_AR = 6'd0;
      next_DR = 8'd0;
      next_PC = 6'd0;
      next_IR = 2'd0;
      next_AC = 8'd0;
    end 
    ADD1: begin       
      next_AR = 6'd0;
      next_DR = 8'd0;
      next_PC = 6'd0;
      next_IR = 2'd0;
      next_AC = 8'd0;
    end 
    ADD2: begin 
      next_AR = 6'd0;
      next_DR = 8'd0;
      next_PC = 6'd0;
      next_IR = 2'd0;
      next_AC = 8'd0;
    end 
  endcase
end 

//sequential logic for output registering
always_ff(posedge clk) begin 
  if (rst) begin 
        AR<=6'd0;
        DR<=8'd0;
        PC<=6'd0;
        IR<=2'd0;
        AC<=8'd0
  end 
  else begin
    AR<=next_AR;
    PC<=next_PC;
    DR<=next_DR;
    IR<=next_IR;
    AC<=next_AC;
  end 
end
  
endmodule
