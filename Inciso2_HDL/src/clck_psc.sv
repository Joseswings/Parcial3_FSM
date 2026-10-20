`timescale 1ns / 1ps

module clck_psc(
    input logic clk,
    output logic tick
);
               
    logic [31:0] myreg = 0;
    
    always @(posedge clk)
        myreg += 1;
    
    assign tick = myreg[26]; // Aproximadamente 1.5 Hz de velocidad
endmodule