# learn-stm32

This is a repository I'm logging all of my work with my STM32F722ZE Nucleo
board.

## Getting started

### Requirements

- Python 3.8 or later

### Initialisation

Create a workspace directory, enter it, and clone this repository.

Enter the `stm32-sdk` directory and install the python requirements from
requirements.txt.

`python -m pip install -r scripts/requirements.txt`

Run the initialisation script from the base directory.

`python scripts/init.py`

Run the env script to set up your environment.

`./scripts/env.ps1`

## Building a project

Run the build script to build a project.

`python build.py -a path/to/your/project -d path/to/you/build/directory`

## Running a project

Download the stlink tool from here:

`https://www.st.com/en/development-tools/stsw-link004.html#st-get-software`

Run the following command to program the board.

`ST-LINK_CLI.exe -c -P ./path/to/your/build/dir/project_name.hex -V -Run`

## Useful things (mainly for me)

### MIDI UART

I use USART1 for MIDI output. TX is PB6, this is CN10 pin 13. This pin connects
to the red wire on my MIDI cable through a 100ohm resistor. The shield pin
connects to ground. The yellow pin connects to 3.3v through a 220ohm resistor.
