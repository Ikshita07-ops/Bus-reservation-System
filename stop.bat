@echo off
title Stop VoyageBus Server
color 0C
echo =======================================================================
echo          STOPPING BUS RESERVATION MANAGEMENT SYSTEM SERVER
echo =======================================================================
echo.
set "CATALINA_HOME=D:\Ikshita\tools\apache-tomcat-9.0.96"
call "%CATALINA_HOME%\bin\shutdown.bat"
echo.
echo Server has been stopped successfully.
ping 127.0.0.1 -n 3 >nul
