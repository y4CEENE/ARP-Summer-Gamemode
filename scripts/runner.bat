REM Start game
"D:\Games\GTA San Andreas\samp.exe" 127.0.0.1:7777

REM Setup and start server
copy ..\LWOR-Server\lwor.amx gamemodes\
.\samp-server.exe
pause

REM Setup, start server and Lanuch game
copy ..\LWOR-Server\lwor.amx gamemodes\
"D:\Games\GTA San Andreas\samp.exe" 127.0.0.1:7777
.\samp-server.exe
pause

REM Setup and run tests
copy ..\LWOR-Server\lwor-test.amx gamemodes\lwor.amx
.\samp-server.exe
pause
