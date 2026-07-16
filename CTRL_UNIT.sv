module CTRL_UNIT(input logic [3:0] current_state,  
input logic [1:0] opcode, 
output logic[1:0] next_IR, 
output_logic[5:0] next_PC, next_AR,
output logic[7:0] next_DR, next_AC);


//state machine for always
    //combinational logic for next outputs (control unit)
always@(*) begin 
      next_AR = AR;
      next_DR = DR;
      next_PC = PC;
      next_IR = IR;
      next_AC = AC;
  case(current_state) 
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

endmodule
