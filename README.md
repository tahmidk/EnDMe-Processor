# EnDMe-Processor
A microprocessor written in System Verilog that encrypts and decrypts a given message

All of the programs work and we checked off.

To compile the theProgram.txt into .bin file, run "python assembler.py theProgram.txt"
To run the project, open ProjectEnDMe.qpf in Quartus Prime and go to tools -> run simulation tools -> RTL simulation.

We integrated the text bench given in Blackboard into top_level.sv as module tb_top. We also modify the test branch to test different strings, different variables, and different lfsr patterns. We added some debug statements but we commented it out. It will print out reg files and mem files.
