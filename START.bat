@echo off
setlocal

cd /d "%~dp0"

title eHelp Development Environment

echo.
echo eHelp Development Setup
echo =======================
echo.

REM Set portable paths
set "ROOT=%~dp0"
set "PYTHON=%ROOT%Python\python.exe"
set "NODE=%ROOT%Node"
set "BACKEND=%ROOT%ehelp\backend"
set "FRONTEND=%ROOT%ehelp\frontend"

REM Verify required files
if not exist "%PYTHON%" (
    echo ERROR: Portable Python not found!
    echo Expected: %PYTHON%
    pause
    exit /b 1
)

if not exist "%NODE%\npm.cmd" (
    echo ERROR: Portable Node.js not found!
    echo Expected: %NODE%\npm.cmd
    pause
    exit /b 1
)

if not exist "%BACKEND%\.venv\Scripts\python.exe" (
    echo ERROR: Backend virtual environment not found!
    pause
    exit /b 1
)

set "EHELP_DEV_ADMIN=1"

echo Starting backend server...
start "eHelp Backend" cmd /k "cd /d "%~dp0ehelp\backend" && "%~dp0ehelp\backend\.venv\Scripts\python.exe" -m uvicorn ehelp.app:create_app --factory --host 127.0.0.1 --port 8123 --reload"

timeout /t 3 /nobreak >nul

echo Starting frontend dev server...

start "eHelp Frontend" cmd /k "cd /d "%FRONTEND%" && "%NODE%\npm.cmd" run dev"

echo.
echo =======================
echo Application starting...
echo Backend:  http://localhost:8123
echo Frontend: Check Vite output for its URL
echo =======================
echo.

pause
endlocal
