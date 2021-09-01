/**
 * Testbench 4 - Dos slides
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
        /* 
        Instruções:
        
        mul x11, x12, x13
        addi x21, x20, 1
        mul x15, x11, x14
        mul x17, x15, x16
        addi x22, x21, 1
        addi x23, x22, 1
        addi x24, x22, 2
        
        */
        // Coloca as instruções do arquivo na estrutura de memória de instruções
        #10 $readmemh("../tb/riscv_tb4_slide.hex", 
                      riscv.FETCH.instruction_memory.mem);
                      
        // Faz o dump das formas de onda para análise posterior
        $dumpfile("riscv_tb4_slide.vcd");
        $dumpvars;

        // Imprime na tela alguns sinais escolhidos
        $display("\t\t$s2");
        $monitor("\t%h",
            riscv.FETCH.if_id_instruc
        );

        // Termina depois de 100 ticks
        #150 $finish;
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
