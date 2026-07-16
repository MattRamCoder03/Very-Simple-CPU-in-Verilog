module top_module ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	`probe(clk);        // Probe signal "clk"

	// A testbench
	reg start=1;
    reg rst =1;
	initial begin
        #12 rst <=0;
		$display ("Hello world! The current time is (%0d ps)", $time);
		#70 $finish;            // Quit the simulation
	end
    
    CPU test1(.clk(clk), .start(start), .rst(rst));

endmodule

module CPU(input logic clk, input logic start, input logic rst);

  reg[1:0] IR;
  reg[5:0] PC, AR;
  reg[7:0] DR, AC, MEM;

  logic[1:0] next_IR;
  logic[5:0] next_PC, next_AR;
  logic[7:0] next_DR, next_AC;

reg [3:0] state, next_state;
parameter IDLE=4'd0, FETCH1=4'd1, FETCH2=4'd2, FETCH3=4'd3, ADD1=4'd4, ADD2=4'd5, AND1=4'd6, AND2=4'd7, JMP=4'd8, INC=4'd9;
    
  initial begin
    MEM = 8'b11000011;
    IR = 2'd0;
end
    
  always@(posedge clk) begin 
  if (rst) begin 
        state<=IDLE;
      end 
  else begin 
        state<=next_state;
      end 
    end 

//combinational logic for next state
always@(*) begin 
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
    if (IR==2'b00) begin
        next_state = ADD1;
      end 
        else if (IR==2'b01) begin 
      next_state=AND1;
    end 
        else if (IR==2'b10) begin 
      next_state=JMP;
    end 
        else if (IR==2'b11) begin
      next_state = INC;
    end 
      else begin 
        next_state = IDLE;
    end 
    end
    ADD1: begin 
      next_state = ADD2;
    end
    ADD2: begin 
      next_state = IDLE;
    end 
    AND1: begin 
      next_state = AND2;
    end 
    AND2: begin 
      next_state = IDLE;
    end 
    JMP: begin 
        next_state = IDLE;
    end 
    INC: begin 
        next_state = IDLE;
    end 
    default: next_state = IDLE;
  endcase
end 

    //combinational logic for next outputs (control unit)
always@(*) begin 
      next_AR = AR;
      next_DR = DR;
      next_PC = PC;
      next_IR = IR;
      next_AC = AC;
  case(state) 
    IDLE: begin 
      next_AR = PC;
    end 
    FETCH1: begin 
      next_DR = MEM;
      next_PC = PC+1;
    end 
    FETCH2: begin
      next_AR = {DR[5:0]};
      next_IR = DR[7:6];
    end 
    FETCH3: begin       
    if (IR==2'b00) begin 
      	next_DR = MEM;
      end 
      else if (IR==2'b01) begin 
      	next_DR = MEM;
      end 
        else if (IR==2'b10) begin 
        next_PC = DR[5:0];
      end 
        else if (IR==2'b11) begin 
        next_AC = AC+1;
      end 
    end 
    ADD1: begin       
      next_AC = AC+DR;
    end 
    ADD2: begin 
        //
    end 
    AND1: begin 
      next_AC = AC && DR;
    end 
    AND2: begin 
        //
    end 
    JMP: begin 
        //
    end 
    INC: begin 
    end 
  endcase
end 

//sequential logic for output registering
always@(posedge clk) begin 
  if (rst) begin 
        AR<=6'd0;
        DR<=8'd0;
        PC<=6'd0;
        IR<=2'd0;
        AC<=8'd1;
  end 
  else begin
    AR<=next_AR;
    PC<=next_PC;
    DR<=next_DR;
    IR<=next_IR;
    AC<=next_AC;
  end 
end
    `probe(AC);
    `probe(PC);
    `probe(DR);
    `probe(IR);
    `probe(AR);
    `probe(MEM);
    `probe(state);
    `probe(next_state);
endmodule


