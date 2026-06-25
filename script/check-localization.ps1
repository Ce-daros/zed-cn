param(
    [switch]$FailOnSourceChinese
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$repoRootText = $repoRoot.Path.TrimEnd("\", "/")

$allowedPathPatterns = @(
    "crates/localization/resources/",
    "README.md"
)

$sourceExtensions = @(".rs", ".toml", ".json", ".md", ".yml", ".yaml")
$matches = @()

Get-ChildItem -Path $repoRoot -Recurse -File |
    Where-Object {
        $relativePath = $_.FullName.Substring($repoRootText.Length + 1).Replace("\", "/")
        $sourceExtensions -contains $_.Extension -and
            $relativePath -notlike ".git/*" -and
            $relativePath -notlike "target/*"
    } |
    ForEach-Object {
        $relativePath = $_.FullName.Substring($repoRootText.Length + 1).Replace("\", "/")
        $isAllowed = $false
        foreach ($pattern in $allowedPathPatterns) {
            if ($relativePath.StartsWith($pattern) -or $relativePath -eq $pattern.TrimEnd("/")) {
                $isAllowed = $true
                break
            }
        }

        Select-String -LiteralPath $_.FullName -Pattern "\p{IsCJKUnifiedIdeographs}" |
            ForEach-Object {
                $matches += [pscustomobject]@{
                    Path = $relativePath
                    Line = $_.LineNumber
                    Text = $_.Line.Trim()
                    Allowed = $isAllowed
                }
            }
    }

$sourceMatches = $matches | Where-Object { -not $_.Allowed }
$sourceFileCount = ($sourceMatches | Select-Object -ExpandProperty Path -Unique).Count
$allowedFileCount = (($matches | Where-Object { $_.Allowed }) | Select-Object -ExpandProperty Path -Unique).Count

Write-Host "Localization scan"
Write-Host "  Source files with Chinese still requiring localization: $sourceFileCount"
Write-Host "  Source Chinese lines still requiring localization: $($sourceMatches.Count)"
Write-Host "  Allowed localized files with Chinese: $allowedFileCount"

if ($sourceMatches.Count -gt 0) {
    Write-Host ""
    Write-Host "Top files:"
    $sourceMatches |
        Group-Object Path |
        Sort-Object Count -Descending |
        Select-Object -First 25 |
        ForEach-Object {
            Write-Host ("  {0,5}  {1}" -f $_.Count, $_.Name)
        }
}

if ($FailOnSourceChinese -and $sourceMatches.Count -gt 0) {
    exit 1
}
