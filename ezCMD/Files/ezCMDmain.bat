@echo off
setlocal
set ver=v0.04
GOTO menu

:menu
set choice=""
cls
echo [92m***********************[0m
echo  [96mWelcome to ezCMD [91m%ver%[0m
echo [92m***********************[0m
echo [30m.[0m     
echo                     [95mChoose an option  
echo [30m.[0m  
echo [92m-------------------------[30m......[0m[92m-------------------------[0m
echo [91m[1][0m [96mOS Corruption Check[0m        [91m[5][0m [96mDisk Tool[0m
echo [92m-------------------------[30m......[0m[92m-------------------------[0m
echo [91m[2][0m [96mGen Battery Report[0m         [91m[6][0m [96mReset Internet Config[0m
echo [92m-------------------------[30m......[0m[92m-------------------------[0m
echo [91m[3][0m [96mUsers Tool[0m                 [91m[7][0m [96m[0m
echo [92m-------------------------[30m......[0m[92m-------------------------[0m
echo [91m[4][0m [96mGet System Info[0m            [91m[8][0m [96m[0m
echo [92m-------------------------[30m......[0m[92m-------------------------[0m
echo [30m.[0m
echo [91m[9] [96mExit[0m
echo [30m.[91m
set /p choice=Type the number followed by Enter : 
if /i "%choice%"=="1" GOTO one
if /i "%choice%"=="2" GOTO two
if /i "%choice%"=="3" GOTO three
if /i "%choice%"=="4" GOTO four
if /i "%choice%"=="5" GOTO five
if /i "%choice%"=="6" GOTO six
if /i "%choice%"=="7" GOTO seven
if /i "%choice%"=="8" GOTO eight
if /i "%choice%"=="9" GOTO end
if /i "%choice%"=="" GOTO menu
if /i "%choice%"=="69" GOTO secret
GOTO menu

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
powershell -executionpolicy bypass -file "%~dp0\PNPretriever.ps1"
if %ERRORLEVEL% NEQ 0 GOTO menu
start %~dp0\gen\misc\gpuid.txt
for /f "usebackq delims=" %%a in ("%~dp0\gen\misc\gpuid.txt") do (
    set "gpuid=%%a"
    goto :gotid)
:gotid
taskkill /im "notepad.exe" /f
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
set /p userstool=Type the number followed by Enter : 
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
powershell -executionpolicy bypass -file "%~dp0\getsysteminfo.ps1"
if %ERRORLEVEL% NEQ 0 GOTO menu
echo [92mDone![0m
start %~dp0\gen\systeminfo\pcmodel.txt
start %~dp0\gen\systeminfo\os.txt
start %~dp0\gen\systeminfo\osver.txt
start %~dp0\gen\systeminfo\cpu.txt
start %~dp0\gen\systeminfo\cpucore.txt
start %~dp0\gen\systeminfo\gpu.txt
start %~dp0\gen\systeminfo\vram.txt
start %~dp0\gen\systeminfo\mobomanufacturer.txt
start %~dp0\gen\systeminfo\mobomodel.txt
start %~dp0\gen\systeminfo\rambrand.txt
start %~dp0\gen\systeminfo\ramfrequency.txt
start %~dp0\gen\systeminfo\ramsize.txt
start %~dp0\gen\systeminfo\ramsticknumber.txt
taskkill /im "notepad.exe" /f
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\pcmodel.txt") do (
    set "pcmodel=%%a"
    goto :os)
:os
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\os.txt") do (
    set "os=%%a"
    goto :osver)
:osver
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\osver.txt") do (
    set "osver=%%a"
    goto :cpu)
:cpu
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\cpu.txt") do (
    set "cpu=%%a"
    goto :cpucore)
:cpucore	
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\cpucore.txt") do (
    set "cpucore=%%a"
    goto :cpuclock)
:cpuclock
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\cpuclock.txt") do (
    set "cpuclock=%%a"
    goto :cpubrand)
:cpubrand
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\cpubrand.txt") do (
    set "cpubrand=%%a"
    goto :gpu)
:gpu
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\gpu.txt") do (
    set "gpu=%%a"
    goto :vram)
:vram
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\vram.txt") do (
    set "vram=%%a"
    goto :mobomanufacturer)
:mobomanufacturer
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\mobomanufacturer.txt") do (
    set "mobomanufacturer=%%a"
    goto :mobomodel)
:mobomodel
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\mobomodel.txt") do (
    set "mobomodel=%%a"
    goto :rambrand)
:rambrand
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\rambrand.txt") do (
    set "rambrand=%%a"
    goto :ramfrequency)
:ramfrequency
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\ramfrequency.txt") do (
    set "ramfrequency=%%a"
    goto :ramsize)
:ramsize
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\ramsize.txt") do (
    set "ramsize=%%a"
    goto :ramsticknumber)
:ramsticknumber
for /f "usebackq delims=" %%a in ("%~dp0\gen\systeminfo\ramsticknumber.txt") do (
    set "ramsticknumber=%%a"
    goto :scan_done)
:scan_done
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
rd /s /q "%~dp0\gen\systeminfo"
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
set /p pass=Type the number followed by Enter : 
if /i "%pass%"=="1" GOTO passprep
if /i "%pass%"=="2" GOTO passfinish
if /i "%pass%"=="3" GOTO menu
GOTO five

:six
GOTO menu

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
echo [91m[2][0m [96mWin11 Bypass[0m             [91m[6][0m
echo [92m-----------------------[30m......[0m[92m-----------------------[0m
echo [91m[3][0m [96m[0m                         [91m[7][0m
echo [92m-----------------------[30m......[0m[92m-----------------------[0m
echo [91m[4][0m [96m[0m                         [91m[8][0m
echo [92m-----------------------[30m......[0m[92m-----------------------[0m
echo [30m.[91m
echo [91m[9] [96mback[0m
echo [30m.[0m
echo [30m.[91m
set /p secret=Type the number followed by Enter : 
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
powershell -executionpolicy bypass -file "%~dp0\massgravelaunch.ps1"
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