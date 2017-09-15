# betaflight-tx-lua-revised
Various enhancements to the typical betaflight-tx-lua-scripts design.  Borrowed some existing code, but added more features and improved memory management.  Currently only implemented for the X9 series transmitters.

This branch is for the Crossfire (CRSF) version!  [Click here for the SmartPort Branch.](https://github.com/codecae/betaflight-tx-lua-revised)

### This script will only work on Betaflight 3.2.0-rc5 or greater!  Please download and flash Betaflight to a new version before continuing.  

#### It has also been reported that using diffs from previous versions for automating settings restoration may cause unexpected issues.  It is recommended to set up your quad from scratch to ensure that the state of the FC is consistent with the new version.

***This code is currently in core development, so expect there to be occasional issues that need resolution.  If you encounter any problems, please open an issue and clearly describe the problem and any steps taken so that it can be reproduced.***

!! IMPORTANT: DON'T COPY THE ENTIRE CONTENTS OF THIS REPOSITORY ONTO YOUR SDCARD !!

Navigate to the 'sdcard' directory and copy the CROSSFIRE and SCRIPTS directories onto your Taranis.  If you do this correctly, the directories will merge with the existing ones, placing the scripts in their appropriate paths.  You will know if you did this correctly if the CFX9.lua file shows up in your /SCRIPTS/TELEMETRY directory.

The src directory is not required for use and is only available for maintenance of the code.

How to install:

Bootloader Method
1. Power off your Taranis X9D and power it back on in boot loader mode.
2. Connect a USB cable and open the SD card drive on your computer.
3. Copy the contents of sdcard directory to the root of your SD Card. 
4. Unplug the USB cable and power cycle your Taranis.

Manual method
1. Power off your Taranis X9D and remove the battery.
2. Remove the SD card and plug it into a computer.
3. Copy the contents of the sdcard directory to the root of the SD card.
4. Reinsert your SD Card into the Taranis.
5. Plug your battery back in and power up the Taranis.

If you copied the files correctly, you can now go into the telemetry screen setup page and set up SPX9 as a telemetry screen.
