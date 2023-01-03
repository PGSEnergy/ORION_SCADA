@echo off
set EXE=opcs_snmp
set title=Change settings - %EXE%

title %title%
set instance=1
if exist "%~dp0%EXE%_2" set /P instance="Select instance nr: "

start "%title%" /D "%~dp0" %EXE% /settings /instance %instance%
