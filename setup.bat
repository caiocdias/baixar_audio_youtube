@echo off
setlocal

cd /d "%~dp0"
set "NEEDS_RESTART=0"
set "WINGET_FLAGS=--accept-package-agreements --accept-source-agreements"

echo.
echo === Setup - YouTube Audio Downloader ===
echo.

call :find_python
if errorlevel 1 exit /b 1

call :ensure_ffmpeg
if errorlevel 1 exit /b 1

echo.
if not exist ".venv\Scripts\python.exe" (
    echo Criando ambiente virtual em .venv...
    %PY_CMD% -m venv .venv
    if errorlevel 1 (
        echo Erro ao criar o ambiente virtual.
        exit /b 1
    )
) else (
    echo Ambiente virtual .venv ja existe.
)

set "VENV_PY=.venv\Scripts\python.exe"

echo.
echo Atualizando pip...
"%VENV_PY%" -m pip install --upgrade pip
if errorlevel 1 (
    echo Erro ao atualizar o pip.
    exit /b 1
)

echo.
echo Instalando dependencias do projeto...
"%VENV_PY%" -m pip install -r requirements.txt
if errorlevel 1 (
    echo Erro ao instalar as dependencias.
    exit /b 1
)

echo.
echo Setup concluido.
if "%NEEDS_RESTART%"=="1" (
    echo.
    echo Feche e abra o terminal para atualizar o PATH antes de usar o script.
)
echo.
echo Para usar:
echo   .venv\Scripts\python.exe baixar_audio_youtube.py "URL_DO_YOUTUBE"
echo.
exit /b 0

:find_python
py -3 --version >nul 2>nul
if not errorlevel 1 (
    set "PY_CMD=py -3"
    echo Python encontrado via launcher py.
    exit /b 0
)

python --version >nul 2>nul
if not errorlevel 1 (
    set "PY_CMD=python"
    echo Python encontrado no PATH.
    exit /b 0
)

echo Python nao encontrado.
where winget >nul 2>nul
if errorlevel 1 (
    echo Instale o Python 3.9 ou superior e rode este setup novamente.
    exit /b 1
)

echo Instalando Python com winget...
winget install -e --id Python.Python.3.12 %WINGET_FLAGS%
if errorlevel 1 (
    echo Erro ao instalar Python com winget.
    exit /b 1
)

py -3 --version >nul 2>nul
if not errorlevel 1 (
    set "PY_CMD=py -3"
    echo Python instalado.
    exit /b 0
)

python --version >nul 2>nul
if not errorlevel 1 (
    set "PY_CMD=python"
    echo Python instalado.
    exit /b 0
)

echo Python foi instalado, mas ainda nao apareceu no PATH deste terminal.
echo Feche e abra o terminal, depois rode setup.bat novamente.
exit /b 1

:ensure_ffmpeg
ffmpeg -version >nul 2>nul
if not errorlevel 1 (
    echo FFmpeg encontrado no PATH.
    exit /b 0
)

echo FFmpeg nao encontrado.
where winget >nul 2>nul
if errorlevel 1 (
    echo Instale o FFmpeg e rode este setup novamente.
    exit /b 1
)

echo Instalando FFmpeg com winget...
winget install -e --id Gyan.FFmpeg %WINGET_FLAGS%
if errorlevel 1 (
    echo Erro ao instalar FFmpeg com winget.
    exit /b 1
)

ffmpeg -version >nul 2>nul
if not errorlevel 1 (
    echo FFmpeg instalado.
    exit /b 0
)

echo FFmpeg foi instalado, mas ainda nao apareceu no PATH deste terminal.
set "NEEDS_RESTART=1"
exit /b 0
