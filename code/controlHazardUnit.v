/*
    Assume branch not taken
    If branch does get taken, flush out the first three pipeline registers

    More detailed explanation is given in the sample program in the report
*/

module controlHazardUnit (branch_taken, IF_ID_flush, ID_EX_flush, EX_MEM_flush);
    input branch_taken;
    output reg IF_ID_flush, ID_EX_flush, EX_MEM_flush;

    always @(*) begin
        if (branch_taken) begin
            IF_ID_flush = 1;
            ID_EX_flush = 1;
            EX_MEM_flush = 1;
        end

        else begin
          IF_ID_flush = 0;
          ID_EX_flush = 0;
          EX_MEM_flush = 0;
        end
    end
endmodule