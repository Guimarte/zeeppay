@echo off
REM Script para buildar todos os flavors do projeto ZeepPay
REM Uso: build_all_flavors.bat [device] [build_type]
REM Exemplo: build_all_flavors.bat gpos760 apk
REM Exemplo: build_all_flavors.bat gpos780 appbundle

setlocal enabledelayedexpansion

REM Define o dispositivo (padrão: gpos760)
set DEVICE=%1
if "%DEVICE%"=="" set DEVICE=gpos760

REM Define o tipo de build (padrão: apk)
set BUILD_TYPE=%2
if "%BUILD_TYPE%"=="" set BUILD_TYPE=apk

REM Lista de flavors (marcas)
set FLAVORS=yano bandcard jbcard taustepay queirozpremium tridico sindbank

echo ========================================
echo Build All Flavors - ZeepPay
echo ========================================
echo Dispositivo: %DEVICE%
echo Tipo de build: %BUILD_TYPE%
echo ========================================
echo.

REM Contador de builds
set SUCCESS_COUNT=0
set FAIL_COUNT=0
set FAILED_FLAVORS=

REM Loop através dos flavors
for %%f in (%FLAVORS%) do (
    echo.
    echo ========================================
    echo Buildando: %%f-%DEVICE%
    echo ========================================

    if "%BUILD_TYPE%"=="apk" (
        flutter build apk --flavor %%f --dart-define=FLAVOR=%%f
    ) else if "%BUILD_TYPE%"=="appbundle" (
        flutter build appbundle --flavor %%f --dart-define=FLAVOR=%%f
    ) else (
        echo Tipo de build invalido: %BUILD_TYPE%
        echo Use 'apk' ou 'appbundle'
        exit /b 1
    )

    if !errorlevel! equ 0 (
        echo [OK] %%f buildado com sucesso!
        set /a SUCCESS_COUNT+=1
    ) else (
        echo [ERRO] Falha ao buildar %%f
        set /a FAIL_COUNT+=1
        set FAILED_FLAVORS=!FAILED_FLAVORS! %%f
    )
)

echo.
echo ========================================
echo Resumo do Build
echo ========================================
echo Sucesso: %SUCCESS_COUNT%
echo Falhas: %FAIL_COUNT%
if not "%FAILED_FLAVORS%"=="" (
    echo Flavors que falharam:%FAILED_FLAVORS%
)
echo ========================================

if %FAIL_COUNT% gtr 0 (
    exit /b 1
)

echo.
echo Todos os builds concluidos com sucesso!
echo Os arquivos estao em: build\app\outputs\flutter-apk\ ou build\app\outputs\bundle\
