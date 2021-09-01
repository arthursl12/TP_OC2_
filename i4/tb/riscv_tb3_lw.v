/**
 * Testbench 3 - LW
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
        
        addi x13, x0, 3
        addi x14, x0, 0
        lw x10, 0(x14)
        lw x11, 4(x14)
        add x12, x11, x10
        sw x13, 12(x0)
        sw x12, 8(x0)
        
        */
        // Coloca as instruções do arquivo na estrutura de memória de instruções
        #10 $readmemh("../tb/riscv_tb3_lw.hex", 
                      riscv.FETCH.instruction_memory.mem);
        #10 $readmemh("../tb/riscv_tb3_lw_reg_data.hex", 
                      riscv.MEM.MEM_1.data_memory.mem);
                      
        // Faz o dump das formas de onda para análise posterior
        $dumpfile("riscv_tb3_lw.vcd");
        $dumpvars;

        // Imprime na tela alguns sinais escolhidos
        $display("\t\t$s2\t$s3\t&8\t&12");
        $monitor("\t%d%d%d\t%d",
            riscv.REGISTERS.registers[18],
            riscv.REGISTERS.registers[19],
            riscv.MEM.MEM_1.data_memory.mem[2],
            riscv.MEM.MEM_1.data_memory.mem[3]
        );

        // Termina depois de 100 ticks
        #190 $writememh("riscv_tb3_lw_reg_data_out.hex", riscv.MEM.MEM_1.data_memory.mem);

        // Termina depois de 100 ticks
        #200 $finish;
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
