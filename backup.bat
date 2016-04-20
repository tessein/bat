:: 2016-04-20
:: Tessein -- simple batch archive script

@echo OFF

SET MYBACKUPDIR=c:\Users\Chartes\Desktop\Backup
SET MYARCHIVEDIR=%MYBACKUPDIR%\Archive
SET THELOGFN=%MYBACKUPDIR%\backup_log.txt

SET THEDATE=%DATE:~-4%-%DATE:~4,2%-%DATE:~7,2%

:: add leading 0 for hour < 10
SET HOUR=%TIME:~0,2%
IF "%HOUR:~0,1%" == " " (
  SET HOUR=0%HOUR:~1,1%
)
SET MINUTE=%TIME:~3,2%
SET SECOND=%TIME:~6,2%

SET THETIME=%HOUR%-%MINUTE%-%SECOND%
SET THETIMEFMTCLN=%HOUR%:%MINUTE%:%SECOND%

SET THEARCHIVEFN=%THEDATE%_%THETIME%.zip

@echo ON
@echo STARTING BACKUP TO FILE:  %MYARCHIVEDIR%\%THEARCHIVEFN%
@echo OFF

echo. >> %THELOGFN%
echo. >> %THELOGFN%
cd c:\Development
echo %THEARCHIVEFN% >> %THELOGFN% 
echo ======================= >> %THELOGFN%

%MYBACKUPDIR%\7za ^
  u %MYARCHIVEDIR%\%THEARCHIVEFN% ^
  -tzip -mx=9 -mtc=on -o:%%MYARCHIVEDIR% ^
  -x@%MYBACKUPDIR%\exclude  ^
  -i@%MYBACKUPDIR%\include >> %THELOGFN%

echo -------------------- >> %THELOGFN%
echo. >> %THELOGFN%
