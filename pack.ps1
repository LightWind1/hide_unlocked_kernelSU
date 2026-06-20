param(
    [string]$OutputDir = ".",
    [switch]$KeepExisting
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

$RequiredFiles = @(
    "module.prop",
    "system.prop",
    "post-fs-data.sh",
    "service.sh",
    "customize.sh",
    "README.md"
)

$RequiredWebFiles = @(
    "webroot/index.html"
)

foreach ($File in ($RequiredFiles + $RequiredWebFiles)) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $File) -PathType Leaf)) {
        throw "Missing required module file: $File"
    }
}

$ModuleProps = Get-Content -LiteralPath (Join-Path $Root "module.prop")
$ModuleId = ($ModuleProps | Where-Object { $_ -match "^id=" } | Select-Object -First 1) -replace "^id=", ""
$Version = ($ModuleProps | Where-Object { $_ -match "^version=" } | Select-Object -First 1) -replace "^version=", ""

if ([string]::IsNullOrWhiteSpace($ModuleId)) {
    throw "module.prop is missing id=<module_id>"
}

if ([string]::IsNullOrWhiteSpace($Version)) {
    throw "module.prop is missing version=<version>"
}

$SafeVersion = $Version -replace "[^\w.-]", "_"
$OutputPath = Join-Path (Resolve-Path -LiteralPath $OutputDir) "$ModuleId-$SafeVersion.zip"

if ((Test-Path -LiteralPath $OutputPath) -and -not $KeepExisting) {
    Remove-Item -LiteralPath $OutputPath -Force
}

if (Test-Path -LiteralPath $OutputPath) {
    throw "Output already exists: $OutputPath. Use -KeepExisting only when writing a different OutputDir."
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$Zip = [System.IO.Compression.ZipFile]::Open($OutputPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($File in $RequiredFiles) {
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $Zip,
            (Join-Path $Root $File),
            $File,
            [System.IO.Compression.CompressionLevel]::Optimal
        ) | Out-Null
    }

    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
        $Zip,
        (Join-Path $Root "webroot/index.html"),
        "webroot/index.html",
        [System.IO.Compression.CompressionLevel]::Optimal
    ) | Out-Null
}
finally {
    $Zip.Dispose()
}

$Entries = [System.IO.Compression.ZipFile]::OpenRead($OutputPath)
try {
    $EntryNames = $Entries.Entries | ForEach-Object { $_.FullName }
}
finally {
    $Entries.Dispose()
}

if ($EntryNames -notcontains "module.prop") {
    throw "Invalid package: module.prop is not at zip root."
}

if ($EntryNames -notcontains "webroot/index.html") {
    throw "Invalid package: webroot/index.html is missing."
}

Write-Host "Created: $OutputPath"
Write-Host "Entries:"
$EntryNames | ForEach-Object { Write-Host "  $_" }
