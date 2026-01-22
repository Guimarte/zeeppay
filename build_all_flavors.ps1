#!/usr/bin/env pwsh
# Script PowerShell para buildar todos os flavors do projeto ZeepPay
# Uso: .\build_all_flavors.ps1 [-Device gpos760] [-BuildType apk] [-Parallel]
# Exemplo: .\build_all_flavors.ps1 -Device gpos780 -BuildType appbundle

param(
    [string]$Device = "gpos760",
    [ValidateSet("apk", "appbundle")]
    [string]$BuildType = "apk",
    [switch]$Parallel
)

$flavors = @("yano", "bandcard", "jbcard", "taustepay", "queirozpremium", "tridico", "sindbank")

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Build All Flavors - ZeepPay" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Dispositivo: $Device"
Write-Host "Tipo de build: $BuildType"
Write-Host "Modo paralelo: $($Parallel.IsPresent)"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$results = @()

if ($Parallel) {
    # Build paralelo (mais rápido, mas usa mais recursos)
    Write-Host "Iniciando builds em paralelo..." -ForegroundColor Yellow

    $jobs = $flavors | ForEach-Object {
        $flavor = $_
        Start-Job -ScriptBlock {
            param($flavor, $device, $buildType)

            $output = if ($buildType -eq "apk") {
                flutter build apk --flavor $flavor --dart-define=FLAVOR=$flavor 2>&1
            } else {
                flutter build appbundle --flavor $flavor --dart-define=FLAVOR=$flavor 2>&1
            }

            return @{
                Flavor = $flavor
                Success = $LASTEXITCODE -eq 0
                Output = $output
            }
        } -ArgumentList $_, $Device, $BuildType
    }

    # Aguarda todos os jobs terminarem
    $jobs | Wait-Job | Receive-Job | ForEach-Object {
        $results += $_
    }

    $jobs | Remove-Job
} else {
    # Build sequencial (mais lento, mas mais estável)
    foreach ($flavor in $flavors) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "Buildando: $flavor-$Device" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green

        $startTime = Get-Date

        if ($BuildType -eq "apk") {
            flutter build apk --flavor $flavor --dart-define=FLAVOR=$flavor
        } else {
            flutter build appbundle --flavor $flavor --dart-define=FLAVOR=$flavor
        }

        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds

        $success = $LASTEXITCODE -eq 0

        $results += @{
            Flavor = $flavor
            Success = $success
            Duration = $duration
        }

        if ($success) {
            Write-Host "[OK] $flavor buildado com sucesso em $([math]::Round($duration, 2))s" -ForegroundColor Green
        } else {
            Write-Host "[ERRO] Falha ao buildar $flavor" -ForegroundColor Red
        }
    }
}

# Resumo
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Resumo do Build" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$successCount = ($results | Where-Object { $_.Success }).Count
$failCount = ($results | Where-Object { -not $_.Success }).Count

Write-Host "Sucesso: $successCount" -ForegroundColor Green
Write-Host "Falhas: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })

if ($failCount -gt 0) {
    $failedFlavors = ($results | Where-Object { -not $_.Success }).Flavor -join ", "
    Write-Host "Flavors que falharam: $failedFlavors" -ForegroundColor Red
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($failCount -eq 0) {
    Write-Host "Todos os builds concluídos com sucesso!" -ForegroundColor Green
    Write-Host "Os arquivos estão em: build\app\outputs\flutter-apk\ ou build\app\outputs\bundle\" -ForegroundColor Yellow
    exit 0
} else {
    exit 1
}
