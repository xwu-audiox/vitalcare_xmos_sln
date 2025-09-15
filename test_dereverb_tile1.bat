@echo off
echo Testing dereverb placement in Tile 1...
echo.

echo Building dereverb library...
cd build
ninja fwk_voice_module_lib_dereverb
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to build dereverb library
    exit /b 1
)
echo.

echo Building FFVA target with dereverb in Tile 1...
ninja example_ffva_ua_adec_dereverb_altarch
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to build FFVA target
    exit /b 1
)
echo.

echo SUCCESS: Build completed successfully!
echo.
echo Audio pipeline flow:
echo Tile 1: Mic -^> AEC -^> Dereverb -^> Send to Tile 0
echo Tile 0: IC+VNR (using AEC output for features) -^> NS -^> AGC -^> Output
echo.
echo VNR features are extracted from AEC output (before dereverb) to avoid threshold drift
echo.
echo Ready for flashing with: xflash --target-file examples/ffva/src/app_example_ffva_ua_adec_dereverb_altarch.xn --boot-partition-size 0x100000 --data example_ffva_ua_adec_dereverb_altarch.bin

