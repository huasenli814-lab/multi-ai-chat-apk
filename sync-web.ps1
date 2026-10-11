# 把手机版的应用本体同步成仓库根目录的 index.html（两个副本保持一份内容）
$src = Join-Path (Split-Path $PSScriptRoot -Parent) 'mobile\index.html'
$dst = Join-Path $PSScriptRoot 'index.html'
if(!(Test-Path $src)){ Write-Error "找不到 $src"; exit 1 }
Copy-Item $src $dst -Force
Write-Output "已同步: $src -> $dst  ($((Get-Item $dst).Length) 字节)"
