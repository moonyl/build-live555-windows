PowerShell (New-Object System.Net.WebClient).DownloadFile('http://www.live555.com/liveMedia/public/live555-latest.tar.gz','live555-latest.tar.gz');
"%PROGRAMFILES%\7-Zip\7z.exe" x -aoa live555-latest.tar.gz
"%PROGRAMFILES%\7-Zip\7z.exe" x -aoa live555-latest.tar

powershell -Command "(gc live\win32config) -replace '!include    <ntwin32.mak>', '#!include    <ntwin32.mak>' | Out-File live\win32config"
powershell -Command "(gc live\win32config) -replace 'CPU=i386', 'CPU=amd64' | Out-File live\win32config"
powershell -Command "(gc live\win32config) -replace 'c:\\Program Files\\DevStudio\\Vc', 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.16.27023' | Out-File live\win32config"
powershell -Command "(gc live\win32config) -replace '\$\(INCLUDES\) \$\(cdebug\) \$\(cflags\) \$\(cvarsdll\) -I. -I\"\$\(TOOLS32\)\\include\"', '$(INCLUDES) $(cdebug) $(cflags) $(cvarsdll) -I. /EHsc /O2 /MD /GS /D \"WIN64\" /Oy- /Oi /D \"NDEBUG\"' | Out-File live\win32config"
powershell -Command "(gc live\win32config) -replace '\$\(TOOLS32\)\\bin\\cl', 'cl' | Out-File live\win32config"
powershell -Command "(gc live\win32config) -replace 'LINK =			\$\(link\) -out:', 'LINK = link /out:' | Out-File live\win32config"
powershell -Command "(gc live\win32config) -replace 'LIBRARY_LINK =		lib -out:', 'LIBRARY_LINK = lib /out:' | Out-File live\win32config"
powershell -Command "(gc live\win32config) -replace '\$\(linkdebug\) msvcirt.lib', '$(linkdebug) ws2_32.lib /NXCOMPAT' | Out-File live\win32config"
powershell -Command "(gc live\win32config) -replace 'kernel32.lib advapi32.lib shell32.lib -subsystem:console,\$\(APPVER\)', 'kernel32.lib advapi32.lib shell32.lib ws2_32.lib -subsystem:console,$(APPVER)' | Out-File live\win32config"
powershell -Command "(gc live\win32config) -replace '\$\(TOOLS32\)\\bin\\rc', 'rc.exe' | Out-File live\win32config"

call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\Tools\vsdevcmd" -arch=x64

cd live

call genWindowsMakefiles

cd liveMedia
del *.obj *.lib
nmake /B -f liveMedia.mak
cd ..\groupsock
del *.obj *.lib
nmake /B -f groupsock.mak
cd ..\UsageEnvironment
del *.obj *.lib
nmake /B -f UsageEnvironment.mak
cd ..\BasicUsageEnvironment
del *.obj *.lib
nmake /B -f BasicUsageEnvironment.mak
cd ..\testProgs
del *.obj *.lib
nmake /B -f testProgs.mak
cd ..\mediaServer
del *.obj *.lib
nmake /B -f mediaServer.mak
cd ..

pause