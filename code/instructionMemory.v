/*
    The instruction memory

    To run programs, type your instructions here.
    Do make sure you start storing them from instructionMem[1]

    All the sample programs shown in the report are also given here as comments.

    The program uncommented is the one I used for Miscellaneous Instruction demonstration.
*/

module instructionMemory(readAddress, instruction);

    //input clk;
    input [31:0] readAddress;
    output reg [31:0] instruction;

    reg [31:0] instructionMem [0:127];

    integer i = 0;

    // TODO - Add instructions here!
    initial begin
        for(i = 0; i < 128; i = i + 1) begin    // Make all memory locations 0
            instructionMem[i] = 0;
        end

        /*          1 - Instruction going through the pipeline
        instructionMem[1] = {6'd0, 5'd9, 5'd8, 5'd10, 5'd0, 6'd32};         // add $t2, $t1, $t0
        */

        /*          2 - Data Hazard solved using forwarding                 
        instructionMem[1] = {6'd0, 5'd9, 5'd8, 5'd10, 5'd0, 6'd32};         // add $t2, $t1, $t0
        instructionMem[2] = {6'd0, 5'd10, 5'd9, 5'd11, 5'd0, 6'd32};        // add $t3, $t2, $t1
        */

        /*                      3 - Load Use Hazard                         
        instructionMem[1] = {6'd35, 5'b01000, 5'b01001, 16'd4};             // lw $t1, 4($t0)
        instructionMem[2] = {6'd0, 5'd9, 5'd8, 5'd11, 5'd0, 6'd32};         // add $t3, $t1, $t0
        */

        /*                  4 - Control Hazard and Branch decision          
        instructionMem[1] = {6'd4, 5'd11, 5'd8, 16'd40};                 // beq $t3, $t0, +40
        instructionMem[2] = {6'd0, 5'd9, 5'd10, 5'd11, 5'd0, 6'd32};     // add $t3, $t1, $t2
        instructionMem[3] = {6'd0, 5'd9, 5'd8, 5'd12, 5'd0, 6'd32};     // add $t4, $t1, $t0
        instructionMem[4] = {6'd0, 5'd8, 5'd11, 5'd8, 5'd0, 6'd34};     // sub $t0, $t3, $t0
        instructionMem[42] = {6'd0, 5'd9, 5'd8, 5'd12, 5'd0, 6'd32};     // add $t4, $t1, $t0
        */

        /*                  5 - Miscellaneous Instructions                  */
        instructionMem[1] = {6'd8, 5'd0, 5'd8, 16'd12};                 // addi $t0, $zero, 12
        instructionMem[2] = {6'd8, 5'd0, 5'd9, 16'd5};                 // addi $t1, $zero, 5
        instructionMem[3] = {6'd0, 5'd9, 5'd8, 5'd12, 5'd0, 6'd42};     // slt $t4, $t1, $t0
        instructionMem[4] = {6'd0, 5'd9, 5'd12, 5'd10, 5'd0, 6'd34};     // sub $t2, $t1, $t4
        
    end

    always @(*) begin
      instruction = instructionMem[readAddress[31:2]];
    end

endmodule