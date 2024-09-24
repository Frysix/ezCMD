@echo off
setlocal enabledelayedexpansion
for /f "usebackq delims=" %%a in ("%~dp0\ver\ver.txt") do (
    set "ver=%%a"
    goto :menuinit)
	
:menuinit
for /f "usebackq delims=" %%a in ("%~dp0\config\slots\n_slot_a.txt") do (
    set "n_slot_a=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\config\slots\n_slot_s.txt") do (
    set "n_slot_s=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\config\slots\n_slot_d.txt") do (
    set "n_slot_d=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\config\slots\n_slot_f.txt") do (
    set "n_slot_f=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\config\slots\n_slot_g.txt") do (
    set "n_slot_g=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\config\slots\n_slot_h.txt") do (
    set "n_slot_h=%%a"
	goto menu
	))))))
:menu
set choice=""
cls
echo [92m***********************[0m
echo  [96mWelcome to ezCMD [91m%ver%[0m
echo [92m***********************[0m
echo [30m.[0m     
echo      [95mChoose an option:
echo [30m.[0m  
echo [92m-------------------------[30m......[0m[92m-------------------------[0m
echo [91m[1][0m [96mOS Corruption Check[0m        [91m[5][0m [96m[0m
echo [92m-------------------------[30m......[0m[92m-------------------------[0m
echo [91m[2][0m [96mGen Battery Report[0m         [91m[6][0m [96mW.I.P.[0m
echo [92m-------------------------[30m......[0m[92m-------------------------[0m
echo [91m[3][0m [96mUsers Tool[0m                 [91m[7][0m [96m[0m
echo [92m-------------------------[30m......[0m[92m-------------------------[0m
echo [91m[4][0m [96mGet System Info[0m            [91m[8][0m [96m[0m
echo [92m-------------------------[30m......[0m[92m-------------------------[0m
echo [30m.[0m
echo         [95mShortcuts: W.I.P.
echo [30m.[0m
echo [91m[a] [96m%n_slot_a%          [91m[d] [96m%n_slot_d%          [91m[g] [96m%n_slot_g%
echo [30m.[0m
echo [91m[s] [96m%n_slot_s%          [91m[f] [96m%n_slot_f%          [91m[h] [96m%n_slot_h%
echo [30m.[0m
echo [30m.[0m
echo [91m[q] [96mExit[0m             [91m[0] [96mSettings[0m
echo [30m.[91m
set /p choice=Type the character followed by Enter : 
if /i "%choice%"=="1" GOTO one
if /i "%choice%"=="2" GOTO two
if /i "%choice%"=="3" GOTO three
if /i "%choice%"=="4" GOTO four
if /i "%choice%"=="5" GOTO five
if /i "%choice%"=="6" GOTO apps
if /i "%choice%"=="7" GOTO seven
if /i "%choice%"=="8" GOTO eight
if /i "%choice%"=="0" GOTO settingsinit
if /i "%choice%"=="q" GOTO end
if /i "%choice%"=="" GOTO menu
if /i "%choice%"=="69" GOTO secret
if /i "%choice%"=="a" GOTO slot_a
if /i "%choice%"=="s" GOTO slot_s
if /i "%choice%"=="d" GOTO slot_d
if /i "%choice%"=="f" GOTO slot_f
if /i "%choice%"=="g" GOTO slot_g
if /i "%choice%"=="h" GOTO slot_h
GOTO menu
:slot_a
start %a_slot_a%
goto menuinit
:slot_s
start %a_slot_s%
goto menuinit
:slot_d
start %a_slot_d%
goto menuinit
:slot_f
start %a_slot_f%
goto menuinit
:slot_g
start %a_slot_g%
goto menuinit
:slot_h
start %a_slot_h%
goto menuinit

:settingsinit
for /f "usebackq delims=" %%a in ("%~dp0\config\autoup.txt") do (
    set "autoup=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\config\autocheck.txt") do (
    set "autocheck=%%a"
goto settings
))
:settings
set settings=""
cls
echo [92m***********************[0m
echo        [96mezCMD[0m [91m%ver%[0m
echo [92m***********************[0m
echo [30m.[0m     
echo                  [95mSettings 
echo [30m.[0m  
echo [92m-------------------------[30m......[92m-------[0m
echo [91m[1][0m [96mAuto Update[0m                 [95m%autoup%[0m
echo [92m-------------------------[30m......[92m-------[0m
echo [91m[2][0m [96mW.I.P.[0m               [95m%autocheck%[0m
echo [92m-------------------------[30m......[92m-------[0m
echo [91m[3][0m [96m[0m                 [95m[0m
echo [92m-------------------------[30m......[92m-------[0m
echo [91m[4][0m [96m[0m                 [95m[0m
echo [92m-------------------------[30m......[92m-------[0m
echo [30m.[0m
echo [91m[q] [96mExit[0m             [91m[0] [96mBack[0m
echo [30m.[91m
set /p settings=Type the character followed by Enter : 
if /i "%settings%"=="1" GOTO autoup
if /i "%settings%"=="2" GOTO autocheckconfirm
if /i "%settings%"=="" GOTO settings
if /i "%settings%"=="q" GOTO exit
if /i "%settings%"=="0" GOTO menu
goto settingsinit
:autoup
if "!autoup!"=="true" (
del /f "%~dp0\config\autoup.txt"
echo false> "%~dp0\config\autoup.txt"
) else ( 
del /f "%~dp0\config\autoup.txt"
echo true> "%~dp0\config\autoup.txt"
)
goto settingsinit
:autocheckconfirm
set autocheckyn=""
cls
echo [92m***********************[0m
echo        [96mezCMD[0m [91m%ver%[0m
echo [92m***********************[0m
echo [30m.[0m
echo [96mAre you sure you want to change the checkup setting?
echo [30m.[0m
echo [96mIf the setting is true an installation checkup will start the next time the script launches.
echo [30m.[91m
set /p autocheckyn=Type [Y] for YES or [N] for NO followed by Enter : 
if /i "%autocheckyn%"=="Y" GOTO autocheck
if /i "%autocheckyn%"=="y" GOTO autocheck
if /i "%autocheckyn%"=="N" GOTO settings
if /i "%autocheckyn%"=="n" GOTO settings
if /i "%autocheckyn%"=="" GOTO autocheckconfirm
:autocheck
if "!autocheck!"=="true" (
del /f "%~dp0\config\autocheck.txt"
echo false> "%~dp0\config\autocheck.txt"
) else ( 
del /f "%~dp0\config\autocheck.txt"
echo true> "%~dp0\config\autocheck.txt"
)
goto settingsinit

:one
cls
echo [92m***********************[0m
echo   [96mOS Corruption Fix[0m
echo [92m***********************[0m
echo [30m.[0m
echo [95mLaunching chkdsk[0m
chkdsk /f
cls
echo [92m***********************[0m
echo   [96mOS Corruption Fix[0m
echo [92m***********************[0m
echo [30m.[0m
echo [95mLaunching DISM[0m
dism /online /cleanup-image /checkhealth
cls
echo [92m***********************[0m
echo   [96mOS Corruption Fix[0m
echo [92m***********************[0m
echo [30m.[0m
echo [92mDone![0m
echo [95mLaunching Sfc/Scannow[0m
sfc/scannow
:test
cls
echo [92m***********************[0m
echo   [96mOS Corruption Fix[0m
echo [92m***********************[0m
echo [30m.[0m
echo [92mDone![0m
echo [95mLaunching Powershell script to retrieve GPUid[0m
mkdir %~dp0\gen\misc
del /f "%~dp0\config\task.txt"
echo getpnp> "%~dp0\config\task.txt"
powershell -executionpolicy bypass -file "%~dp0\Backend.ps1"
if %ERRORLEVEL% NEQ 0 GOTO menu
for /f "usebackq delims=" %%a in ("%~dp0\gen\misc\gpuid.txt") do (
    set "gpuid=%%a"
    goto :gotid)
:gotid
cls
echo [92m***********************[0m
echo   [96mOS Corruption Fix[0m
echo [92m***********************[0m
echo [30m.[0m
echo [92mRetrieved![0m
echo [95mResetting GPU drivers[0m
pnputil /disable-device "%gpuid%"
pnputil /enable-device "%gpuid%"
timeout /t 2 >nul /nobreak
rd /s /q %~dp0\gen\misc
cls
echo [92m***********************[0m
echo   [96mOS Corruption Fix[0m
echo [92m***********************[0m
echo [30m.[0m
echo [92mDone![0m
echo [95mResetting file explorer[0m
taskkill /im "explorer.exe" /f
timeout /t 2 >nul /nobreak
start explorer.exe
cls
echo [92m***********************[0m
echo   [96mOS Corruption Fix[0m
echo [92m***********************[0m
echo [30m.[0m
echo [92mDone![0m
pause
GOTO menu

:two
cls
echo [92m***********************[0m
echo   [96mGen Battery Report[0m
echo [92m***********************[0m
echo [95mLaunching Battery Report Generation[0m
powercfg /batteryreport
start battery-report.html
echo [30m.[0m
echo [92mDone![0m
echo [30m.[0m
echo [30m.[0m
pause
del battery-report.html
GOTO menu

:three
set userstool=
cls
echo [92m***********************[0m
echo     [96mUsers Tool[0m
echo [92m***********************[0m
echo [30m.[0m
echo [92m-----------------------[0m
echo [91m[1][0m [96mAdd User[0m
echo [92m-----------------------[0m
echo [91m[2][0m [96mRemove User[0m
echo [92m-----------------------[0m
echo [91m[3][0m [96mPromote User[0m
echo [92m-----------------------[0m
echo [91m[4][0m [96mActivate Admin[0m
echo [92m-----------------------[0m
echo [91m[5][0m [96mBack[0m
echo [92m-----------------------[95m
net user
echo [30m.[0m
echo [30m.[91m
set /p userstool=Type the character followed by Enter : 
if /i "%userstool%"=="1" GOTO adduser
if /i "%userstool%"=="2" GOTO remuser
if /i "%userstool%"=="3" GOTO upuser
if /i "%userstool%"=="4" GOTO addmin
if /i "%userstool%"=="5" GOTO menu
GOTO three
:adduser
cls
echo [92m***********************[0m
echo     [96mUsers Tool[0m
echo [92m***********************[0m
echo [95mCreating new user[0m
echo [30m.[91m
set /p addname= Input the name of the User :  
net user %addname% /add
echo [30m.[0m
echo [30m.[0m
pause
GOTO three
:remuser
cls
echo [92m***********************[0m
echo     [96mUsers Tool[0m
echo [92m***********************[0m
echo [95mRemoving user[0m
echo [30m.[91m
set /p remname= Input the name of the User : 
net user %remname% /delete
echo [30m.[0m
echo [30m.[0m
pause
GOTO three
:upuser
cls
echo [92m***********************[0m
echo     [96mUsers Tool[0m
echo [92m***********************[0m
echo [95mPromoting user[0m
echo [30m.[91m
set /p upname= Input the name of the User : 
echo [30m.[91m
echo [95mTrying French[0m
net localgroup administrateurs %upname% /add
echo [95mTrying English[0m
net localgroup administrators %upname% /add
echo [30m.[0m
echo [30m.[0m
pause
GOTO three
:addmin
echo [92m***********************[0m
echo     [96mUsers Tool[0m
echo [92m***********************[0m
echo [95mActivating admin user[0m
echo [30m.[91m
echo [95mTrying French[0m
net user administrateur /active:yes
echo [95mTrying English[0m
net user administrator /active:yes
echo [30m.[0m
echo [30m.[0m
pause
GOTO three

:four
mkdir %~dp0\gen\systeminfo
cls
echo [92m***********************[0m
echo      [96mSystem Info[0m
echo [92m***********************[0m
echo [95mLaunching system info gathering powershell script![0m
echo [30m.[0m
echo systeminfo> "%~dp0\config\task.txt"
powershell -executionpolicy bypass -file "%~dp0\Backend.ps1"
if %ERRORLEVEL% NEQ 0 GOTO menu
echo [92mDone![0m
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\pcmodel.txt") do (
    set "pcmodel=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\os.txt") do (
    set "os=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\osver.txt") do (
    set "osver=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\cpu.txt") do (
    set "cpu=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\cpucore.txt") do (
    set "cpucore=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\cpucore.txt") do (
    set "cputhreads=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\cpuclock.txt") do (
    set "cpuclock=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\cpubrand.txt") do (
    set "cpubrand=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\gpu.txt") do (
    set "gpu=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\vram.txt") do (
    set "vram=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\mobomanufacturer.txt") do (
    set "mobomanufacturer=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\mobomodel.txt") do (
    set "mobomodel=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\rambrand.txt") do (
    set "rambrand=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\ramfrequency.txt") do (
    set "ramfrequency=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\ramsize.txt") do (
    set "ramsize=%%a"
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\ramsticknumber.txt") do (
    set "ramsticknumber=%%a"
goto infodisplay
	))))))))))))))))
:infodisplay
set /a stickmem=%ramsize% / %ramsticknumber%
cls
echo [92m***********************[0m
echo      [96mSystem Info[0m
echo [92m***********************[0m
echo [30m.[0m
echo [95mPC name:[92m     /  [96m%computername%[0m
echo [92m------------ / ---------------------------------------------[0m
echo [91mPC model:[92m    /  [96m%pcmodel%[0m      
echo [92m------------ / ---------------------------------------------[0m
echo [91mOS:[92m          /  [96m%os%[0m      
echo [92m------------ / ---------------------------------------------[0m   
echo [91mOS ver:[92m      /  [96m%osver%[0m      
echo [92m------------ / ---------------------------------------------[0m    
echo [30m.[0m
echo [30m.[0m
echo [95mCPU:[92m         /  [96m%cpu%[0m
echo [92m------------ / ---------------------------------------------[0m
echo [91mBrand:[92m       /  [96m%cpubrand%[0m      
echo [92m------------ / ---------------------------------------------[0m
echo [91mCores:[92m       /  [96m%cpucore%[0m      
echo [92m------------ / ---------------------------------------------[0m
echo [91mThreads:[92m     /  [96m%cputhreads%[0m      
echo [92m------------ / ---------------------------------------------[0m
echo [91mClock:[92m       /  [96m%cpuclock% [91mMhz[0m      
echo [92m------------ / ---------------------------------------------[0m
echo [30m.[0m
echo [30m.[0m
echo [95mGPU:[92m         /  [96m%Gpu%[0m
echo [92m------------ / ---------------------------------------------[0m
echo [91mVRAM:[92m        /  [96m%vram% [91mGB[0m      
echo [92m------------ / ---------------------------------------------[0m
echo [30m.[0m
echo [30m.[0m
echo [95mMotherboard:[92m /  [96m%mobomodel%[0m
echo [92m------------ / ---------------------------------------------[0m
echo [91mBrand:[92m       /  [96m%mobomanufacturer%[0m      
echo [92m------------ / ---------------------------------------------[0m
echo [30m.[0m
echo [30m.[0m
echo [95mRAM:[92m         /  [96m%rambrand%[0m
echo [92m------------ / ---------------------------------------------[0m
echo [91mUnit:[92m        /  [96m%ramsticknumber% [91mx [96m%stickmem% [91mGB[0m      
echo [92m------------ / ---------------------------------------------[0m
echo [91mTotal:[92m       /  [96m%ramsize% [91mGB[0m
echo [92m------------ / ---------------------------------------------[0m
echo [91mFrequency:[92m   /  [96m%ramfrequency% [91mMhz[0m
echo [92m------------ / ---------------------------------------------[0m
echo [30m.[0m
echo [30m.[0m
pause
del /q /f "%~dp0\gen\systeminfo\"
GOTO menu

:five
cls
echo [92m***********************[0m
echo    [96mDisk Tool[0m
echo [92m***********************[0m
echo [30m.[0m
echo [92m-----------------------[0m
echo [91m[1][0m [96mPreparation[0m
echo [92m-----------------------[0m
echo [91m[2][0m [96mFinalization[0m
echo [92m-----------------------[0m
echo [91m[3][0m [96mBack[0m
echo [92m-----------------------[0m
echo [30m.[91m
set /p pass=Type the character followed by Enter : 
if /i "%pass%"=="1" GOTO passprep
if /i "%pass%"=="2" GOTO passfinish
if /i "%pass%"=="3" GOTO menu
GOTO five

:apps
cls
echo [92m***********************[0m
echo        [96mezCMD[0m [91m%ver%[0m
echo [92m***********************[0m
echo [30m.[0m     
echo           [95mApps:
echo [30m.[0m  
echo [92m-------------------------
echo [91m[1][0m [96mAssign Shortcuts[0m
echo [92m-------------------------
echo [91m[2][0m [96mInstall Apps[0m
echo [92m-------------------------
echo [91m[3][0m [96mInstalled List[0m
echo [92m-------------------------
echo [91m[4][0m [96mStart App[0m
echo [92m-------------------------
echo [30m.[0m
echo [91m[q] [96mExit[0m             [91m[0] [96mBack[0m
echo [30m.[91m
set /p app=Type the character followed by Enter : 
if /i "%app%"=="1" GOTO assignshortcut
if /i "%app%"=="2" GOTO installapp
if /i "%app%"=="3" GOTO applist
if /i "%app%"=="4" GOTO startapp
if /i "%app%"=="" GOTO apps
if /i "%app%"=="q" GOTO exit
if /i "%app%"=="0" GOTO menuinit
GOTO apps
:assignshortcut
cls
echo [92m***********************[0m
echo        [96mezCMD[0m [91m%ver%[0m
echo [92m***********************[0m
echo [30m.[0m     
echo        [95mChoose an App:
echo [30m.[0m  
echo [91m[1][0m [96mFurMark
echo [91m[2][0m [96mBurn In Test
echo [91m[3][0m [96mPrime95
echo [91m[4][0m [96mThrottleStop
echo [91m[5][0m [96mHW Monitor
echo [91m[6][0m [96mHard Disk Sentinel
echo [91m[7][0m [96m
echo [91m[8][0m [96m
echo [91m[9][0m [96m
echo [91m[10][0m [96m
echo [91m[11][0m [96m
echo [91m[12][0m [96m
:installapp
:applist
:startapp


:seven
GOTO menu

:eight
GOTO menu

:secret
set secret=""
cls
echo [92m***********************[0m
echo        [96mezCMD[0m [91m%ver%[0m
echo [92m***********************[0m
echo [30m.[0m     
echo                    [95m Illegal Menu[92m
echo [92m-----------------------[30m......[0m[92m-----------------------[0m
echo [91m[1][0m [96mMassgrave[0m                [91m[5][0m [96m[0m
echo [92m-----------------------[30m......[0m[92m-----------------------[0m
echo [91m[2][0m [96mW.I.P.[0m             [91m[6][0m
echo [92m-----------------------[30m......[0m[92m-----------------------[0m
echo [91m[3][0m [96m[0m                         [91m[7][0m
echo [92m-----------------------[30m......[0m[92m-----------------------[0m
echo [91m[4][0m [96m[0m                         [91m[8][0m
echo [92m-----------------------[30m......[0m[92m-----------------------[0m
echo [30m.[91m
echo [91m[9] [96mback[0m
echo [30m.[0m
echo [30m.[91m
set /p secret=Type the character followed by Enter : 
if /i "%secret%"=="1" GOTO massgrave
if /i "%secret%"=="2" GOTO win11bypass
if /i "%secret%"=="3" GOTO 
if /i "%secret%"=="4" GOTO 
if /i "%secret%"=="5" GOTO 
if /i "%secret%"=="6" GOTO 
if /i "%secret%"=="7" GOTO 
if /i "%secret%"=="8" GOTO 
if /i "%secret%"=="9" GOTO menu
GOTO secret

:massgrave
cls
echo [92m***********************[0m
echo     [96mMassgrave[0m
echo [92m************************[0m
echo [95mLaunching Massgrave[0m
del /f "%~dp0\config\task.txt"
echo mgl> "%~dp0\config\task.txt"
powershell -executionpolicy bypass -file "%~dp0\Backend.ps1"
echo [92mMassgrave Launched![0m
echo [30m.[0m
echo [30m.[0m
pause
GOTO secret

:win11bypass
cls
echo [92m***********************[0m
echo      [96mWin11 bypass[0m
echo [92m***********************[0m
echo [95mLaunching Win11 bypass[0m
start %~dp0\11Bypass.cmd
echo [92mWin11 bypass Launched![0m
echo [30m.[0m
echo [30m.[0m
pause
GOTO secret

:end
exit