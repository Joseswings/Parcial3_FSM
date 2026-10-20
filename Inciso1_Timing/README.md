# Timing Análisis (FF a FF)

**Resolución – Jose Guillermo Alas Alonzo**

De la FSM realizada para la evaluación anterior, se tomó un tramo de comunicación (ruta de Flip-Flop a Flip-Flop) entre la FSM 1 (Moore) y la FSM 2 (Mealy). Específicamente, la ruta que va desde que los Flip-Flops de la FSM 1 generan el estado actual (`S1`, `S0`), pasan por la lógica combinacional para crear `Enable_Fill`, y entran a la lógica de próximo estado de la FSM 2 (`V0_next`) hasta llegar a la entrada D de su Flip-Flop.

### 1. Identificación de la Ruta en el Circuito

![Imagen1](/Inciso1_Timing/Img/Imagen1.png)

*Aquí se ve `Enable_Fill` que sale del `fsm1_block` y entra al `fsm2_block`. Esta es la señal de comunicación principal cuyo tiempo estamos analizando y abarca desde que se origina esta señal dentro del `fsm1_block` hasta que llega a la lógica del `fsm2_block`.*

![Imagen2](/Inciso1_Timing/Img/Imagen2.png)

*Aquí vemos que la ruta comienza en los Flip-Flops de FSM1 (`S1`, `S0`). La señal atraviesa un NOT y luego un AND para generar `Enable_Fill`.*

![Imagen3](/Inciso1_Timing/Img/Imagen3.png)

*La señal `Enable_Fill` ingresa a FSM2 y atraviesa una última compuerta AND antes de llegar al Flip-Flop de destino. Por lo tanto, la ruta completa desde el FF origen hasta el FF destino consta de: NOT + AND (en FSM1) + AND (en FSM2).*

### 2. Lógica Combinacional y Selección de Compuertas

La lógica combinacional en este tramo es:
* `Enable_Fill = S1 & ~S0`
* `V0_next = Enable_Fill & ~N`

Por lo que el camino más largo es: **NOT → AND → AND**.

Compuertas lógicas seleccionadas de DigiKey y sus respectivas métricas (evaluadas a un voltaje de operación nominal de 4.5V):

**D Flip-Flop: [SN74HC74](https://www.digikey.com/en/products/detail/texas-instruments/SN74HC74N/277248)**

![Imagen4](/Inciso1_Timing/Img/Imagen4.png)
* Setup time ($t_{setup}$): 20ns
* Hold time ($t_{hold}$): 0ns
* Clock-to-Q Propagation Delay ($t_{pcq}$): 35ns
* Clock-to-Q Contamination Delay ($t_{ccq}$): Como no se incluye en el datasheet para este modelo antiguo, se asume el peor caso de 0ns.

**NOT: [SN74HC04PWR](https://www.digikey.com/en/products/detail/texas-instruments/SN74HC04PWR/377033)**

![Imagen5](/Inciso1_Timing/Img/Imagen5.png)
* Propagation Delay ($t_{pd}$): Típico 9ns, Máximo 24ns.
* Contamination Delay ($t_{cd}$): Como no se proporciona, se asume 0ns.

**AND: [SN74HC08PWR](https://www.digikey.com/en/products/detail/texas-instruments/SN74HC08PWR/377030)**

![Imagen6](/Inciso1_Timing/Img/Imagen6.png)
* Propagation Delay ($t_{pd}$): Típico 10ns, Máximo 30ns.

---

### 3. Setup Time Constraint + $F_c$ (Frecuencia Máxima de Operación)

Según la fórmula del libro de Harris & Harris, el periodo del reloj debe cumplir con:
$$T_c \geq t_{pcq} + t_{pd\_logic} + t_{setup}$$

**Retardo de la lógica combinacional (Peor Caso):**
$$t_{pd\_logic} = t_{pd}(\text{NOT}) + t_{pd}(\text{AND}) + t_{pd}(\text{AND})$$
$$t_{pd\_logic} = 24\text{ ns} + 30\text{ ns} + 30\text{ ns} = \mathbf{84\text{ ns}}$$

**Período mínimo ($T_{c\_min}$):**
$$T_c \geq 35\text{ ns} + 84\text{ ns} + 20\text{ ns} = \mathbf{139\text{ ns}}$$

**Frecuencia máxima ($F_{max}$):**
$$F_{max} = \frac{1}{T_{c\_min}} = \frac{1}{139 \times 10^{-9}\text{ s}} \approx \mathbf{7.19\text{ MHz}}$$

---

### 4. Hold Time Constraint

Según la fórmula del libro, para evitar violaciones de tiempo de retención:
$$t_{ccq} + t_{cd\_logic} \geq t_{hold}$$

**Sustituyendo los valores:**
$$t_{ccq} + t_{cd\_logic} \geq 0\text{ ns}$$

Como el Flip-Flop SN74HC74 está diseñado con un $t_{hold} = 0\text{ ns}$, y cualquier compuerta lógica y Flip-Flop físico tiene un retardo de contaminación siempre positivo o mayor a cero ($t_{ccq} > 0$ y $t_{cd} > 0$), **la restricción de Hold Time se cumple holgadamente por naturaleza**. No existen violaciones de *race conditions* en este diseño.