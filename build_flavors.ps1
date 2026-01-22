#!/usr/bin/env pwsh
# Script PowerShell para buildar flavors do projeto ZeepPay
# Uso: .\build_flavors.ps1 (modo interativo)
# Uso: .\build_flavors.ps1 -Device gpos760 -BuildType apk -Flavors yano,bandcard
# Exemplo: .\build_flavors.ps1 -Device gpos780 -BuildType appbundle -Flavors taustepay

param(
    [string]$Device,
    [ValidateSet("apk", "appbundle", "")]
    [string]$BuildType,
    [string[]]$Flavors
)

# Configuração dos flavors com suas respectivas informações
$flavorConfigs = @{
    "devee" = @{
        Name = "Devee"
        Target = "lib/main.dart"
        FlavorName = "devee"
        UseToken = $true
    }
    "yano" = @{
        Name = "Yano"
        Target = "lib/flavors/main_yano.dart"
        FlavorName = "yano"
        UseToken = $false
    }
    "bandcard" = @{
        Name = "BandCard"
        Target = "lib/flavors/main_bandcard.dart"
        FlavorName = "bandcard"
        UseToken = $true
    }
    "jbcard" = @{
        Name = "JBCard"
        Target = "lib/flavors/main_jbcard.dart"
        FlavorName = "jbcard"
        UseToken = $true
    }
    "taustepay" = @{
        Name = "TaustePay"
        Target = "lib/flavors/main_taustepay.dart"
        FlavorName = "taustepay"
        UseToken = $true
    }
    "queirozpremium" = @{
        Name = "QueirozPremium"
        Target = "lib/flavors/main_queirozpremium.dart"
        FlavorName = "queirozpremium"
        UseToken = $true
    }
    "tridico" = @{
        Name = "TridicoPay"
        Target = "lib/flavors/main_tridicopay.dart"
        FlavorName = "tridico"
        UseToken = $true
    }
    "sindbank" = @{
        Name = "SindBank"
        Target = "lib/flavors/main_sindbank.dart"
        FlavorName = "sindbank"
        UseToken = $true
    }
}

# Função para exibir menu interativo
function Show-Menu {
    param([string]$Title, [array]$Options)

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " $Title" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    for ($i = 0; $i -lt $Options.Count; $i++) {
        Write-Host "  [$($i + 1)] $($Options[$i])" -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "  [0] Cancelar" -ForegroundColor Red
    Write-Host ""
}

# Modo interativo
if (-not $Device -or -not $BuildType -or -not $Flavors) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " ZeepPay - Build Flavors" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    # Selecionar dispositivo
    if (-not $Device) {
        Show-Menu -Title "Selecione o Dispositivo" -Options @("GPOS760", "GPOS780", "Ambos")
        $deviceChoice = Read-Host "Escolha uma opcao"

        switch ($deviceChoice) {
            "1" { $Device = "gpos760" }
            "2" { $Device = "gpos780" }
            "3" { $Device = "both" }
            "0" { Write-Host "Cancelado pelo usuario" -ForegroundColor Red; exit 0 }
            default { Write-Host "Opcao invalida" -ForegroundColor Red; exit 1 }
        }
    }

    # Selecionar tipo de build
    if (-not $BuildType) {
        Show-Menu -Title "Selecione o Tipo de Build" -Options @("APK", "App Bundle")
        $buildChoice = Read-Host "Escolha uma opcao"

        switch ($buildChoice) {
            "1" { $BuildType = "apk" }
            "2" { $BuildType = "appbundle" }
            "0" { Write-Host "Cancelado pelo usuario" -ForegroundColor Red; exit 0 }
            default { Write-Host "Opcao invalida" -ForegroundColor Red; exit 1 }
        }
    }

    # Selecionar flavors
    if (-not $Flavors) {
        $flavorNames = $flavorConfigs.Keys | Sort-Object
        $flavorOptions = $flavorNames | ForEach-Object { $flavorConfigs[$_].Name }
        $flavorOptions += "Todos os flavors"

        Show-Menu -Title "Selecione os Flavors para Buildar" -Options $flavorOptions
        Write-Host "  Digite os numeros separados por virgula (ex: 1,3,5)" -ForegroundColor Gray
        Write-Host "  Ou pressione ENTER para buildar todos" -ForegroundColor Gray
        Write-Host ""

        $flavorChoice = Read-Host "Escolha"

        if ([string]::IsNullOrWhiteSpace($flavorChoice)) {
            $Flavors = $flavorNames
        } elseif ($flavorChoice -eq "0") {
            Write-Host "Cancelado pelo usuario" -ForegroundColor Red
            exit 0
        } else {
            $choices = $flavorChoice -split ',' | ForEach-Object { $_.Trim() }
            $Flavors = @()

            foreach ($choice in $choices) {
                $index = [int]$choice - 1
                if ($index -ge 0 -and $index -lt $flavorNames.Count) {
                    $Flavors += $flavorNames[$index]
                } elseif ($choice -eq ($flavorOptions.Count).ToString()) {
                    $Flavors = $flavorNames
                    break
                }
            }

            if ($Flavors.Count -eq 0) {
                Write-Host "Nenhum flavor valido selecionado" -ForegroundColor Red
                exit 1
            }
        }
    }
}

