`ifndef MEMORYMODULE_V
`define MEMORYMODULE_V

// Instruction and Data Memory
module MemoryModule(
    input       wire            clk,
    input       wire    [6:0]   addr,
    input       wire    [31:0]  data_in,
    input       wire            write_enable,    
    output      wire    [31:0]  data
);
    // 32-bit memory with 128 entries
	reg [31:0] mem [0:127];             
	
    // Load requested address into data output
	assign data = mem[addr];

    // Store if enabled to do so
    always @(posedge clk) begin
        if (write_enable) begin
            mem[addr] <= data_in[31:0];
        end
    end

    /* 
    // Old way of initializing memory, 
    // Now we do it in testbench

    // Number of memory entries,
    // not the same as the memory size
	parameter NMEM = 128;  
							
    // file to read data from
	parameter IM_DATA = "im_data.hex";
    initial begin
	    $readmemh(IM_DATA, mem, 0, NMEM-1);
	end
    */
endmodule

`endif
