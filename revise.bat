@echo off

@REM Colocar variaveis de ambiente se necessário
SET BASEPATH=%~dp0
SET REVISE_PATH="%BASEPATH%\revise"

julia --color=yes --project=%REVISE_PATH% --load=%REVISE_PATH%\revise_load_script.jl
