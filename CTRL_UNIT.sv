module CTRL_UNIT(input logic [3:0] current_state,  
input logic [1:0] opcode, 
output logic[1:0] next_IR, 
output logic[5:0] next_PC, next_AR,
output logic[7:0] next_DR, next_AC);

logic arload, pcload, pcinc, drload, acload, acinc, irload, alusel, membus, pcbus, drbus, read;
logic ctrl_sig[11:0] ={arload,pcload,pcinc,drload,acload,acinc,irload,alusel,membus,pcbus,drbus,read};
    
//assign each signal to a bit in the wire 
    
//state machine for always
//combinational logic for next outputs (control unit)
//txtbook control signals are asserted the state BEFORE the textbook presentations, this is so that the proper values can be latched
//and registered cleanly on the positive edge of the next clock cycle
//i.e. if the textbook says fetch1 asserts a specific signal, it will actually be asserted on the idle state (before fetch1) 
//the register transfer associated with fetch 1 then cleanly occurs on the positive edge of the clock for fetch 1
    
always@(*) begin 
      next_AR = AR;
      next_DR = DR;
      next_PC = PC;
      next_IR = IR;
      next_AC = AC;
  case(current_state) 
    IDLE: begin 
        pcbus=1;
        arload=1;
    end 
    FETCH1: begin 
        pcinc=1;
        membus=1;
        drload=1;
        read=1;
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
