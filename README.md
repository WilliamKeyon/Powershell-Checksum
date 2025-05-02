# Powershell-Checksum

A PowerShell script to perform a file checksum and verify its integrity. 

Calculates, compares and display the checksum of the specified file with the known provided hash.

### Usage
```
Checksum -FilePath .\Example.txt -Hash ED076287532E86365E841E92BFC50D8C -Alg MD5
```
or more simply
```
Checksum .\Example.txt ED076287532E86365E841E92BFC50D8C
```

## Parameters

**-FilePath**

The path to the file for which the checksum will be calculated.

**-Hash**

The known hash value for which the checksum will be compared.

**-Alg**

The checksum algorithm to use. [Supported Algorithms](#supported-algorithms)

By default the algorithm is chosen by the hash length, with a fallback on SHA256.

### Options

> [!TIP]
> Powershell Get-Help is also supported.

**Help**

Shows an help message.

**Version**

Shows the script version.

## Supported Algorithms

Since the file hash is calculated with Get-FileHash, it inherites its supported algorithms.

* MD5
* SHA1
* SHA256
* SHA384
* SHA512
