Get-ChildItem -Path "./CommandNodePackage/*.ps1" | ForEach-Object {
    . $_.FullName
}
