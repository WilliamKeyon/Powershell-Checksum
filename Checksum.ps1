<#PSScriptInfo
.VERSION 1.0
.GUID 9a0e19f8-99d8-453b-82c7-d939fa414adb
.AUTHOR William A. Keyon
.PROJECTURI https://github.com/WilliamKeyon/Powershell-Checksum
.COMPANYNAME
.COPYRIGHT
.TAGS checksum file-integrity commandline
.LICENSEURI https://github.com/WilliamKeyon/Powershell-Checksum/blob/main/LICENSE
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
#>

<#
.SYNOPSIS
    Checksum - Calculate, compares and display the checksum of the specified file with the known provided hash.
.DESCRIPTION
	Calculates, compares and display the checksum of the specified file with the known provided hash.
	Note that the checksum relies on Get-FileHash.
.PARAMETER FilePath
    The path to the file for which the checksum will be calculated.
.PARAMETER Hash
    The hash value for which the checksum will be compared.
.PARAMETER Alg
    The checksum algorithm to use. [MD5, SHA1, SHA256, SHA384, SHA512]
	By default the algorithm is chosen by the hash length, with a fallback on SHA256.
.EXAMPLE
    Checksum -FilePath .\Example.txt -Hash ED076287532E86365E841E92BFC50D8C -Alg MD5
.EXAMPLE
    Checksum .\Example.txt 2EF7BDE608CE5404E97D5F042F95F89F1C232871
.NOTES
    Author: William A. Keyon
    Version: 1.0
    Date: 2025-05-01
#>

[CmdletBinding()]
param (
	[string]$FilePath,
	[string]$Hash,
	[string]$Alg
)

$Version = '1.0'
$Hash = $Hash.Trim()

if ($($FilePath).Length -eq 0 -Or $FilePath -ieq 'Help' -Or $Hash.Length -eq 0) {
	Write-Host 'Checksum - Calculates, compares and display the checksum of the specified file with the known provided hash.'
	Write-Host ''
	Write-Host "Usage:`t`tChecksum -FilePath .\Example.txt -Hash ED076287532E86365E841E92BFC50D8C -Alg MD5"
	Write-Host "Or simply:`tChecksum .\Example.txt ED076287532E86365E841E92BFC50D8C"
	Write-Host ''
	Write-Host 'Parameters:'
	Write-Host "  -FilePath`tThe path to the file for which the checksum will be calculated."
	Write-Host "  -Hash`t`tThe known hash value for which the checksum will be compared."
	Write-Host "  -Alg`t`tThe checksum algorithm to use. [MD5, SHA1, SHA256, SHA384, SHA512]"
	Write-Host "`t`tBy default the algorithm is chosen by the hash length, with a fallback on SHA256."
	Write-Host ''
	Write-Host 'Options:'
	Write-Host "  Help`t`tShows this help message."
	Write-Host "  Version or V`tShows the current version, which is $Version."
	Write-Host ''
	Write-Host 'Note that the checksum relies on Get-FileHash.'
	Write-Host ''
	Write-Host 'Author: William A. Keyon'
	return
}

if ($FilePath -ieq 'Version' -Or $FilePath -ieq 'V') {
	Write-Host $Version
	return
}

if (!(Test-Path $FilePath)) {
	Write-Host "Cannot find path '$FilePath' because it does not exist." -ForegroundColor Red
	return
}

if ($Hash.Length -eq 0) {
	Write-Host 'Missing hash value. Please provide the known hash value.' -ForegroundColor Red
	return
}

if ($Alg.Length -eq 0) {
	switch ($Hash.Length) {
		32 {
			$Alg = 'MD5'
		}
		40 {
			$Alg = 'SHA1'
		}
		64 {
			$Alg = 'SHA256'
		}
		96 {
			$Alg = 'SHA384'
		}
		128 {
			$Alg = 'SHA512'
		}
		Default {
			$Alg = 'SHA256'
		}
	}
}

Write-Host 'Calculating hash, please wait...'
Write-Host ''

[string]$CalculatedHash = [string]::Empty

try {
	$CalculatedHash = (Get-FileHash -Path $FilePath -Algorithm $Alg).Hash
} catch {
	Write-Host "An error occurred: $($_.ErrorInformation)" -BackgroundColor Red
	throw $_.Exception
	return
}

[string]$FileName = Split-Path $FilePath -Leaf
[bool]$IsMatch = $CalculatedHash -ieq $Hash

Write-Host "The checksum of the provided file ""$FileName"" " -NoNewline

if ($IsMatch) {
	Write-Host "matches the expected hash ""$CalculatedHash""."
	Write-Host 'The file is authentic and unaltered.' -ForegroundColor Green
} else {
	"does NOT match the expected hash ""$CalculatedHash""."
	Write-Host 'The file has been altered or corrupted since the last known authentic checksum was recorded.' -ForegroundColor Red
}