/**
 * Testbench 0 - ADDI
 * 
 */

`include "./src/Riscv.v"

module Riscv_TB;
    reg clock, reset;

    reg [4:0] reg_out_id;
    wire [31:0] reg_out_data;

    integer cur_time;

    Riscv riscv(
        .clock(clock),
        .reset(reset),
        .reg_out_id(reg_out_id),
        .reg_out_data(reg_out_data),
        .fetch_ram_load(1'b0),
        .mem_ram_load(1'b0)
    );

    initial begin
        /* addi x10, x0, 3 */
        // Coloca as instruções do arquivo na estrutura de memória de instruções
        #10 $readmemh("../tb/riscv_tb1_addi.hex", 
                      riscv.FETCH.instruction_memory.mem);
        // Faz o dump das formas de onda para análise posterior
        $dumpfile("riscv_tb1_addi.vcd");
        $dumpvars;

        // Imprime na tela alguns sinais escolhidos
        $display("\tTime\t\t0\t1\t2");
        $monitor("%d\t%d%d%d", cur_time,
            riscv.REGISTERS.registers[0],
            riscv.REGISTERS.registers[1],
            riscv.REGISTERS.registers[2]
        );

        // Termina depois de 100 ticks
        #100 $finish;
    end

    initial begin
        cur_time = $time;
        clock <= 0;
        reset <= 1;
        #2 reset <= 0;
        #2 reset <= 1;
    end

    always begin
        #3 clock <= ~clock;
        cur_time = $time;
    end

endmodule
