@echo off
rem This batch program is for setup and cleanup of the family tree intern interview.
rem Entering a status of "pre" will checkout the sample code from GitLab.
rem Entering a status of "post" will push the candidate's code to GitLab and clear 
rem the recycle bin and browser history.

rem Adapted from the regular candidate interview script.
rem Assumes that git is configured not to save credentials.

setlocal enabledelayedexpansion

rem Set some directory/file name constants
set interviewDir=%USERPROFILE%\Desktop\intern_interview
set logDir=%interviewDir%\log_intern_interview
set candInfoFile=%interviewDir%\cand_info.txt
set solutionDir=%interviewDir%\solution
set batch_folder=%cd%

rem Set some git-related constants
set gitRepo=http://mystique:8090/recruiting/FamilyTreeProblem.git
set base_branch=master
set result_branch_prefix=candidate

rem Some interview file setup
rem Create the base interview folder if it doesn't exist
if not exist "%interviewDir%" mkdir "%interviewDir%"
rem Create a (hidden) log folder if there isn't already one
if not exist "%interviewDir%\log_intern_interview" mkdir "%interviewDir%\log_intern_interview"
attrib +h "%interviewDir%\log_intern_interview" /s /d
rem Create a log file with a timestamp in the name
set timestamp=%time: =0%
set logFile="%interviewDir%\log_intern_interview\%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%timestamp:~0,2%%timestamp:~3,2%.log"

set retAddr=:endScript

rem Get interview status
set /p status=Interview Status [pre/post]: 
echo Interview status: %status% > %logFile% && type %logFile%

rem Pre-interview steup - create and checkout a branch for the candidate's files
if /I "%status%"=="pre" (

	rem Make sure the files of the previous candidate have been uploaded
	if exist "%candInfoFile%" (
		echo. >> %logFile% 
		echo Last candidate's code and results have not been uploaded. Running post-interview first  >> %logFile% 
		echo Last candidate's code and results have not been uploaded. Running post-interview first
		
		set retAddr=preSetup
		goto postCleanup
	)

	:preSetup
	cd "%interviewDir%"
	set candInfoFlag=n
	if exist "%solutionDir%" (
		echo The solution directory still exists
		set retAddr=:candidateInfo
		goto clearInterviewFolder
	)
	
	:candidateInfo
	echo.>> %logFile% 
	echo ------- Setting up intern interview ------- >> %logFile% 
	echo.
	echo ------- Setting up intern interview -------

	set /p candName= Name of candidate [format: FirstName_LastName]: 
	set /p candLang= Programming language[C++, Java, Python]: 
	echo.
	set /p candInfoFlag=Information Correct[!candName!, !candLang!]?[y/n]:
	echo.
	
	if /I "!candInfoFlag!"=="n" goto candidateInfo		
	if /I "!candLang!"=="C++" (
		set candLang=
		set candLang=c++
	)
	if /I "!candLang!"=="Java" (
		set candLang=
		set candLang=java
	)
	if /I "!candLang!"=="Python" (
		set candLang=
		set candLang=python
	)
	
	if "!candLang!"=="" (
		echo "!candLang! is not a valid language option"
		goto candidateInfo
	)
	
	echo Name of Candidate : !candName! >> %logFile% 
	echo Name of Candidate : !candName! 
	echo Programming Language: !candLang! >> %logFile% 
	echo Programming Language: !candLang!
	echo.
	echo Saving !candName!_!candLang! to %candInfoFile% >> %logFile% 
	echo Saving !candName!_!candLang! to %candInfoFile%
	echo !candName!_!candLang! >> %candInfoFile%	

	rem Get sample code from GitLab
	echo Cloning sample code. >> %logFile% 
	echo Cloning sample code. 
	echo. >> %logFile% 
	
	cd "%interviewDir%"
	git clone -b %base_branch% "%gitRepo%" intern_problem --single-branch
	if !ERRORLEVEL! NEQ 0 (
		echo GitLab connection is down. Please try again later or contact IT team. Exiting the script. >> %logFile% 
		echo GitLab connection is down. Please try again later or contact IT team. Exiting the script.				
		goto endScript
	)
	rem Clear git credentials
	git credential-manager clear "%gitRepo%"
	
	rem Copy code from git folder to the candidate solution folder so that the candidate won't have access to git project
	mkdir "%solutionDir%"
	xcopy /e /q "%interviewDir%\intern_problem\sample" "%solutionDir%"
	rmdir /s /q "%interviewDir%\intern_problem"	
	
	goto endScript
)

