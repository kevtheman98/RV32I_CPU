import subprocess
import glob
import os
from pathlib import Path

count = 0
passCount = 0

# pulls all SystemVerilog design files & assembly test files
sv_files = [os.path.abspath(f) for f in glob.glob("rtl/*.sv")]
assembly_files = [os.path.abspath(f) for f in glob.glob("tests/*.s")]
print(sv_files)
print(assembly_files)


# xvlog, xelab, and xsim are vivado command line tools
# xvlog compiles the SystemVerilog files
# xelab elaborates(Fixes parameters and evaluate loops) the design and creates a simulation snapshot(executable simulation file)
# xsim runs the simulation snapshot

xvlogResult = subprocess.run(["xvlog", "-sv", *sv_files, "../sim/tb/top_tb.sv"], cwd = "./build", capture_output=True, text=True)
xelabResult = subprocess.run(["xelab", "top_tb", "-debug", "typical", "-s", "cpu_sim"], cwd = "./build", capture_output=True, text=True)

if xvlogResult.returncode != 0:
    print("xvlog failed")
    print(xvlogResult.stderr)
    print(xvlogResult.stdout)
    exit(1)

if xelabResult.returncode != 0:
    print("xelab failed")
    print(xelabResult.stderr)
    exit(1)


for test_file in assembly_files:

    file_name = test_file.rsplit("/", 1)[1]  # Extract the file name from the path


    root, ext = os.path.splitext(file_name)

    linker_script_path = os.path.abspath("sim/linker.ld")  # Get the absolute path of the linker script

    compilerResult = subprocess.run(["riscv64-unknown-elf-gcc", "-march=rv32i", "-mabi=ilp32",
                                     # bare metal flags to get to raw hex
                                    "-nostdlib", "-nostartfiles", "-T", linker_script_path, 
                                    "-o", f"testdata/{root}.elf", f"tests/{root}.s"], 
                                    capture_output=True, text=True)


    if compilerResult.returncode != 0:
        print(f"Compilation failed for {test_file}")
        print(compilerResult.stderr)

    else:
        # Convert the ELF file to a hex file using objcopy
        subprocess.run(["riscv64-unknown-elf-objcopy", "-O", "verilog", "--verilog-data-width=4", f"testdata/{root}.elf", f"testdata/{root}.hex"], capture_output=True, text=True)

        if compilerResult.returncode != 0:
            print(f"Objcopy failed for {test_file}")

        
testdata = [os.path.abspath(f) for f in glob.glob("testdata/*.hex")]
print(testdata)

# Simulate each test data file using xsim
for testDataFile in testdata:

    xsimResult = subprocess.run(["xsim", "cpu_sim", "-R", "-testplusarg", f"MEMFILE={testDataFile}"], cwd="./build", capture_output=True, text=True)
    print(f"Running simulation with test data file: {testDataFile}")
    print(xsimResult.stdout)
    count += 1
    if "TEST PASSED" in xsimResult.stdout:
        passCount += 1
    print(f"Completed simulation {count}/{len(testdata)}")


print(f"Successful simulations: {passCount}/{len(testdata)}")
print(f"Completed all simulations. Total simulations run: {count}/{len(testdata)}")

