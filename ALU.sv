module ALU(input logic [7:0] AC, input logic [7:0] DR, input logic ctrl_sel, output logic [7:0] accum_data);

assign accum_data = ctrl_sel ? (AC&DR): (AC+DR);
endmodule