if /I "%status%"=="post" (
	set retAddr=:endScript
	:postCleanup
	rem Clone the intern project repository, copy files from the candidate solution folder into the repository
	cd "%interviewDir%"
	git clone -b %base_branch% "%gitRepo%" intern_problem --single-branch
	rmdir /s /q "%interviewDir%\intern_problem\sample"
	xcopy /e /q /y "%solutionDir%" "%interviewDir%\intern_problem\sample\"
	rem Commit and push the candidate's solution
	echo Retrieving candidate info from %candInfoFile% >> %logfile%
	echo Retrieving candidate info from %candInfoFile%
	set /p candInfo=<%candInfoFile%
	cd "%interviewDir%\intern_problem"
	git checkout -b %result_branch_prefix%/!candInfo!
	rem If candInfo would lead to an invalid git branch name (e.g. if it's empty or has spaces), this script would
	rem end up pushing to master instead of to a candidate-specific branch
	if !ERRORLEVEL! NEQ 0 (
		echo Previous candidate info '!candInfo!' is invalid - either missing or has invalid characters >> %logFile%
		echo Previous candidate info '!candInfo!' is invalid - either missing or has invalid characters
		goto endScript
	)
	git add -A
	git commit -m "Save candidate code for !candInfo!"
	git push origin HEAD && echo Committed and pushed previous candidate code.
	if !ERRORLEVEL! NEQ 0 (
		echo GitLab connection is down. Please try again later or contact IT team. Exiting the script. >> %logFile% 
		echo GitLab connection is down. Please try again later or contact IT team. Exiting the script.
		goto endScript
	)
	
	set retAddr=:postClearInterviewFolder
	rem Delete code folders from interview folder
	:clearInterviewFolder
	cd %interviewDir%
	echo. >> %logFile%
	echo.
	echo If the previous candidate's code was uploaded successfully, it is safe to clear the intern interview folder
	set /p delete_option=Clear the intern interview folder? [y/n]:
	
	if /I "!delete_option!"=="y" (
		echo Clearing the %interviewDir% folder. >> %logFile%
		echo Clearing the %interviewDir% folder.
		
		rmdir "%interviewDir%\solution" /s /q 1>> %logFile% 2>&1	
		rmdir "%interviewDir%\intern_problem" /s /q 1>> %logFile% 2>&1
		del "%candInfoFile%" /q
	)
	goto !retAddr!
	
	:postClearInterviewFolder
	set retAddr=:endScript
	
	:clearOther
	rem Clear git credentials
	git credential-manager clear "%gitRepo%"
	
	rem Clear browser history and recycle bin
	echo Clearing recycle bin
	call %batch_folder%\clear_recycle_bin.bat 1>> %logFile% 2>&1
	echo Cleared recycle bin
	echo.
	
	echo Clearing browser history
	echo If this part hangs, it is likely due to browser processes still running in other logged-in accounts.
	echo It is safe to stop this script and manually clear browser history if this happens.
	rem clear_all_browser.bat will wait for all browser processes to be killed, but when running on a lower 
	rem permission account such as interview-candidate it can only kill processes for that account
	rem Processes on other logged-in accounts may still be running, causing the script to wait indefinitely
	call %batch_folder%\clear_all_browser.bat 1>> %logFile% 2>&1
	echo Cleared browser history
	echo.
	
	goto !retAddr!
)

:endScript
pause




