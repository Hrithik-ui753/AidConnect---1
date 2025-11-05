@echo off
SET PYTHON_PATH=C:\Users\HP\AppData\Local\Programs\Python\Python311
SET PATH=%PYTHON_PATH%;%PYTHON_PATH%\Scripts;%PATH%

if "%1"=="" (
    echo Python environment is ready!
    cmd /k
) else (
    %PYTHON_PATH%\python.exe %*
)