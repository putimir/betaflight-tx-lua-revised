# betaflight-tx-lua-revised
Various enhancements to the typical betaflight-tx-lua-scripts design.  Borrowed some existing code, but added more features and improved memory management.  Currently only implemented for the X9 series transmitters.

## v1.0-rc1 Released!
The scripts have hit a fairly significant milestone.  The v1.0-rc1 is now available for download and testing.  Until a stable release can be completed, this code is currently in core development, so expect there to be occasional issues that need resolution.  If you encounter any problems, please open an issue and clearly describe the problem and any steps taken so that it can be reproduced.

### Changes in v1.0-rc1
* Code has been heavily dried out, enabling ease of maintenance and more rapid enhancements.
* Template logic has been decoupled from the UI layer and has been built into the screen template files.
* Transport layer is now based primarily on a common codebase.  Protocol specific configurations have been decoupled.
* The script adapts transparently between the CRSF and SmartPort protocols.  The same bf.lua script can be used as a telemetry page on both CRSF or SmartPort models.
* The standard Crossfire lua script seamlessly invokes the telemetry script, giving a one-stop-shop for Crossfire configuration.
* Creating templates for new transmitters is now easier than ever.  There is never a need to touch the common code when creating new or adjusting existing templates.  If you are interested in building screen templates for the X7 or Horus transmitters, feel free to reach out.

### Installing v1.0-rc1

If you are coming from a previous version, it's recommended to remove all files from previous installations.  Simply delete the entire /SCRIPTS/BF directory and delete CFX9.lua and/or SPX9.lua from your /SCRIPTS/TELEMETRY directory.

***If you are using CRSF, this script will only work on Betaflight 3.2.0-rc5 or greater!  Please download and flash Betaflight to a new version before continuing.***

!! IMPORTANT: DON'T COPY THE ENTIRE CONTENTS OF THIS REPOSITORY ONTO YOUR SDCARD !!

Navigate to the 'sdcard' directory and copy it's contents onto your Taranis.  If you do this correctly, the SCRIPTS directory will merge with your current SCRIPTS directory,  placing the scripts in their appropriate paths.  You will know if you did this correctly if the bf.lua file shows up in your /SCRIPTS/TELEMETRY directory.

The src directory is not required for use and is only available for maintenance of the code.

How to install:

Bootloader Method
1. Power off your Taranis X9D and power it back on in boot loader mode.
2. Connect a USB cable and open the SDCard drive on your computer.
3. Copy the contents of sdcard/SCRIPTS directory to the root of your SD Card. 
4. Unplug the USB cable and power cycle your Taranis.

Manual method
1. Power off your Taranis X9D and remove the battery.
2. Remove the SD Card and plug it into a computer
3. Copy the contents of the sdcard/SCRIPTS directory to the root of the SD card.
4. Reinsert your SD Card into the Taranis
5. Plug your battery back in and power up the Taranis.

If you copied the files correctly, you can now go into the telemetry screen setup page and set up SPX9 as a telemetry screen.


## Seeking Contributors 

I am currently seeking assistance on building screen templates for X7 and Horus transmitters.  I do not own them so I can't really test the development outside of a simulator.  If you'd like to take a stab at building some templates, feel free to submit pull reqeuests.
