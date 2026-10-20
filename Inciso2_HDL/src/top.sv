`timescale 1ns / 1ps

module top(
    input logic CLK100MHZ,
    input logic [4:0] sw, // sw[4]=Reset | sw[0]=ON_OFF, sw[1]=Sens_Envase, sw[2]=Sens_Nivel, sw[3]=Sens_Sello
    output logic [4:0] LED // LED[0]=Motor, LED[1]=Actuador, LED[2]=Valvula, LED[3]=Enable_Fill, LED[4]=Fill_Done
);
                     
    logic internal_psc_clock;       
    logic Enable_Fill_wire;
    logic Fill_Done_wire;
                 
    // Instancia del divisor de reloj
    clck_psc my_clck (
        .clk(CLK100MHZ), 
        .tick(internal_psc_clock)
    );   
                
    // Instancia de FSM1 (Moore)
    moore fsm1_inst (
        .clk(internal_psc_clock), 
        .reset(sw[4]), 
        .O(sw[0]), 
        .E(sw[1]), 
        .F(Fill_Done_wire), 
        .S(sw[3]),
        .Motor_Cinta(LED[0]), 
        .Actuador_Sello(LED[1]), 
        .Enable_Fill(Enable_Fill_wire)
    );

    // Instancia de FSM2 (Mealy)
    mealy fsm2_inst (
        .clk(internal_psc_clock), 
        .reset(sw[4]), 
        .EN(Enable_Fill_wire), 
        .N(sw[2]),
        .Valvula(LED[2]), 
        .Fill_Done(Fill_Done_wire)
    );

    // Conectamos las señales internas a LEDs adicionales para ver la comunicación en el video
    assign LED[3] = Enable_Fill_wire;
    assign LED[4] = Fill_Done_wire;
    
endmodule