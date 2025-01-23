# Skywater 130nm Analog/Digital IC Design Flow Demo 

This repository contains demos for the analog IC design flow (minus pads and fill, but enough for junior designers) and the digital IC design flow in Skywater 130nm technology with fully open-source tools.

The tools needed are all from [JKU's IIC OSIC TOOLS docker](https://github.com/iic-jku/IIC-OSIC-TOOLS/)

Inside the lab folders are more README files discussing the instructions for each lab.

# Structure

```
sky130_analog_digital_flow_demo
│   README.md
│   analog_demo.ipynb -- analog flow demo
│   digital_demo.ipynb -- digital flow demo
│
└───cs_amp -- analog amplifier design example
│   
└───processing_element -- digital processor design example
```

# Tools Installation
You need to install https://github.com/iic-jku/IIC-OSIC-TOOLS:

1. Download [Docker Desktop](https://www.docker.com/products/docker-desktop/) for your OS
    1. A requirement for Docker is WSL2 on windows. Follow the instructions [here](https://learn.microsoft.com/en-us/windows/wsl/install) to setup WSL2.
2. Start Docker Desktop
1. Open the terminal inside docker
3. In that `git clone --depth=1 https://github.com/iic-jku/iic-osic-tools.git`
    1. For windows users, if git is not found, run the following in the command prompt: `winget install --id Git.Git -e --source winget`
4. Change directory into the cloned directory: `cd iic-osic-tools`
5. Then, use `./start_x.sh`  (or `./start_x.bat`, if you’re on Windows)
    1. This part will take a while, as the PDKs and tools are downloaded.
6. You should now have a usable terminal with which you can call all the tools and follow the instructions.

This should show you a desktop environment with all of the requirements already installed.

If you are planning to edit files *outside* of this VNC environment (i.e. your host computer) for reasons like using your own text editor, make sure to perform all the projects in the directory `~/eda/designs` or `<HOME>/eda/designs`. This is the directory that is visible to the VNC.

For example, for me, I would clone all the repositories and make designs in `lquizon/eda/designs`. 

# Setup

1. Clone the demo files from the git
    1. `git clone https://github.com/Lawrence-lugs/sky130_analog_digital_flow_demo.git`
2. Enter the cloned directory, and enter the repo folder
    1. `cd sky130_analog_digital_flow_demo`
3. Follow the steps in either `analog_demo.ipynb` or `digital_demo.ipynb`
