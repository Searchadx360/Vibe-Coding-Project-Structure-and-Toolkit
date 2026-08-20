# Bootstrap the "vibe coding" project structure into a target directory.
# Safe to re-run: only creates files/folders that don't already exist,
# never overwrites anything.
#
# Usage: pwsh bootstrap.ps1 -Path C:\path\to\project [-WithActions] [-WithContext]
#
#   -WithActions   also install the GitHub Actions review/maintenance
#                   templates into .github/workflows/ (these run on a
#                   schedule and cost real API money - see
#                   references/github-actions.md before enabling)
#   -WithContext   also create CONTEXT.md for human-authored narrative
#                   context, split out from CLAUDE.md

param(
    [string]$Path = ".",
    [switch]$WithActions,
    [switch]$WithContext
)

$SkillDir = Split-Path -Parent $PSScriptRoot
$Target = (Resolve-Path $Path).Path

New-Item -ItemType Directory -Force -Path `
    "$Target\.claude\rules", `
    "$Target\.claude\commands", `
    "$Target\.claude\skills", `
    "$Target\.claude\agents", `
    "$Target\.claude\hooks" | Out-Null

function Copy-IfMissing {
    param([string]$Src, [string]$Dest)
    if (Test-Path $Dest) {
        Write-Host "skip  (exists) $Dest"
    } else {
        Copy-Item $Src $Dest
        Write-Host "create         $Dest"
    }
}

Copy-IfMissing "$SkillDir\assets\CLAUDE.md.template"          "$Target\CLAUDE.md"
Copy-IfMissing "$SkillDir\assets\CLAUDE.local.md.template"    "$Target\CLAUDE.local.md"
Copy-IfMissing "$SkillDir\assets\settings.json.template"       "$Target\.claude\settings.json"
Copy-IfMissing "$SkillDir\assets\settings.local.json.template" "$Target\.claude\settings.local.json"
Copy-IfMissing "$SkillDir\assets\mcp.json.template"            "$Target\.mcp.json"
Copy-IfMissing "$SkillDir\assets\hooks\skill-eval.js"          "$Target\.claude\hooks\skill-eval.js"
Copy-IfMissing "$SkillDir\assets\hooks\skill-rules.json.template" "$Target\.claude\hooks\skill-rules.json"

# .gitignore: append the personal-override lines if they're not already there
$GitIgnore = "$Target\.gitignore"
if (-not (Test-Path $GitIgnore)) {
    New-Item -ItemType File -Path $GitIgnore | Out-Null
}
$ignoreContent = Get-Content $GitIgnore -Raw -ErrorAction SilentlyContinue
if (-not $ignoreContent -or -not ($ignoreContent -match [regex]::Escape(".claude/settings.local.json"))) {
    Get-Content "$SkillDir\assets\gitignore.append.txt" | Add-Content $GitIgnore
    Write-Host "append         $GitIgnore (.claude/settings.local.json, CLAUDE.local.md)"
} else {
    Write-Host "skip  (exists) $GitIgnore already ignores personal-override files"
}

if ($WithContext) {
    Copy-IfMissing "$SkillDir\assets\CONTEXT.md.template" "$Target\CONTEXT.md"
}

if ($WithActions) {
    New-Item -ItemType Directory -Force -Path "$Target\.github\workflows" | Out-Null
    Get-ChildItem "$SkillDir\assets\github-actions\*.yml" | ForEach-Object {
        Copy-IfMissing $_.FullName "$Target\.github\workflows\$($_.Name)"
    }
    Write-Host ""
    Write-Host "GitHub Actions templates installed. Before they run for real:"
    Write-Host "  - Add ANTHROPIC_API_KEY as a repository secret."
    Write-Host "  - Read references/github-actions.md for what each one costs."
    Write-Host "  - They reference .claude/agents/code-reviewer.md - create it first."
}

Write-Host ""
Write-Host "Done. Next steps:"
Write-Host "  1. Fill in $Target\CLAUDE.md with real project facts."
Write-Host "  2. Fill in $Target\.claude\hooks\skill-rules.json once you add real skills."
Write-Host "  3. Add rules/commands/skills/agents only as you actually need them."
Write-Host "  4. See the skill's references\ folder for what each piece is for."
