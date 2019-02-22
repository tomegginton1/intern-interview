@echo off
setlocal

Echo Clearing cache, cookies and history for:


:: -------------
:: Google Chrome
:: -------------
pushd "%LOCALAPPDATA%\Google\Chrome\User Data\Default" 2>NUL && (

    set /p "=* Google Chrome... "<NUL
    call :kill chrome

    for /f "delims=" %%I in (
        'dir /b ^| find /v /i "bookmarks" ^| find /v /i "extension" ^| find /v /i "preferences"'
    ) do (
        if exist "%%~fI\" (
            rmdir /q /s "%%~fI"
        ) else del /f "%%~fI" >NUL
    )

    popd
    echo Done.
)


:: -------
:: Firefox
:: -------
pushd "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" 2>NUL && (

    set /p "=* Firefox... "<NUL
    call :kill firefox

    for /f "delims=" %%I in ('dir /b /s /ad *cache* 2^>NUL') do (
        if exist "%%~fI" rmdir /q /s "%%~fI"
    )

    popd
    pushd "%APPDATA%\Mozilla\Firefox\Profiles" 2>NUL && (

        for %%I in (history.dat formhistory.dat downloads.rdf cookies.txt) do (
            for /f "delims=" %%x in ('dir /b /s /a-d %%I 2^>NUL') do (
                if exist "%%~fI" del /f "%%~fI" >NUL
            )
        )
        for /f "delims=" %%I in ('dir /b /s /ad *cache* 2^>NUL') do (
            if exist "%%~fI" rmdir /q /s "%%~fI"
        )
        popd
    )

    echo Done.
)


:: -----
:: Opera
:: -----
pushd "%APPDATA%\Opera\Opera\" 2>NUL && (
    set /p "=* Opera... "<NUL
    call :kill opera
    for %%I in (history cookie session) do (
        for /f "delims=" %%x in ('dir /b "*%%I*" 2^>NUL') do (
            if exist "%%~fx\" (
                rmdir /q /s "%%~fx"
            ) else del "%%~fx"
        )
    )
    popd
    pushd "%LOCALAPPDATA%\Opera\Opera\" 2>NUL && (
        for /d %%I in (*cache) do rmdir /q /s "%%~fI"
        for /d %%I in (*temp*) do rmdir /q /s "%%~fI"
        popd
    )
    echo Done.
)


:: ------
:: Safari
:: ------
pushd "%APPDATA%\Applec~1\Safari" 2>NUL && (
    set /p "=* Safari... "<NUL
    call :kill safari
    rmdir /q /s "%LOCALAPPDATA%\Applec~1\Safari" 2>NUL
    for /f "delims=" %%I in (
        'dir /b ^| find /v /i "bookmark" ^| find /v /i "configuration"'
    ) do (
        if exist "%%~fI\" (
            rmdir /q /s "%%~fI"
        ) else del "%%~fI"
    )
    echo Done.
)


:: -----------------
:: Internet Explorer
:: -----------------
set /p "=* Internet Explorer... "<NUL
call :kill iexplore
>NUL (
    set History=%LOCALAPPDATA%\Microsoft\Windows\History

    if exist "%History%" (
        del /q /s /f "%History%"
        rd /s /q "%History%"
    )

    set IETemp=%LOCALAPPDATA%\Microsoft\Windows\Tempor~1

    if exist "%IETemp%" (
        del /q /s /f "%IETemp%"
        rd /s /q "%IETemp%"
    )

    set Cookies=%APPDATA%\Microsoft\Windows\Cookies

    if exist "%Cookies%" (
        del /q /s /f "%Cookies%"
        rd /s /q "%Cookies%"
    )

    reg delete "HKCU\Software\Microsoft\Internet Explorer\TypedURLs" /va /f 2>NUL
)
echo Done.


:: -------------
:: Flash Cookies
:: -------------
set /p "=* Flash Player... "<NUL
set FlashCookies=%APPDATA%\Macromedia\Flashp~1

>NUL (
    if exist "%FlashCookies%" (
        del /q /s /f "%FlashCookies%"
        rd /s /q "%FlashCookies%"
    )
)
echo Done.

goto :EOF

:kill
taskkill /im "%~1.exe" >NUL 2>NUL
set "task=%~1"
:killwait
for /f "tokens=2 delims==" %%I in ('wmic process where "name like \"%%%task%%%\"" get name /format:list 2^>NUL') do (
    ping -n 2 0.0.0.0 >NUL
    goto killwait
)
goto :EOF

Exit