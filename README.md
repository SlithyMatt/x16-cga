# x16-cga
CGA palette for X16 with utilities and demos using it. Build scripts require bash shell to run. If on Windows, using the Git bash shell is recommended.

# Palette

Indices 0-15 (Full 16-color Palette, aka PC-Jr. or Tandy): black,blue,green,cyan,red,magenta,brown,lt. gray,dk. gray,lt. blue,lt. green,lt. cyan,lt. red,lt. magenta,yellow,white

Offset 1, indices 16-19 (CGA Mode 4 Palette 0, low intensity): black,green,red,brown

Offset 2, indices 32-35 (CGA Mode 4 Palette 0, high intensity): black,lt. green,lt. red,yellow

Offset 3, indices 48-51 (CGA Mode 4 Palette 1, low intensity): black,cyan,magenta,lt. gray

Offset 4, indices 64-67 (CGA Mode 4 Palette 1, high intensity): black,lt. cyan,lt. magenta,white

Offset 5, indices 80-83 (CGA Mode 5 Palette, low intensity): black,cyan,red,lt. gray

Offset 6, indices 96-99 (CGA Mode 5 Palette, high intensity): black,lt. cyan,lt. red,white

Offset 7, indices 112-115: low intensity green-scale

Offset 8, indices 128-131: high intensity green-scale

Offset 9, indices 144-147: low intensity amber-scale

Offset 10, indices 160-163: high intensity amber-scale

Offsets 11-15, indices 176-255: Spare

# Tools, Demos, and Data

**build_tools.sh** -
Build the toolchain for generating CGA graphics demos on the X16.

**build_prg.sh** -
Builds an X16 PRG file from a raw image data file. You can use GIMP to export an indexed image file (GIF or PNG) to this format (*.data).

You can use the sample data files in this repo to create an example PRG to view an image as an X16 bitmap.

Example:

<pre>  ./build_prg.sh x16cga640.data 640 2 4</pre>

The arguments are as follows: raw data file name, bitmap width (must be 640 or 320), color bit depth (must be 2 or 4), palette offset (must be between 0 and 15)

Please note that 2-bit color means 4 color values and 4-bit color (CGA palette) means 16 color values (all available CGA colors).

The palette offset argument is optional. 2-bit bitmaps will default to palette offset 1 (black/green/red/brown). 4-bit bitmaps will default to palette offset 0. Please note that at this time, palette offset 0 is the only full 16-color offset. Selecting any other offset with a 4-bit bitmap will likely result in a mostly black image.

**cga.bas** -
A BASIC script that can be loaded and run within X16 BASIC to change to the CGA palette.

# Running in X16 Emulator
PRG files built with this project can be autoloaded and run by the X16 emulator.

Example:

<pre>  path/to/x16emu -prg x16cga640.prg -run</pre>
  
This will fill the emulator screen with the image. The program runs in an infinite loop after loading the image, so the emulator will need to be shut down or restarted to stop it. Note that the display is scaled up 2x to make a 320 pixel-wide bitmap fill it.

**x16cga320.data** -
A raw export of **x16cga320.png**, which is a 4-color 320x240 bitmap. The PNG uses what would be palette offset 4. However, you can use build_prg.sh to load it into the X16 with any of the emulated CGA palettes (even the first four colors of offset 0).

**x16cga640.data** -
A raw export of **x16cga640.png**, which is a 4-color 640x480 bitmap. The PNG uses what would be palette offset 4.

**x16tga.data** -
A raw export of **x16tga.png**, which is a 16-color 320x240 bitmap. The PNG uses the PCJr/Tandy 16-color palette, which is palette offset zero with this toolchain.

# Note on VERA limitations
While this toolchain supports creating a 4-bit 640x480 bitmap, by default VERA does not have enough VRAM to support that, so it will fail at runtime, unless bank 2 of VRAM is enabled for a special emulator build. Most likely, the actual X16 hardware will only have VRAM banks 0 and 1 available to the user.

In order to not interfere with text on layer 0, the bitmap is loaded into VRAM starting at $04000. This means that a 4-bit bitmap that is 640 pixels wide could only be up to 358 pixels high.
