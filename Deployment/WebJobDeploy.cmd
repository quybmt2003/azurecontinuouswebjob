@echo off

for /f %%g in ('git rev-parse --show-toplevel') do set gitroot=%%g
IF "%gitroot%" EQU "" GOTO $NOTONGIT

echo "Building on %gitroot%"

pushd %cd%
cd %gitroot% 

msbuild .\WebjobContinuous.sln /p:DeployOnBuild=true;PublishProfile=Debug;AllowUntrustedCertificate=true;User=$asmgendev;Password=AbhgF6RBEsFJoJbrewdB3xxXhXg8lM8RC9Znh2oCF7KfQj4T6rlz3gpc8Xnq;Configuration=Debug;Platform="Any CPU"
IF %ERRORLEVEL% NEQ 0 GOTO $ERROR

"C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe" -verb:sync -source:package="%gitroot%\WebjobContinuous\bin\WebjobContinuous.zip" -dest:auto,ComputerName="https://asmgendev.azurewebsites.net:443/msdeploy.axd?site=asmgendev",User=$asmgendev;Password=AbhgF6RBEsFJoJbrewdB3xxXhXg8lM8RC9Znh2oCF7KfQj4T6rlz3gpc8Xnq,AuthType="Basic" -setParam:name="IIS Web Application Name",value="asmgendev" -enableRule:DoNotDeleteRule
IF %ERRORLEVEL% NEQ 0 GOTO $ERROR


:$EXIT_OK
popd
echo. 
echo Deployemt completed successfully.
EXIT /B 0

:$ERROR
popd
echo.
echo Deployment failed. Something went wrong!!!
EXIT /B 1

:$NOTONGIT
popd
echo.
echo Not deployed. Not on git repo!!!
EXIT /B 1