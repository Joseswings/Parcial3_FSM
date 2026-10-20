`timescale 1ns / 1ps

module testbench();
    // 1. Declarar las señales que coinciden exactamente con las del módulo top
    logic CLK100MHZ;
    logic [4:0] sw;
    logic [4:0] LED;

    // 2. Instanciar el módulo top_fsm_example2 (el DUT - Device Under Test)
    // Conectamos las variables locales a los puertos del módulo
    top dut (
        .CLK100MHZ(CLK100MHZ),
        .sw(sw),
        .LED(LED)
    );

    // 3. Generar un reloj simulado de 100MHz (Periodo = 10ns)
    always begin
        CLK100MHZ = 1; #5;
        CLK100MHZ = 0; #5;
    end

    // 4. Inyectar los estímulos a los switches
    // Recordemos el mapeo del módulo top:
    // sw[4] = Reset
    // sw[3] = Sens_Sello
    // sw[2] = Sens_Nivel
    // sw[1] = Sens_Envase
    // sw[0] = ON_OFF
    
    initial begin
        // A. Estado Inicial y Reset general
        sw = 5'b10000; // Solo Reset (sw[4]) en 1, el resto en 0
        #50;           // Esperamos un momento a que el reset haga efecto
        sw = 5'b00000; // Quitamos el Reset
        #50;
        
        // B. Encender la máquina (ON_OFF = 1) -> Pasa al estado MOVER
        sw = 5'b00001; 
        #100;
        
        // C. Detectar Envase (Sens_Envase = 1) -> Pasa al estado LLENAR
        sw = 5'b00011; 
        #100;
        
        // D. La botella se está llenando (Sens_Envase = 0)
        sw = 5'b00001; 
        #100;
        
        // E. Líquido llega al nivel (Sens_Nivel = 1) -> Activa Fill_Done y cierra válvula
        sw = 5'b00101; 
        #100;
        
        // F. Transición a Sellar y quitar el sensor de nivel
        sw = 5'b00001; 
        #100;
        
        // G. Presión de Sello detectada (Sens_Sello = 1) -> Vuelve a MOVER
        sw = 5'b01001; 
        #100;
        
        // Finalizar simulación
        $finish;
    end
endmodule