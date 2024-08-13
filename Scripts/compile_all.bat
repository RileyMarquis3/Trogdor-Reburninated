@echo off

:: Manual sleep amounts (because `start /wait` doesn't work...)
set SLEEP_COMPILE=45
set SLEEP_COMPILE_SHORT=5
set SLEEP_CLEAN=2

:: Path: repo (the folder that contains /src)
set REPO=D:/GitHub/Trogdor-Reburninated/Trogdor-Reburninated
set REPO_DKP=/d/GitHub/Trogdor-Reburninated/Trogdor-Reburninated
set REPO_WSL=/mnt%REPO_DKP%
set REPO_MSYS=%REPO_DKP%
set OUTPUT_DIR=%REPO%/dist/new_version/Trogdor-Reburninated
set RELEASE_RESOURCES=%REPO%/release-resources

:: Path: devkitPro
set DEVKITPRO=C:/devkitPro/msys2/mingw64.exe

:: Path: msys2
set MSYS=C:/msys64/mingw64.exe

:: Path: Makefile directory
set MAKEFILES_DKP=%REPO_DKP%/Makefiles
set MAKEFILES_MSYS=%MAKEFILES_DKP%
set MAKEFILES_WSL=/mnt%MAKEFILES_DKP%

:: Path: 3DS CIA Utilities
set BANNERTOOL="D:/Utilities/3DS CIA Creation/bannertool"
set MAKEROM="D:/Utilities/3DS CIA Creation/makerom-v0.18.3-win_x86_64/makerom.exe"
set VERSION_3DS=545



:: Makefile: Windows x64
set MAKEFILE_MSYS_WINDOWS=%MAKEFILES_MSYS%/Makefile_pc
set OUTPUT_WINDOWS=%OUTPUT_DIR%-x64/Trogdor-Reburninated.exe

:: Makefile: Windows x86
set MAKEFILE_MSYS_WINDOWS_X86=%MAKEFILES_MSYS%/Makefile_pc_x86
set OUTPUT_WINDOWS_x86=%OUTPUT_DIR%-x86/Trogdor-Reburninated.exe

:: Makefile: Linux
set MAKEFILE_WSL_LINUX=%MAKEFILES_WSL%/Makefile_linux
set OUTPUT_LINUX=%OUTPUT_DIR%-linux/Trogdor-Reburninated

:: Makefile: Gamecube
set MAKEFILE_DKP_GC=%MAKEFILES_DKP%/Makefile_gc
set OUTPUT_GC=%OUTPUT_DIR%-gamecube/Trogdor-RB/boot.dol

:: Makefile: Wii
set MAKEFILE_DKP_WII=%MAKEFILES_DKP%/Makefile_wii
set OUTPUT_WII=%OUTPUT_DIR%-wii/apps/Trogdor-RB/boot.dol

:: Makefile: Wii U
set MAKEFILE_DKP_WII_U=%MAKEFILES_DKP%/make_wii_u.sh
set OUTPUT_WII_U=%OUTPUT_DIR%-wiiu/wiiu/apps/Trogdor-RB/Trogdor-Reburninated.rpx
set OUTPUT_WII_U_WUHB=%OUTPUT_DIR%-wiiu/wiiu/apps/Trogdor-Reburninated.wuhb

:: Makefile: Switch
set MAKEFILE_DKP_SWITCH=%MAKEFILES_DKP%/Makefile_switch
set OUTPUT_SWITCH=%OUTPUT_DIR%-switch/switch/Trogdor-RB/Trogdor-Reburninated.nro

:: Makefile: 3DS
set MAKEFILE_DKP_3DS=%MAKEFILES_DKP%/Makefile_3ds
set OUTPUT_3DS=%OUTPUT_DIR%-3ds/3ds/Trogdor-RB/Trogdor-Reburninated.3dsx
set OUTPUT_3DS_CIA=%OUTPUT_DIR%-3ds-cia/cias/Trogdor-Reburninated.cia

:: Makefile: PSP
set MAKEFILE_WSL_PSP=%MAKEFILES_WSL%/Makefile_psp
set OUTPUT_PSP=%OUTPUT_DIR%-psp/PSP/GAME/Trogdor-RB/EBOOT.PBP

:: Makefile: Vita
set MAKEFILE_WSL_VITA=%MAKEFILES_WSL%/make_vita.sh
set OUTPUT_VITA=%OUTPUT_DIR%-vita/VPK/Trogdor-Reburninated.vpk

:: Makefile: Xbox (original)
set MAKEFILE_WSL_XBOX=%MAKEFILES_WSL%/Makefile_xbox

:: Makefile: RG35XX
set MAKEFILE_WSL_RG35XX=%MAKEFILES_WSL%/make_rg35xx.sh



:: Running compilation commands...
call :compile_windows_x64
call :compile_windows_x86
call :compile_linux
call :compile_gc
call :compile_wii
call :compile_wii_u
call :compile_switch
call :compile_3ds
call :compile_vita
rem call :compile_rg35xx
rem call :compile_psp

echo Done.
goto :eof



:compile_windows_x64
echo Windows x64: Compiling with MSYS2...
start /wait "" %MSYS% /usr/bin/bash -lc "cd %REPO_MSYS%; make -f %MAKEFILE_MSYS_WINDOWS%"
sleep %SLEEP_COMPILE%
echo Windows x64: Moving compiled exe to %OUTPUT_WINDOWS%...
mv %REPO%/Trogdor-Reburninated.exe %OUTPUT_WINDOWS%
echo Windows x64: Cleaning up...
start /wait "" %MSYS% /usr/bin/bash -lc "cd %REPO_MSYS%; make clean -f %MAKEFILE_MSYS_WINDOWS%"
sleep %SLEEP_CLEAN%
echo.
goto :eof


:compile_windows_x86
echo Windows x86: Compiling with MSYS2...
start /wait "" %MSYS% /usr/bin/bash -lc "cd %REPO_MSYS%; make -f %MAKEFILE_MSYS_WINDOWS_X86%"
sleep %SLEEP_COMPILE%
echo Windows x86: Moving compiled exe to %OUTPUT_WINDOWS_X86%...
mv %REPO%/Trogdor-Reburninated.exe %OUTPUT_WINDOWS_X86%
echo Windows x86: Cleaning up...
start /wait "" %MSYS% /usr/bin/bash -lc "cd %REPO_MSYS%; make clean -f %MAKEFILE_MSYS_WINDOWS_X86%"
sleep %SLEEP_CLEAN%
echo.
goto :eof

:compile_linux
echo Linux: Compiling with WSL...
wsl -e sh -c "cd %REPO_WSL% && make -f %MAKEFILE_WSL_LINUX% > /dev/null 2>&1"
echo Linux: Moving compiled binary to %OUTPUT_LINUX%...
mv %REPO%/trogdorrb %OUTPUT_LINUX%
echo Linux: Cleaning up...
wsl -e sh -c "cd %REPO_WSL% && make clean -f %MAKEFILE_WSL_LINUX% > /dev/null 2>&1"
echo.
goto :eof

:compile_gc
echo Gamecube: Compiling with devkitPro...
:: make is run twice to get around a makefile issue
start /wait "" %DEVKITPRO% /usr/bin/bash -lc "cd %REPO_DKP%; make -f %MAKEFILE_DKP_GC%; make -f %MAKEFILE_DKP_GC%"
sleep %SLEEP_COMPILE%
echo Gamecube: Moving compiled dol to %OUTPUT_GC%...
mv %REPO%/boot.dol %OUTPUT_GC%
echo Gamecube: Cleaning up...
start /wait "" %DEVKITPRO% /usr/bin/bash -lc "cd %REPO_DKP%; make clean -f %MAKEFILE_DKP_GC%"
sleep %SLEEP_CLEAN%
echo.
goto :eof

:compile_wii
echo Wii: Compiling with devkitPro...
:: make is run twice to get around a makefile issue
start /wait "" %DEVKITPRO% /usr/bin/bash -lc "cd %REPO_DKP%; make -f %MAKEFILE_DKP_WII%; make -f %MAKEFILE_DKP_WII%"
sleep %SLEEP_COMPILE%
echo Wii: Moving compiled dol to %OUTPUT_WII%...
mv %REPO%/boot.dol %OUTPUT_WII%
echo Wii: Cleaning up...
start /wait "" %DEVKITPRO% /usr/bin/bash -lc "cd %REPO_DKP%; make clean -f %MAKEFILE_DKP_WII%"
sleep %SLEEP_CLEAN%
echo.
goto :eof

:compile_wii_u
echo Wii U: Compiling with devkitPro...
start /wait "" %DEVKITPRO% /usr/bin/bash -lc "cd %REPO_DKP%; sh %MAKEFILE_DKP_WII_U%"
sleep %SLEEP_COMPILE%
echo Wii U: Moving compiled rpx to %OUTPUT_WII_U%...
mv %REPO%/build_wii_u/trogdorrb.rpx %OUTPUT_WII_U%
echo Wii U: Creating WUHB in %OUTPUT_WII_U_WUHB%...
start /wait "" %DEVKITPRO% /usr/bin/bash -lc "wuhbtool %OUTPUT_WII_U% %OUTPUT_WII_U_WUHB% --name=\"Trogdor: Reburninated\" --short-name=\"Trogdor: Reburninated\" --author=Mode8fx --icon=%RELEASE_RESOURCES%/logo_icon_vita.png --tv-image=%RELEASE_RESOURCES%/splash_screen_wiiu_tv.png --drc-image=%RELEASE_RESOURCES%/splash_screen_wiiu_gamepad.png"
sleep %SLEEP_COMPILE_SHORT%
echo Wii U: Cleaning up...
rm -r %REPO%/build_wii_u
sleep %SLEEP_CLEAN%
echo.
goto :eof

:compile_switch
echo Switch: Compiling with devkitPro...
start /wait "" %DEVKITPRO% /usr/bin/bash -lc "cd %REPO_DKP%; make -f %MAKEFILE_DKP_SWITCH%"
sleep %SLEEP_COMPILE%
echo Switch: Moving compiled nro to %OUTPUT_SWITCH%...
mv %REPO%/Trogdor-Reburninated.nro %OUTPUT_SWITCH%
echo Switch: Cleaning up...
start /wait "" %DEVKITPRO% /usr/bin/bash -lc "cd %REPO_DKP%; make clean -f %MAKEFILE_DKP_SWITCH%"
sleep %SLEEP_CLEAN%
echo.
goto :eof

:compile_3ds
echo 3DS: Compiling with devkitPro...
start /wait "" %DEVKITPRO% /usr/bin/bash -lc "cd %REPO_DKP%; make -f %MAKEFILE_DKP_3DS%"
sleep %SLEEP_COMPILE%
echo 3DS: Moving compiled 3dsx to %OUTPUT_3DS%...
mv %REPO%/Trogdor-Reburninated.3dsx %OUTPUT_3DS%
echo 3DS: Creating CIA in %OUTPUT_3DS_CIA%...
%MAKEROM% -f cia -o %OUTPUT_3DS_CIA% -elf %REPO%/Trogdor-Reburninated.elf -icon %RELEASE_RESOURCES%/icon_3ds.smdh -banner %RELEASE_RESOURCES%/banner_3ds.bnr -ver %VERSION_3DS% -rsf %RELEASE_RESOURCES%/app_3ds.rsf
echo 3DS: Cleaning up...
start /wait "" %DEVKITPRO% /usr/bin/bash -lc "cd %REPO_DKP%; make clean -f %MAKEFILE_DKP_3DS%"
sleep %SLEEP_CLEAN%
echo.
goto :eof

:compile_vita
echo Vita: Compiling with WSL...
wsl -e sh -c "cd %REPO_WSL% && sh %MAKEFILE_WSL_VITA% > /dev/null 2>&1"
echo Vita: Moving compiled vpk to %OUTPUT_VITA%...
mv %REPO%/build_vita/trogdorrb.vpk %OUTPUT_VITA%
echo Vita: Cleaning up...
rm -r %REPO%/build_vita
echo.
goto :eof

:compile_rg35xx
echo RG35XX: Compiling with WSL...
wsl -e sh -c "cd %REPO_WSL% && sh %MAKEFILE_WSL_RG35XX% > /dev/null 2>&1"
echo RG35XX: Moving compiled binary to %OUTPUT_RG35XX%...
mv %REPO%/build_rg35xx/trogdorrb %OUTPUT_RG35XX%
echo RG35XX: Cleaning up...
rm -r %REPO%/build_rg35xx
echo.
goto :eof

:compile_psp
:: TODO: This doesn't work for some reason
echo PSP: Compiling with WSL...
wsl -e sh -c "cd %REPO_WSL% && make -f %MAKEFILE_WSL_PSP% > /dev/null 2>&1"
echo PSP: Moving compiled binary to %OUTPUT_PSP%...
mv %REPO%/trogdorrb %OUTPUT_PSP%
echo PSP: Cleaning up...
wsl -e sh -c "cd %REPO_WSL% && make clean -f %MAKEFILE_WSL_PSP% > /dev/null 2>&1"
echo.
goto :eof

:compile_xbox
:: (this doesn't work since ./activate breaks out of script)
rem echo Xbox: Compiling with WSL...
rem wsl -e sh -c "cd ~/nxdk/bin && ./activate && cd %REPO_WSL% && make -f %MAKEFILE_WSL_XBOX% > /dev/null 2>&1"
rem echo Xbox: Moving compiled binary to %OUTPUT_XBOX%...
rem mv %REPO%/build_xbox/trogdorrb %OUTPUT_XBOX%
rem echo.
goto :eof