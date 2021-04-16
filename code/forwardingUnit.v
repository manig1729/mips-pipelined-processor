/*
    Forwarding unit - To handle 4 types of data hazards
    EX hazards : 1a and 1b, and MEM hazards : 2a and 2b
*/

module forwardingUnit (EXMem_RegWrite, EXMem_RegisterRd, IDEX_RegisterRs, IDEX_RegisterRt,
                       MEMWB_RegWrite, MEMWB_RegisterRd, forwardA, forwardB);

    input EXMem_RegWrite;
    input [4:0] EXMem_RegisterRd, IDEX_RegisterRs, IDEX_RegisterRt;
    input MEMWB_RegWrite;
    input [4:0] MEMWB_RegisterRd;
    output reg [1:0] forwardA, forwardB;

    // Conditions for Forward A
    //  && !(EXMem_RegWrite && (EXMem_RegisterRd != 0))

    always @(*) begin
        if ((EXMem_RegWrite) && (EXMem_RegisterRd != 0 ) && (EXMem_RegisterRd == IDEX_RegisterRs))
            forwardA = 2'b10;
        else if (MEMWB_RegWrite && (MEMWB_RegisterRd != 0 ) && (EXMem_RegisterRd != IDEX_RegisterRs) && (MEMWB_RegisterRd == IDEX_RegisterRs))
            forwardA = 2'b01;
        else
            forwardA = 2'b00;
    end

    // Conditions for Forward B
    //  && !(EXMem_RegWrite && (EXMem_RegisterRd != 0))
    always @(*) begin
        if ((EXMem_RegWrite) && (EXMem_RegisterRd != 0 ) && (EXMem_RegisterRd == IDEX_RegisterRt))
            forwardB = 2'b10;
        else if (MEMWB_RegWrite && (MEMWB_RegisterRd != 0 ) && (EXMem_RegisterRd != IDEX_RegisterRt) && (MEMWB_RegisterRd == IDEX_RegisterRt))
            forwardB = 2'b01;
        else
            forwardB = 2'b00;
    end

endmodule