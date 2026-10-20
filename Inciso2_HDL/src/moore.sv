`timescale 1ns / 1ps

module moore (
    input  logic clk, reset,
    input  logic O, E, F, S,
    output logic Motor_Cinta, Actuador_Sello, Enable_Fill
);
    // Definición de estados
    typedef enum logic [1:0] {S0_IDLE=2'b00, S1_MOVER=2'b01, S2_LLENAR=2'b10, S3_SELLAR=2'b11} statetype;
    statetype state, nextstate;

    // Registro de estado (Secuencial)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) state <= S0_IDLE;
        else       state <= nextstate;
    end

    // Lógica de próximo estado (Combinacional)
    always_comb begin
        case (state)
            S0_IDLE:   nextstate = (O) ? S1_MOVER : S0_IDLE;
            S1_MOVER:  nextstate = (!O) ? S0_IDLE : ((E) ? S2_LLENAR : S1_MOVER);
            S2_LLENAR: nextstate = (!O) ? S0_IDLE : ((F) ? S3_SELLAR : S2_LLENAR);
            S3_SELLAR: nextstate = (!O) ? S0_IDLE : ((S) ? S1_MOVER : S3_SELLAR);
            default:   nextstate = S0_IDLE;
        endcase
    end

    // Lógica de salida (Arquitectura Moore: depende solo del estado)
    assign Motor_Cinta    = (state == S1_MOVER);
    assign Enable_Fill    = (state == S2_LLENAR);
    assign Actuador_Sello = (state == S3_SELLAR);
endmodule