# Ferramenta de desenvolvimento (nao vai para os jogadores): adiciona ao pack todos os mods do modlist.html.
# Uso: rode este script ou de dois cliques em batch-add.bat.
$packRoot = Split-Path -Parent $PSScriptRoot
Set-Location $packRoot

$modlist = Join-Path $packRoot 'modlist.html'
if (-not (Test-Path $modlist)) {
    Write-Host "modlist.html nao encontrado em $packRoot" -ForegroundColor Red
    exit 1
}

$ids = Select-String -Path $modlist -Pattern 'projects/(\d+)' -AllMatches |
    ForEach-Object { $_.Matches } |
    ForEach-Object { $_.Groups[1].Value } |
    Select-Object -Unique

Write-Host "Encontrados $($ids.Count) mods em modlist.html"
foreach ($id in $ids) {
    Write-Host "-> packwiz cf add --addon-id $id"
    packwiz -y cf add --addon-id $id
}

packwiz refresh
Write-Host "Pronto." -ForegroundColor Green
