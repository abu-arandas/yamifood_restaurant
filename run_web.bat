@echo off
echo "=============================================="
echo "  Launching Yamifood Restaurant Web App"
echo "=============================================="

REM Check if Chrome or Edge is available
where chrome >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Using Chrome browser for development...
    flutter run -d chrome
) ELSE (
    where msedge >nul 2>&1
    IF %ERRORLEVEL% EQU 0 (
        echo Using Edge browser for development...
        flutter run -d edge
    ) ELSE (
        echo Chrome or Edge not found. Using default browser...
        flutter run -d web-server
    )
)

REM Wait for keypress before closing
echo.
echo Press any key to close this window...
pause >nul
