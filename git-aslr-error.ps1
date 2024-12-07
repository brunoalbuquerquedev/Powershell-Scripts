<# Git bash can get a error that crashes the terminal making impossible to use it.
 On the terminal you get the message "Error: Could not fork child process: Resource temporarily unavailable".
 This is a error of memory when git try to access the necessary DLL's to run the bash.
 It is necessary to exclude every .exe file from the ASLR rule from the system (it is valid for windows and linux). #>

try
{
    # Check if the script is running with elevated privileges
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
    {
        Write-Host "Please run this script as an administrator." -ForegroundColor Red
        exit
    }

    # Ask for the git installation path and add the path to the folder bin
    [String]$GitPath = Read-Host "Enter git installation path: (e.g. C:\Program Files\Git)"
    [String]$GitFilesPath = $GitPath + "\usr\bin\*.exe"

    # Get the name of all executables inside the folder
    $Files = (Get-ChildItem $GitFilesPath).FullName

    # Disable the image reallocation in memory
    $Files.ForEach({ Set-ProcessMitigation $_ -Disable ForceRelocateImages })
}
catch [UnauthorizedAccessException]
{
    Write-Host "You do not have permission to perform this action." -ForegroundColor Red
}
catch
{
    Write-Host "An unexpected error occurred: $( $_.Exception.Message )" -ForegroundColor Red
}