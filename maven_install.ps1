$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newpath="$oldpath;C:\apache-maven\apache-maven-3.2.3\bin"

mkdir -Path c:\apache-maven\apache-maven-3.2.3
\\{redacted}\NETLOGON\Login.vbs
Copy-Item -Path T:\JAVA\open_source\maven\apache-maven-3.2.3\* -Destination c:\apache-maven\apache-maven-3.2.3\ -Recurse
[Environment]::SetEnvironmentVariable("MAVEN_HOME", "c:\apache-maven", "Machine")
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
