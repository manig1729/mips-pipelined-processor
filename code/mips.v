/*
    Main MIPS module for the processor

    This module defines all the circuit connections of the processor.
    For the circuit diagram and description of each of the modules,
    do go through the report.

    Most of the connections are self-explanatory and comments have been
    provided wherever necessary.

    To simulate the processor, please run the mipsTb module.
*/

// The following include statements are only needed for GTKWave + iverilog simulation
// You may remove these for simulation on ModelSim

`include "pc.v"
`include "instructionMemory.v"
`include "controlUnit.v"
`include "MUX.v"
`include "registerFile.v"
`include "signExtend.v"
`include "aluControl.v"
`include "alu.v"
`include "dataMemory.v"
`include "shiftLeft2.v"
`include "adder.v"
`include "registerModel.v"
`include "forwardingUnit.v"
`include "hazardDetectionUnit.v"
`include "controlHazardUnit.v"

// Code begins here

module mips (clk, rst);

    input clk;
    input rst;


    // Some wires needed are defined here
    // iVerilog works when defining connections first and wires later
    // but ModelSim gives errors when doing that

    // PC module
    wire [31:0] pc_out_IF;
    wire [31:0] pc_in_temp_IF;
    wire [31:0] pc_in_IF;
    wire PC_Write;
    
    // IDEX Register wires
    wire [31:0] pc_out_EX, readData1_EX, readData2_EX, signExtend_out_EX;
    wire [4:0] IDEX_Register_Rs, IDEX_Register_Rt, IDEX_Register_Rd;
    wire [1:0] ALUOp_EX;
    wire RegDst_EX, ALUSrc_EX, MemtoReg_EX, RegWrite_EX, MemRead_EX, MemWrite_EX, Branch_EX;

    // EX-MEM Register Wires
    wire [31:0] adder_out_MEM, alu_result_MEM, readData2_MEM;
    wire [4:0] writeReg_MEM;
    wire aluZero_MEM, MemRead_MEM, MemWrite_MEM, Branch_MEM, MemtoReg_MEM, RegWrite_MEM;

    // MEM-WB register Wires
    wire [31:0] ReadData_WB, alu_result_WB;
    wire [4:0] writeReg_WB;
    wire MemtoReg_WB, RegWrite_WB;

                                    /* IF Stage */

    // First MUX in circuit
    wire PC_Src;

    MUX_32bit MUX4 (pc_out_IF, adder_out_MEM, PC_Src, pc_in_temp_IF);

    wire IFID_flush, IDEX_flush, EXMEM_flush;

    register_32_bit_write pc_register_module (clk, rst, PC_Write, pc_in_temp_IF, pc_in_IF);
    pc_adder pc_adder_module (pc_in_IF, pc_out_IF);

    // Instruction Memory
    wire [31:0] instruction_IF;
    instructionMemory im_module (pc_in_IF, instruction_IF);

    // IF/ID Register
    wire [31:0] instruction_ID;
    wire [31:0] pc_out_ID;
    wire IF_ID_Write;
    register_32_bit_write_flush IF_ID_instruction_module (clk, rst, IF_ID_Write, IFID_flush, instruction_IF, instruction_ID);
    register_32_bit_write IF_ID_PCout_module (clk, rst, IF_ID_Write, pc_out_IF, pc_out_ID);

                                    /* ID Stage */

    // Hazard detection unit
    wire controlMux_Select;
    hazardDetectionUnit hdu_module (MemRead_EX, IDEX_Register_Rt, instruction_ID[25:21],instruction_ID[20:16],
                                    IF_ID_Write, PC_Write, controlMux_Select);

    // Control unit
    wire [5:0] opcode_ID;
    assign opcode_ID = instruction_ID[31:26];
    wire RegDst_ID, Branch_ID, MemRead_ID, MemtoReg_ID;
    wire [1:0] ALUOp_ID;
    wire MemWrite_ID, ALUSrc_ID, RegWrite_ID;
        // Hazard detection MUX is incorporated within control unit
    controlUnit cu_module (opcode_ID, controlMux_Select, RegDst_ID, Branch_ID, MemRead_ID, MemtoReg_ID,    
                            ALUOp_ID, MemWrite_ID, ALUSrc_ID, RegWrite_ID);

    // Register file module
    wire [31:0] writeData_WB;
    wire [31:0] readData1_ID, readData2_ID;  
    registerFile rf_module (clk, RegWrite_WB, instruction_ID[25:21], instruction_ID[20:16],
                            writeReg_WB, writeData_WB, readData1_ID, readData2_ID);

    // Sign extension module
    wire [31:0] signExtend_out_ID;
    signExtend se_module (instruction_ID[15:0], signExtend_out_ID);
    
    // ID/EX Register

    register_32_bit ID_EX_1 (clk, rst, pc_out_ID, pc_out_EX);
    register_32_bit ID_EX_2 (clk, rst, readData1_ID, readData1_EX);
    register_32_bit ID_EX_3 (clk, rst, readData2_ID, readData2_EX);
    register_32_bit ID_EX_4 (clk, rst, signExtend_out_ID, signExtend_out_EX);
    register_5_bit ID_EX_5 (clk, rst, instruction_ID[20:16], IDEX_Register_Rt);
    register_5_bit ID_EX_6 (clk, rst, instruction_ID[15:11], IDEX_Register_Rd);
    register_5_bit ID_EX_15 (clk, rst, instruction_ID[25:21], IDEX_Register_Rs);
    register_1_bit_flush ID_EX_7 (clk, rst, IDEX_flush, RegDst_ID, RegDst_EX);
    register_1_bit_flush ID_EX_8 (clk, rst, IDEX_flush, ALUSrc_ID, ALUSrc_EX);
    register_1_bit_flush ID_EX_9 (clk, rst, IDEX_flush, MemtoReg_ID, MemtoReg_EX);
    register_1_bit_flush ID_EX_10 (clk, rst, IDEX_flush, RegWrite_ID, RegWrite_EX);
    register_1_bit_flush ID_EX_11 (clk, rst, IDEX_flush, MemRead_ID, MemRead_EX);
    register_1_bit_flush ID_EX_12 (clk, rst, IDEX_flush, MemWrite_ID, MemWrite_EX);
    register_1_bit_flush ID_EX_13 (clk, rst, IDEX_flush, Branch_ID, Branch_EX);
    register_2_bit_flush ID_EX_14 (clk, rst, IDEX_flush, ALUOp_ID, ALUOp_EX);

                                    /* EX Stage */

    // Forwarding unit
    wire [1:0] forwardA, forwardB;
    forwardingUnit fu_module (RegWrite_MEM, writeReg_MEM, IDEX_Register_Rs, IDEX_Register_Rt,
                              RegWrite_WB, writeReg_WB, forwardA, forwardB);

    wire [31:0] ALUin1_EX_fu;
    wire [31:0] ALUin2_EX_fu;
    MUX_3_1 MUX_fu_1 (readData1_EX, writeData_WB, alu_result_MEM, forwardA, ALUin1_EX_fu);
    MUX_3_1 MUX_fu_2 (readData2_EX, writeData_WB, alu_result_MEM, forwardB, ALUin2_EX_fu);

    // ALU control signal
    wire [3:0] aluControlSignal_EX;
    aluControl ac_module (signExtend_out_EX[5:0], ALUOp_EX, aluControlSignal_EX);

    // MUX for ALU
    wire [31:0] ALUin2_EX;
    MUX_32bit MUX2 (ALUin2_EX_fu, signExtend_out_EX, ALUSrc_EX, ALUin2_EX);

    // Primary ALU
    wire [31:0] alu_result_EX;
    wire aluZero_EX;
    alu ALU_module (ALUin1_EX_fu, ALUin2_EX, aluControlSignal_EX, alu_result_EX, aluZero_EX);

    // shift-left-2 for PC vs branch
    wire [31:0] SLT_2_temp_EX;
    shiftLeft2_32bit SL2_2 (signExtend_out_EX, SLT_2_temp_EX);

    // Adder
    wire [31:0] adder_out_EX;
    adder Add_module (pc_out_EX, SLT_2_temp_EX, adder_out_EX);

    // MUX for register file
    wire [4:0] writeReg_EX;
    MUX_5bit MUX1 (IDEX_Register_Rt, IDEX_Register_Rd, RegDst_EX, writeReg_EX);

    // EX/MEM Register
    
    register_32_bit EX_MEM1 (clk, rst, adder_out_EX, adder_out_MEM);
    register_32_bit EX_MEM2 (clk, rst, alu_result_EX, alu_result_MEM);
    register_32_bit EX_MEM3 (clk, rst, readData2_EX, readData2_MEM);
    register_5_bit EX_MEM4 (clk, rst, writeReg_EX, writeReg_MEM);
    register_1_bit EX_MEM5 (clk, rst, aluZero_EX, aluZero_MEM);
    register_1_bit_flush EX_MEM6 (clk, rst, EXMEM_flush, MemRead_EX, MemRead_MEM);
    register_1_bit_flush EX_MEM7 (clk, rst, EXMEM_flush, MemWrite_EX, MemWrite_MEM);
    register_1_bit_flush EX_MEM8 (clk, rst, EXMEM_flush, Branch_EX, Branch_MEM);
    register_1_bit_flush EX_MEM9 (clk, rst, EXMEM_flush, MemtoReg_EX, MemtoReg_MEM);
    register_1_bit_flush EX_MEM10 (clk, rst, EXMEM_flush, RegWrite_EX, RegWrite_MEM);

                                    /* MEM Stage */

    // Data memory
    wire [31:0] ReadData_MEM;
    dataMemory dm_module (clk, alu_result_MEM[6:0], readData2_MEM, MemRead_MEM, MemWrite_MEM, ReadData_MEM);
    
    assign PC_Src = Branch_MEM & aluZero_MEM;

    wire branchtaken;
    assign branchtaken = Branch_MEM & aluZero_MEM;

    // Control hazard unit (for branch)
    controlHazardUnit chu_module (branchtaken, IFID_flush, IDEX_flush, EXMEM_flush);              

    /// MEM/WB Register
    
    register_32_bit MEM_WB1 (clk, rst, ReadData_MEM, ReadData_WB);
    register_32_bit MEM_WB2 (clk, rst, alu_result_MEM, alu_result_WB);
    register_5_bit MEM_WB3 (clk, rst, writeReg_MEM, writeReg_WB);
    register_1_bit MEM_WB4 (clk, rst, MemtoReg_MEM, MemtoReg_WB);
    register_1_bit MEM_WB5 (clk, rst, RegWrite_MEM, RegWrite_WB);

                                    /* WB Stage */

    // MUX after data memory
    MUX_32bit MUX3 (alu_result_WB, ReadData_WB, MemtoReg_WB, writeData_WB);

endmodule
