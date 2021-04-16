/*
    The hazard detection unit is used to handle load use hazards
*/

module hazardDetectionUnit (IDEXMemRead, IDEXRegisterRt, IFIDRegisterRs, IFIDRegisterRt,
                            IFIDWrite, PCWrite, controlMuxSelect);

    input IDEXMemRead;
    input [4:0] IDEXRegisterRt, IFIDRegisterRs, IFIDRegisterRt;
    output reg IFIDWrite, PCWrite, controlMuxSelect;

    always @(*) begin
        if  ((IDEXMemRead) &&
            ((IDEXRegisterRt == IFIDRegisterRs) || 
            (IDEXRegisterRt == IFIDRegisterRt)))
            begin
                IFIDWrite = 1;
                PCWrite = 1;
                controlMuxSelect = 1;
            end
        else begin
            IFIDWrite = 0;
            PCWrite = 0;
            controlMuxSelect = 0;
        end
    end
endmodule