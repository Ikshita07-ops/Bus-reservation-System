@echo off
title Stop VoyageBus Server
color 0C
echo =======================================================================
echo          STOPPING BUS RESERVATION MANAGEMENT SYSTEM SERVER
echo =======================================================================
echo.

:: Detect CATALINA_HOME
if "%CATALINA_HOME%"=="" (
    if exist "D:\Ikshita\tools\apache-tomcat-9.0.96" (
        set "CATALINA_HOME=D:\Ikshita\tools\apache-tomcat-9.0.96"
    ) else if exist "C:\Program Files\Apache Software Foundation\Tomcat 9.0" (
        set "CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 9.0"
    )
)

if "%CATALINA_HOME%"=="" (
    echo [ERROR] CATALINA_HOME is not set and Tomcat was not found.
    echo Please set CATALINA_HOME environment variable to your Tomcat 9 directory.
    pause
    exit /b 1
)

call "%CATALINA_HOME%\bin\shutdown.bat"
echo.
echo Server has been stopped successfully.
ping 127.0.0.1 -n 3 >nul
