# Rebrand Script: Arah Berita → Bandung News
# This script performs comprehensive rebranding of the website

Write-Host "Starting rebrand script..."

# Backup articles.json
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
Copy-Item "articles.json" "articles.json.bak.$timestamp" -Force
Write-Host "Backup created: articles.json.bak.$timestamp"

# Initialize counters
$mainPagesChanged = 0
$articlePagesChanged = 0
$cssChanged = 0
$packageChanged = 0
$docsChanged = 0

Write-Host "Initialized counters"

# Function to perform replacements
function Replace-InFile {
    param($filePath, $oldString, $newString)
    try {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        $newContent = $content -replace [regex]::Escape($oldString), $newString
        if ($newContent -ne $content) {
            Set-Content $filePath $newContent -Encoding UTF8
            return $true
        }
    } catch {
        Write-Host "Error processing $filePath : $_"
    }
    return $false
}

Write-Host "Defined function"

# Get all relevant files
$files = Get-ChildItem -Recurse -Include *.html,*.css,*.json,*.md | Where-Object { $_.FullName -notlike "*node_modules*" }
Write-Host "Found $($files.Count) files to process"

foreach ($file in $files) {
    $changed = $false
    
    # Branding replacements
    $changed = $changed -or (Replace-InFile $file.FullName "Arah Berita" "Bandung News")
    $changed = $changed -or (Replace-InFile $file.FullName "arahberita" "bandungnews")
    $changed = $changed -or (Replace-InFile $file.FullName "ArahBerita" "BandungNews")
    
    # Email
    $changed = $changed -or (Replace-InFile $file.FullName "arahberita@gmail.com" "bandungnews@gmail.com")
    
    # Social handles
    $changed = $changed -or (Replace-InFile $file.FullName "twitter.com/arahberita" "twitter.com/bandungnews")
    $changed = $changed -or (Replace-InFile $file.FullName "facebook.com/arahberita" "facebook.com/bandungnews")
    $changed = $changed -or (Replace-InFile $file.FullName "instagram.com/arahberita" "instagram.com/bandungnews")
    $changed = $changed -or (Replace-InFile $file.FullName "linkedin.com/company/arahberita" "linkedin.com/company/bandungnews")
    $changed = $changed -or (Replace-InFile $file.FullName "youtube.com/@arahberita" "youtube.com/@bandungnews")
    
    # Title suffix
    $changed = $changed -or (Replace-InFile $file.FullName "- Arah Berita" "- Bandung News")
    
    # Colors - CSS variables
    $changed = $changed -or (Replace-InFile $file.FullName "--primary: #1D4ED8" "--primary: #0F766E")
    $changed = $changed -or (Replace-InFile $file.FullName "--dark: #1E3A8A" "--dark: #042F2E")
    $changed = $changed -or (Replace-InFile $file.FullName "--secondary: #7F2F4F" "--secondary: #1F3F5F")
    
    # Inline colors
    $changed = $changed -or (Replace-InFile $file.FullName "#1D4ED8" "#0F766E")
    $changed = $changed -or (Replace-InFile $file.FullName "#7F2F4F" "#1F3F5F")
    $changed = $changed -or (Replace-InFile $file.FullName "#1E3A8A" "#042F2E")
    
    # Logo replacement - remove img/logo.png and replace with text logo
    $changed = $changed -or (Replace-InFile $file.FullName '<img src="../img/logo.png" alt="Arah Berita">' '<span style="font-weight: bold; color: #0F766E;">BANDUNG</span><span style="color: #1F3F5F;">NEWS</span>')
    $changed = $changed -or (Replace-InFile $file.FullName '<img src="img/logo.png" alt="Arah Berita">' '<span style="font-weight: bold; color: #0F766E;">BANDUNG</span><span style="color: #1F3F5F;">NEWS</span>')
    $changed = $changed -or (Replace-InFile $file.FullName 'img src="../img/logo.png"' 'span style="font-weight: bold; color: #0F766E;">BANDUNG</span><span style="color: #1F3F5F;">NEWS</span>')
    $changed = $changed -or (Replace-InFile $file.FullName 'img src="img/logo.png"' 'span style="font-weight: bold; color: #1F3F5F;">NEWS</span>')
    
    # Encoding fixes
    $changed = $changed -or (Replace-InFile $file.FullName '"' '"')
    $changed = $changed -or (Replace-InFile $file.FullName '"' '"')
    $changed = $changed -or (Replace-InFile $file.FullName "'" "'")
    $changed = $changed -or (Replace-InFile $file.FullName "'" "'")
    $changed = $changed -or (Replace-InFile $file.FullName "–" "-")
    $changed = $changed -or (Replace-InFile $file.FullName "—" "-")
    $changed = $changed -or (Replace-InFile $file.FullName " " " ")  # nbsp to space
    
    # Package names
    $changed = $changed -or (Replace-InFile $file.FullName '"name": "arahberita"' '"name": "bandungnews"')
    $changed = $changed -or (Replace-InFile $file.FullName '"name": "indonesiadaily"' '"name": "bandungnews"')
    $changed = $changed -or (Replace-InFile $file.FullName '"name": "arahberita-article-generator"' '"name": "bandungnews-article-generator"')
    
    if ($changed) {
        if ($file.Directory.Name -eq "article") {
            $articlePagesChanged++
        } elseif ($file.Extension -eq ".css") {
            $cssChanged++
        } elseif ($file.Name -like "package*") {
            $packageChanged++
        } elseif ($file.Extension -eq ".md") {
            $docsChanged++
        } else {
            $mainPagesChanged++
        }
    }
}

Write-Host "Processing complete"

# Output results
Write-Host "Rebrand Bandung News selesai ✅"
Write-Host "File yang diubah:"
Write-Host "  - Main pages: $mainPagesChanged"
Write-Host "  - Article pages: $articlePagesChanged"
Write-Host "  - CSS: $cssChanged"
Write-Host "  - Package: $packageChanged"
Write-Host "  - Docs: $docsChanged"