@echo off
REM Set your Tailscale auth key here (replace with your actual key)
set AUTHKEY=tskey-xxxxxxxxxxxxxxxx

REM Start Docker VM
docker-machine start default >nul 2>&1

REM Set Docker environment
FOR /F "tokens=*" %%i IN ('docker-machine env default --shell cmd') DO %%i

REM Start the Tailscale container
docker start tailscale >nul 2>&1

REM Give it a few seconds to fully boot
timeout /t 5 /nobreak >nul

REM Check Tailscale status
docker exec tailscale tailscale status >tailscale_status.txt 2>nul

REM Look for 'Logged out' or an error
findstr /i "Logged out NoState" tailscale_status.txt >nul
IF %ERRORLEVEL% EQU 0 (
    echo Tailscale is not authenticated. Attempting to authenticate...
    docker exec tailscale tailscale up --authkey=%AUTHKEY% --hostname=my-windows8-server >auth_output.txt 2>&1

    findstr /i "invalid" auth_output.txt >nul
    IF %ERRORLEVEL% EQU 0 (
        echo ERROR: The auth key is invalid or expired.
        echo Please generate a new one at https://login.tailscale.com/admin/settings/keys
        pause
    ) ELSE (
        echo Tailscale authentication attempted.
    )
) ELSE (
    echo Tailscale appears to be already connected.
)

REM Clean up
del tailscale_status.txt >nul 2>&1
del auth_output.txt >nul 2>&1

echo Done.
