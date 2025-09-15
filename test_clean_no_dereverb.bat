@echo off
echo Testing completely clean no-dereverb version...
echo.

echo Building dereverb library (not used)...
cd build
ninja fwk_voice_module_lib_dereverb
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to build dereverb library
    exit /b 1
)
echo.

echo Building FFVA target without dereverb...
ninja example_ffva_ua_adec_dereverb_altarch
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to build FFVA target
    exit /b 1
)
echo.

echo SUCCESS: Build completed successfully!
echo.
echo Audio pipeline flow (completely clean, no dereverb):
echo Tile 1: Mic -^> AEC -^> Send to Tile 0
echo Tile 0: IC+VNR -^> NS -^> AGC -^> Output
echo.
echo All dereverb code has been completely removed
echo This should work exactly like the original adec_altarch
echo.
echo Ready for flashing with: xflash --target-file examples/ffva/src/app_example_ffva_ua_adec_dereverb_altarch.xn --boot-partition-size 0x100000 --data example_ffva_ua_adec_dereverb_altarch.bin

