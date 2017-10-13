# betaflight-tx-lua-revised
Various enhancements to the typical betaflight-tx-lua-scripts design.  Borrowed some existing code, but added more features and improved memory management.  Currently only implemented for the X9 series transmitters.  Big thanks to Trappy, Remo, and Preston from TBS and Steffen Windoffer, Michael Keller, Martin Budden, and Petr Ledvina from Betaflight!  Your support along the way has been invaluable.  We wouldn't be able to have this without you.

## v1.0-rc2 Released!
The scripts have hit a fairly significant milestone.  The v1.0-rc2 is now available for download and testing.  Until a stable release can be completed, this code is currently in core development, so expect there to be occasional issues that need resolution.  If you encounter any problems, please open an issue and clearly describe the problem and any steps taken so that it can be reproduced.

### Changes in v1.0-rc1
* Code has been heavily dried out, enabling ease of maintenance and more rapid enhancements.
* Event-based template logic has been decoupled from the UI layer and has been built into the screen template files.
* Transport layer is now based primarily on a common codebase.  Protocol specific configurations have been decoupled.
* The script adapts transparently between the CRSF and SmartPort protocols.  The same bf.lua script can be used as a telemetry page on both CRSF or SmartPort models.
* The standard Crossfire lua script seamlessly invokes the telemetry script, giving a one-stop-shop for Crossfire configuration.
* Creating templates for new transmitters is now easier than ever.  There is never a need to touch the common code when creating new or adjusting existing templates.  If you are interested in building screen templates for the X7 or Horus transmitters, feel free to reach out.
### Changes in v1.0-rc2
* Corrected FrSky Buffer Sizes
* Added RX screen
* Corrected issue with range of idle offset

## Installing

If you are coming from a previous version, it's recommended to remove all files from previous installations.  Simply delete the entire /SCRIPTS/BF directory and delete CFX9.lua and/or SPX9.lua from your /SCRIPTS/TELEMETRY directory.

***There are a lot of firmware versions floating around causing some confusion.  If you are running Betaflight 3.2.0 stable, at the time of this update (13-Oct-17) you must be running Crossfire firmware 2.11 in order to reliably use these scripts.  If you are running newer versions of Betaflight (3.2.1 or greater), you can reliably use these scripts from Crossfire version 2.06 or greater.***

!! IMPORTANT: DON'T COPY THE ENTIRE CONTENTS OF THIS REPOSITORY ONTO YOUR SDCARD !!

Navigate to the 'sdcard' directory and copy its contents onto your Taranis.  If you do this correctly, the SCRIPTS and CROSSFIRE directories will merge with your existing directories, placing the scripts in their appropriate paths.  You will know if you did this correctly if the bf.lua file shows up in your /SCRIPTS/TELEMETRY directory.

The src directory is not required for use and is only available for maintenance of the code.

How to install:

Bootloader Method
1. Power off your transmitter and power it back on in boot loader mode.
2. Connect a USB cable and open the SD card drive on your computer.
3. Copy the contents of sdcard directory to the root of your SD card. 
4. Unplug the USB cable and power cycle your transmitter.

Manual method (varies, based on the model of your transmitter)
1. Power off your transmitter.
2. Remove the SD card and plug it into a computer
3. Copy the contents of the sdcard directory to the root of the SD card.
4. Reinsert your SD card into the transmitter
5. Power up your transmitter.

If you copied the files correctly, you can now go into the telemetry screen setup page and set up the script as telemetry page.

## Adding the script as a telemetry page
Setting up the script as a telemetry page will enable access at the press of a button. (For now, this only applies to the Taranis X9D series).
1. Hit the [MENU] button and select the model for which you would like to enable the script.
2. While on the [MODEL SELECTION] screen, long-press the [PAGE] button to navigate to the [DISPLAY] page. 
3. Use the [-] button to move the cursor down to [Screen 1] and hit [ENT].
4. Use the [+] or [-] buttons to select the [Script] option and press [ENT].
5. Press [-] to move the cursor to the script selection field and hit [ENT].
6. Select 'bf' and hit [ENT].
7. Long-press [EXIT] to return to your model screen.

To invoke the script, simply long-press the [PAGE] button from the model screen.

## Invoking from the OpenTX Crossfire configuration script
This package contains a slight modification to the standard OpenTx crossfire.lua script that will load the configuration pages while configuring your Crossfire devices.
1. From your model screen, long-press [MENU] to reveal the [RADIO SETUP] screen.
2. Press the [PAGE] button to open the [SD CARD] browser.
3. Navigate to the [CROSSFIRE] directory using [-] or [+] and press [ENT].
4. Navigate to the 'crossfire.lua' file, long-press [ENT], and select [Execute] by pressing [ENT].

If your flight controller is running the proper firmware, you will see 'Betaflight X.X.X: ABCD' in the list of Crossfire devices, where X.X.X is the Betaflight version (3.2.0 or greater) and ABCD is the board identifier (ie. BFF3 for Betaflight F3).

Select this device by pressing [-] or [+], press [ENT] and the configuration pages will load.  To exit back to the device list, hit the [EXIT] button at any time.

## Seeking Contributors 

I am currently seeking assistance on building screen templates for X7 and Horus transmitters.  I do not own them so I can't really test the development outside of a simulator.  If you'd like to take a stab at building some templates, feel free to submit pull reqeuests.
