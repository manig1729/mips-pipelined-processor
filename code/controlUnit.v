/*
    Main control unit - takes the opcode of the instruction (bits 31-26) and generates all
    of the control signals required.

    if controlMuxSelect is active, all control signals are made 0
    This is done to insert a bubble in the pipeline
*/

module controlUnit (opcode, controlMuxSelect, RegDst, Branch, MemRead, MemtoReg, 
                    ALUOp, MemWrite, ALUSrc, RegWrite);

    input [5:0] opcode;
    input controlMuxSelect;
    output reg RegDst, Branch, MemRead, MemtoReg;
    output reg [1:0] ALUOp;
    output reg MemWrite, ALUSrc, RegWrite;

    always @(*) begin
      
      if(controlMuxSelect == 1) begin     // Hazard detection
              RegDst    = 0;
              ALUSrc    = 0;
              MemtoReg  = 0;
              RegWrite  = 0;
              MemRead   = 0;
              MemWrite  = 0;
              Branch    = 0;
              ALUOp     = 2'b00;
      end

      else begin
        case(opcode)
            6'b000000: begin        // R-type instructions
              RegDst    = 1;
              ALUSrc    = 0;
              MemtoReg  = 0;
              RegWrite  = 1;
              MemRead   = 0;
              MemWrite  = 0;
              Branch    = 0;
              ALUOp     = 2'b10;
            end

            6'b001000: begin        // addi instruction
              RegDst    = 0;
              ALUSrc    = 1;
              MemtoReg  = 0;
              RegWrite  = 1;
              MemRead   = 0;
              MemWrite  = 0;
              Branch    = 0;
              ALUOp     = 2'b00;
            end

            6'b100011: begin        // lw instruction
              RegDst    = 0;
              ALUSrc    = 1;
              MemtoReg  = 1;
              RegWrite  = 1;
              MemRead   = 1;
              MemWrite  = 0;
              Branch    = 0;
              ALUOp     = 2'b00;
            end

            6'b101011: begin        // sw instruction
              RegDst    = 0;
              ALUSrc    = 1;
              MemtoReg  = 1;
              RegWrite  = 0;
              MemRead   = 0;
              MemWrite  = 1;
              Branch    = 0;
              ALUOp     = 2'b00;
            end

            6'b000100: begin        // beq instruction
              RegDst    = 0;
              ALUSrc    = 0;
              MemtoReg  = 1;
              RegWrite  = 0;
              MemRead   = 0;
              MemWrite  = 0;
              Branch    = 1;
              ALUOp     = 2'b01;
            end

        endcase
      end
    end

endmodule