# Determinar quais dispositivos buildar
$devices = if ($Device -eq "both") { @("gpos760", "gpos780") } else { @($Device) }

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Configuracao do Build" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Dispositivos: $($devices -join ', ')" -ForegroundColor White
Write-Host "Tipo de build: $BuildType" -ForegroundColor White
Write-Host "Flavors: $($Flavors.Count) selecionado(s)" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$results = @()
$totalBuilds = $devices.Count * $Flavors.Count
$currentBuild = 0

# Loop através dos dispositivos e flavors
foreach ($dev in $devices) {
    foreach ($flavorKey in $Flavors) {
        $currentBuild++
        $config = $flavorConfigs[$flavorKey]

        if (-not $config) {
            Write-Host "[ERRO] Flavor '$flavorKey' nao encontrado na configuracao" -ForegroundColor Red
            continue
        }

        $flavorName = "$dev$($config.FlavorName.Substring(0,1).ToUpper())$($config.FlavorName.Substring(1))"

        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "[$currentBuild/$totalBuilds] Buildando: $($config.Name) - $dev" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green

        $startTime = Get-Date

        # Montar comando de build
        $buildArgs = @(
            "build",
            $BuildType,
            "--release",
            "--flavor", $flavorName,
            "--target", $config.Target,
            "--dart-define=DEVICE_MODEL=$dev"
        )

        # Adicionar token se necessário
        if ($config.UseToken) {
            $buildArgs += "--dart-define-from-file=envs/token.json"
        }

        Write-Host "Comando: flutter $($buildArgs -join ' ')" -ForegroundColor Gray
        Write-Host ""

        # Executar build
        & flutter $buildArgs

        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds
        $success = $LASTEXITCODE -eq 0

        $results += [PSCustomObject]@{
            Flavor = $config.Name
            Device = $dev
            Success = $success
            Duration = $duration
        }

        if ($success) {
            Write-Host ""
            Write-Host "[OK] $($config.Name) - $dev buildado com sucesso em $([math]::Round($duration, 2))s" -ForegroundColor Green
        } else {
            Write-Host ""
            Write-Host "[ERRO] Falha ao buildar $($config.Name) - $dev" -ForegroundColor Red
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
$totalTime = ($results | Measure-Object -Property Duration -Sum).Sum

Write-Host "Total de builds: $totalBuilds" -ForegroundColor White
Write-Host "Sucesso: $successCount" -ForegroundColor Green
Write-Host "Falhas: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })
Write-Host "Tempo total: $([math]::Round($totalTime, 2))s" -ForegroundColor Yellow

if ($failCount -gt 0) {
    Write-Host ""
    Write-Host "Builds que falharam:" -ForegroundColor Red
    $results | Where-Object { -not $_.Success } | ForEach-Object {
        Write-Host "  - $($_.Flavor) ($($_.Device))" -ForegroundColor Red
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($failCount -eq 0) {
    Write-Host "Todos os builds concluidos com sucesso!" -ForegroundColor Green

    if ($BuildType -eq "apk") {
        Write-Host "APKs gerados em: build\app\outputs\flutter-apk\" -ForegroundColor Yellow
    } else {
        Write-Host "App Bundles gerados em: build\app\outputs\bundle\" -ForegroundColor Yellow
    }

    exit 0
} else {
    exit 1
}
