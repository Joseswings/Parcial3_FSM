`timescale 1ns / 1ps

module mealy(
    input  logic clk, reset,
    input  logic EN, N,
    output logic Valvula, Fill_Done
);
    typedef enum logic {V0_CERRADA=1'b0, V1_ABIERTA=1'b1} statetype;
    statetype state, nextstate;
    // Registro de estado
    always_ff @(posedge clk or posedge reset) begin
        if (reset) state <= V0_CERRADA;
        else       state <= nextstate;
    end

    // Lógica de próximo estado
    always_comb begin
        case (state)
            V0_CERRADA: nextstate = (EN && !N) ? V1_ABIERTA : V0_CERRADA;
            V1_ABIERTA: nextstate = (N || !EN) ? V0_CERRADA : V1_ABIERTA;
            default:    nextstate = V0_CERRADA;
        endcase
    end

    // Lógica de salida (Arquitectura Mealy: depende del estado y las entradas directas)
    assign Valvula   = (EN && !N); 
    assign Fill_Done = (state == V1_ABIERTA && N);  
endmodule
