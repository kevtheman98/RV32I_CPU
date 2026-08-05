import subprocess
import glob
import os
from pathlib import Path

count = 0

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
xelabResult = subprocess.run(["xelab", "top_tb", "-s", "cpu_sim"], cwd = "./build", capture_output=True, text=True)

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

    compilerResult = subprocess.run(["riscv64-unknown-elf-gcc", "-march=rv32i", "-mabi=ilp32",
                                     # bare metal flags 
                                    "-nostdlib", "-nostartfiles", "-Ttext=0x0", 
                                    "-o", f"testdata/{root}.elf", f"tests/{root}.s"], 
                                    capture_output=True, text=True)


    if compilerResult.returncode != 0:
        print(f"Compilation failed for {test_file}")
        print(compilerResult.stderr)

    else:
        subprocess.run(["riscv64-unknown-elf-objcopy", "-O", "verilog", f"testdata/{root}.elf", f"testdata/{root}.hex"], capture_output=True, text=True)

        if compilerResult.returncode != 0:
            print(f"Objcopy failed for {test_file}")

        
testdata = [os.path.abspath(f) for f in glob.glob("testdata/*.hex")]
print(testdata)

for testDataFile in testdata:


    xsimResult = subprocess.run(["xsim", "cpu_sim", "-R", "-testplusarg", f"MEMFILE={testDataFile}"], cwd="./build", capture_output=True, text=True)
    print(f"Running simulation with test data file: {testDataFile}")
    print(xsimResult.stdout)
    count += 1
    print(f"Completed simulation {count}/{len(testdata)}")



print(f"Completed all simulations. Total simulations run: {count}/{len(testdata)}")
