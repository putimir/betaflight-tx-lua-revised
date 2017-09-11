# betaflight-tx-lua-revised
Various enhancements to the typical betaflight-tx-lua-scripts design.  Borrowed some existing code, but added more features and improved memory management.  Currently only implemented for the X9 series transmitters.

!! IMPORTANT: DON'T COPY THE ENTIRE CONTENTS OF THIS REPOSITORY ONTO YOUR SDCARD !!

Navigate to the 'sdcard' directory and copy ONLY the SCRIPTS directory onto your Taranis.  If you do this correctly, the SCRIPTS directory will merge with your current SCRIPTS directory,  placing the scripts in their appropriate paths.  You will know if you did this correctly if the SPX9.lua file shows up in your /SCRIPTS/TELEMETRY directory.

The src directory is not required for use and is only available for maintenance of the code.

How to install:

Bootloader Method
1. Power off your Taranis X9D and power it back on in boot loader mode.
2. Connect a USB cable and open the SDCard drive on your computer.
3. Copy the sdcard/SCRIPTS directory to the root of your SD Card. 
4. Unplug the USB cable and power cycle your Taranis.

Manual method
1. Power off your Taranis X9D and remove the battery.
2. Remove the SD Card and plug it into a computer
3. Copy the contents of the scard/SCRIPTS directory to the root of the SD card.
4. Reinsert your SD Card into the Taranis
5. Plug your battery back in and power up the Taranis.

If you copied the files correctly, you can now go into the telemetry screen setup page and set up SPX9 as a telemetry screen.
