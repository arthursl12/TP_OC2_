`ifndef CONTROL_V
`define CONTROL_V

module Control (
    input     [6:0]    opcode,
    input     [2:0]    funct3,
    input     [6:0]    funct7,

    output             selwsource,
    output             selregdest,
    output             writereg,
    output             writeov,
    output             selimregb,
    output             selalushift,
    output    [2:0]    aluop,
    output    [1:0]    shiftop,
    output             readmem,
    output             writemem,
    output    [1:0]    selbrjumpz,
    output    [1:0]    selpctype,
    output    [2:0]    compop,
    output             unsig
);

    wire    [17:0]    sel;
    reg     [20:0]    out;


    assign sel = {opcode,funct3,funct7};

    // Whether to use an immediate value or a register as the second operand
    assign selimregb = out[20];
    // ? (used only in branches and jumps)
    assign selbrjumpz = out[19:18];
    // Represents number of register operands (1 => 3 registers,
    // 0 => 2 registers)
    assign selregdest = out[17];
    // Determines whether to write back data from Memory or Execute
    assign selwsource = out[16];
    // Whether or not the instruction writes to the ARF
    assign writereg = out[15];
    // If true, the instruction will write to the ARF even if an overflow
    // happens.
    assign writeov = out[14];
    // Whether or not to perform an unsigned operation
    assign unsig = out[13];         
    assign shiftop = out[12:11];    // Operation from shifter (maybe not needed)
    assign aluop = out[10:8];       // ALUOP (which is which?)
    assign selalushift = out[7];    // Use ALU or Shifter (maybe not needed)
    assign compop = out[6:4];       // Used in breaks, not needed
    assign selpctype = out[3:2];    // Used in jumps and branches, not needed
    assign readmem = out[1];        // Read from memory
    assign writemem = out[0];       // Write on memory

    always @(*) begin
        // casex (sel)  // MIPS                 
        //      // op    fn              // 098765432109876543210
        //     12'b000000000100: out <= 21'b0001011X10XXX1XXXXX00; // SLL
        //     12'b000000000110: out <= 21'b0001011X00XXX1XXXXX00; // SRL
        //     12'b000000000111: out <= 21'b0001011X01XXX1XXXXX00; // SRA
        //     12'b000000001000: out <= 21'bX01XX0XXXXXXXXXXX0100; // JR
        //     12'b000000100000: out <= 21'b00010100XX0100XXXXX00; // ADD
        //     12'b000000100001: out <= 21'b00010111XX0100XXXXX00; // ADDU
        //     12'b000000100010: out <= 21'b00010100XX1100XXXXX00; // SUB
        //     12'b000000100011: out <= 21'b00010111XX1100XXXXX00; // SUBU
        //     12'b000000100100: out <= 21'b0001011XXX0000XXXXX00; // AND
        //     12'b000000100101: out <= 21'b0001011XXX0010XXXXX00; // OR
        //     12'b000000100110: out <= 21'b0001011XXX1010XXXXX00; // XOR
        //     12'b000000100111: out <= 21'b0001011XXX1000XXXXX00; // NOR
        //     12'b000010XXXXXX: out <= 21'bX01XX0XXXXXXXXXXX1000; // J
        //     12'b000100XXXXXX: out <= 21'bX10XX0X0XXXXXX0000000; // BEQ
        //     12'b000101XXXXXX: out <= 21'bX10XX0X0XXXXXX1010000; // BNE
        //     12'b000110XXXXXX: out <= 21'bX10XX0X0XXXXXX0100000; // BLEZ
        //     12'b000111XXXXXX: out <= 21'bX10XX0X0XXXXXX0110000; // BGTZ
        //     12'b001000XXXXXX: out <= 21'b10000100XX0100XXXXX00; // ADDI
        //     12'b001001XXXXXX: out <= 21'b10000111XX0100XXXXX00; // ADDIU
        //     12'b001100XXXXXX: out <= 21'b1000011XXX0000XXXXX00; // ANDI
        //     12'b001101XXXXXX: out <= 21'b1000011XXX0010XXXXX00; // ORI
        //     12'b001110XXXXXX: out <= 21'b1000011XXX1010XXXXX00; // XORI
        //     12'b100011XXXXXX: out <= 21'b10001110XX0100XXXXX10; // LW
        //     12'b101011XXXXXX: out <= 21'b100XX0X0XX0100XXXXX01; // SW
        //     12'b000000011000: out <= 21'b00010100XX0000XXXXX00; // MULT
        //     default:          out <= 21'b000000000000000000000;
        // endcase

        // Controller signals
        casex (sel)  // RISCV "mini"                 
             // op     f3 f7               // 098765432109876543210
            17'b01100110000000000: out <= 21'b00010100XX0100XXXXX00; // ADD
            17'b0010011000XXXXXXX: out <= 21'b10000100XX0100XXXXX00; // ADDI
            // 17'b001001XXXXXX: out <=      21'b10000111XX0100XXXXX00; // ADDIU
            17'b0000011010XXXXXXX: out <= 21'b10001110XX0100XXXXX10; // LW
            17'b0100011010XXXXXXX: out <= 21'b100XX0X0XX0100XXXXX01; // SW
            // 12'b000000011000: out <= 21'b00010100XX0000XXXXX00; // MULT
            default:          out <= 21'b000000000000000000000;
        endcase

    end

endmodule

`endif
