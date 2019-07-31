:: 2016-04-20
:: Tessein -- simple batch archive script
:: compression level set to 1 for speed
:: multithreading turned off, might be faster

:: 2018-02-28
:: Tessein -- update for new laptop

:: 2018-03-05
:: documentation changes

:: 2018-03-13
:: Added remote copy and delete code

@echo OFF

SET MYREMOTEBACKUPDIR=X:\Backup
SET MYBACKUPDIR=c:\Users\ctessein\Desktop\Backup
SET MYARCHIVEDIR=%MYBACKUPDIR%\Archive

SET THELOGFN=%MYBACKUPDIR%\backup_log.txt

SET MYARCHIVER=%MYBACKUPDIR%\7za
SET EXCLUDEFILE=%MYBACKUPDIR%\exclude
SET INCLUDEFILE=%MYBACKUPDIR%\include

SET THEDATE=%DATE:~-4%-%DATE:~4,2%-%DATE:~7,2%

:: add leading 0 for hour < 10
SET HOUR=%TIME:~0,2%
IF "%HOUR:~0,1%" == " " (
  SET HOUR=0%HOUR:~1,1%
)
SET MINUTE=%TIME:~3,2%
SET SECOND=%TIME:~6,2%
SET THETIME=%HOUR%-%MINUTE%-%SECOND%

SET THEARCHIVEFN=%THEDATE%_%THETIME%.blob
SET MYARCHIVEFULLPATH=%MYARCHIVEDIR%\%THEARCHIVEFN%
SET GENS=8

@echo ON
@echo "STARTING BACKUP TO FILE:  %MYARCHIVEFULLPATH%"
@echo OFF

echo. >> %THELOGFN%
echo. >> %THELOGFN%
cd c:\Development
echo %THEARCHIVEFN% >> %THELOGFN% 
echo "======================= >> %THELOGFN%"

::***************************************************************
:: Create a zip archive with timestamps and compression
:: tzip: produce a zip archive
:: mx=1: compression level 0(none) - 9(full)
:: mtc=on: adds item creation and access times
:: spf: use fully qualified paths
:: mmt: number of cpu threads to use
::***************************************************************

%MYARCHIVER% ^
  u %MYARCHIVEDIR%\%THEARCHIVEFN% ^
  -tzip ^
  -mx=9 ^
  -mtc=on ^
  -mmt=4 ^
  -spf ^
  -o:%MYARCHIVEDIR% ^
  -x@%EXCLUDEFILE%  ^
  -i@%INCLUDEFILE% ^ >> %THELOGFN% 2>&1
echo.>> %THELOGFN%
::echo %DATE% %TIME% >> %THELOGFN%
::echo "--------------------------" >> %THELOGFN%
echo.>> %THELOGFN%

::# Delete backup older than 8 gens
echo.>> %THELOGFN%
echo.>> %THELOGFN%
echo.>> %THELOGFN%
echo Deleting files matching pattern %MYARCHIVEDIR%\ that are older than %GENS% gens... >> %THELOGFN%
FOR /f "skip=%GENS% delims=" %%G in ('DIR /B /o-d %MYARCHIVEDIR%\*.zip') DO (
  echo going to delete %%G >> %THELOGFN%
  DEL %MYARCHIVEDIR%\%%G
}
echo.>> %THELOGFN%
echo %DATE% %TIME% >> %THELOGFN%
echo "--------------------------" >> %THELOGFN%
EXIT /B
