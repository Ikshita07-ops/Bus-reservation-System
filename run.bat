@echo off
title VoyageBus Express - Bus Reservation Management System
color 0B

echo =======================================================================
echo          VOYAGEBUS EXPRESS - BUS RESERVATION MANAGEMENT SYSTEM
echo =======================================================================
echo.

:: 1. Check and Start MySQL Service
echo [1/4] Checking MySQL Database Service...
sc query MySQL80 | find "RUNNING" >nul
if %ERRORLEVEL% EQU 0 (
    echo       MySQL80 service is currently RUNNING.
) else (
    echo       Starting MySQL80 service...
    net start MySQL80 >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo       MySQL80 service started successfully.
    ) else (
        echo       [NOTE] Please ensure MySQL is running on localhost:3306.
    )
)
echo.

:: 2. Set Paths and Environment Variables
echo [2/4] Setting environment variables...
set "PROJECT_DIR=%~dp0"

:: 2a. Detect Maven (Wrapper first, then PATH, then local tools)
if exist "%PROJECT_DIR%mvnw.cmd" (
    set "MAVEN_CMD=%PROJECT_DIR%mvnw.cmd"
) else (
    where mvn >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        set "MAVEN_CMD=mvn"
    ) else if exist "D:\Ikshita\tools\apache-maven-3.9.6\bin\mvn.cmd" (
        set "MAVEN_CMD=D:\Ikshita\tools\apache-maven-3.9.6\bin\mvn.cmd"
    ) else (
        set "MAVEN_CMD=mvn"
    )
)

:: 2b. Detect Tomcat (CATALINA_HOME first, then common locations)
if "%CATALINA_HOME%"=="" (
    if exist "D:\Ikshita\tools\apache-tomcat-9.0.96" (
        set "CATALINA_HOME=D:\Ikshita\tools\apache-tomcat-9.0.96"
    ) else if exist "C:\Program Files\Apache Software Foundation\Tomcat 9.0" (
        set "CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 9.0"
    )
)

set "CATALINA_BASE=%CATALINA_HOME%"

if "%CATALINA_HOME%"=="" (
    echo.
    echo [ERROR] Apache Tomcat 9 was not detected!
    echo Please either:
    echo   1. Install Tomcat 9 and set CATALINA_HOME in your environment variables, OR
    echo   2. Run via Docker: docker compose up --build
    echo.
    pause
    exit /b 1
)

echo       Project: %PROJECT_DIR%
echo       Tomcat:  %CATALINA_HOME%
echo       Maven:   %MAVEN_CMD%
echo.

:: 3. Build WAR if missing or copy to Tomcat
echo [3/4] Preparing deployment package...
if not exist "%PROJECT_DIR%target\busreservation.war" (
    echo       WAR package not found. Building project with Maven...
    call "%MAVEN_CMD%" -f "%PROJECT_DIR%pom.xml" clean package -DskipTests
) else (
    echo       Found compiled package: target\busreservation.war
)

echo       Deploying application to Tomcat webapps...
copy /Y "%PROJECT_DIR%target\busreservation.war" "%CATALINA_HOME%\webapps\ROOT.war" >nul
copy /Y "%PROJECT_DIR%target\busreservation.war" "%CATALINA_HOME%\webapps\busreservation.war" >nul
echo       Deployment completed successfully.
echo.

:: 4. Start Browser & Run Tomcat
echo [4/4] Starting Apache Tomcat Server...
echo.
echo =======================================================================
echo   The web application will open automatically in your default browser:
echo       * Home Page:        http://localhost:8080/
echo       * Bus Search:       http://localhost:8080/search
echo       * Admin Dashboard:  http://localhost:8080/admin/dashboard
echo.
echo   Press Ctrl + C in this window to stop the server anytime.
echo =======================================================================
echo.

:: Open browser automatically after 5 seconds
start "" powershell -NoProfile -Command "Start-Sleep -Seconds 5; Start-Process 'http://localhost:8080/'"

:: Run Tomcat in console
call "%CATALINA_HOME%\bin\catalina.bat" run

pause
