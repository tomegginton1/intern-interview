@echo off

setlocal

echo Clearing recycle bin

set Drive=C:

if exist %Drive%\$RECYCLE.BIN (
    pushd %Drive%\$RECYCLE.BIN
    del /s /q .
    popd
)

echo Recycle bin cleared