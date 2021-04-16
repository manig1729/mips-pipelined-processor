# MIPS Pipelined Processor Implementation in Verilog
This is a verilog implementation of a MIPS Pipelined Processor based on the design in Patterson and Hennessy's "Computer Organization and Design" book.

For a detailed explanation, I would highly recommend you to go through the [report](https://github.com/manig1729/mips-pipelined-processor/blob/master/assets/report-pipelined-processor.pdf "report").

The instructions implemented on the processor are - 

R-type instructions - add, sub, AND, OR, slt  
addi instruction  
sw instruction  
lw instruction  
beq instruction

The basic design of the processor is based on my single cycle processor, which can be found here : [mips-single-cycle-processor](https://github.com/manig1729/mips-single-cycle-processor "mips-single-cycle-processor").

In the instruction file comments, there are sample programs (which are discussed at length in the report) showing the ability of the processor to handle different types of hazards.

The basic circuit diagram of the processor, showing the pipeline registers, is as shown here

<img src="/assets/pipeline-registers.png" alt="drawing" width="500"/> <br>

To this, a forwarding unit and a hazard detection unit have been added, as shown here 

<img src="/assets/hazard-detection-forwarding-unit.png" alt="drawing" width="500"/> <br>

A control hazard detection unit is also present in the processor, which is not shown in the circuit diagram. You can find its code in [controlHazardUnit.v](https://github.com/manig1729/mips-pipelined-processor/blob/master/code/controlHazardUnit.v "controlHazardUnit.v").

## Scope for Improvement

There is a lot of scope for improvement in this processor design, and I plan to implement these ideas in the future

### Addition of new instructions
The instructions I have implemented so far form only a small subset of the MIPS ISA and a lot of other instructions can be added - including more immediate instructions, floating point instructions etc

### Branch Prediction
I have implemented a very rudimentary form of branch prediction, which assumes that a branch will never be taken and if it is taken, the three previous instructions have to be flushed out.
This can be improved in two ways - moving the branch decision earlier in the pipeline as we don't need a full ALU to see if two numbers are equal, so that less instructions have to be flushed out; or by using Dynamic branch prediction, which predicts branching based on previous branching decisions
