#!/bin/bash
# Script para buildar todos os flavors do projeto ZeepPay
# Uso: ./build_all_flavors.sh [device] [build_type]
# Exemplo: ./build_all_flavors.sh gpos760 apk
# Exemplo: ./build_all_flavors.sh gpos780 appbundle

set -e

# Define o dispositivo (padrão: gpos760)
DEVICE=${1:-gpos760}

# Define o tipo de build (padrão: apk)
BUILD_TYPE=${2:-apk}

# Lista de flavors (marcas)
FLAVORS=("yano" "bandcard" "jbcard" "taustepay" "queirozpremium" "tridico" "sindbank")

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Build All Flavors - ZeepPay${NC}"
echo -e "${CYAN}========================================${NC}"
echo "Dispositivo: $DEVICE"
echo "Tipo de build: $BUILD_TYPE"
echo -e "${CYAN}========================================${NC}"
echo ""

# Valida o tipo de build
if [[ "$BUILD_TYPE" != "apk" && "$BUILD_TYPE" != "appbundle" ]]; then
    echo -e "${RED}Tipo de build inválido: $BUILD_TYPE${NC}"
    echo "Use 'apk' ou 'appbundle'"
    exit 1
fi

# Contador de builds
SUCCESS_COUNT=0
FAIL_COUNT=0
FAILED_FLAVORS=()

# Loop através dos flavors
for flavor in "${FLAVORS[@]}"; do
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Buildando: $flavor-$DEVICE${NC}"
    echo -e "${GREEN}========================================${NC}"

    START_TIME=$(date +%s)

    if [ "$BUILD_TYPE" == "apk" ]; then
        if flutter build apk --flavor "$flavor" --dart-define=FLAVOR="$flavor"; then
            END_TIME=$(date +%s)
            DURATION=$((END_TIME - START_TIME))
            echo -e "${GREEN}[OK] $flavor buildado com sucesso em ${DURATION}s${NC}"
            ((SUCCESS_COUNT++))
        else
            echo -e "${RED}[ERRO] Falha ao buildar $flavor${NC}"
            ((FAIL_COUNT++))
            FAILED_FLAVORS+=("$flavor")
        fi
    else
        if flutter build appbundle --flavor "$flavor" --dart-define=FLAVOR="$flavor"; then
            END_TIME=$(date +%s)
            DURATION=$((END_TIME - START_TIME))
            echo -e "${GREEN}[OK] $flavor buildado com sucesso em ${DURATION}s${NC}"
            ((SUCCESS_COUNT++))
        else
            echo -e "${RED}[ERRO] Falha ao buildar $flavor${NC}"
            ((FAIL_COUNT++))
            FAILED_FLAVORS+=("$flavor")
        fi
    fi
done

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Resumo do Build${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}Sucesso: $SUCCESS_COUNT${NC}"
echo -e "$([ $FAIL_COUNT -gt 0 ] && echo ${RED} || echo ${GREEN})Falhas: $FAIL_COUNT${NC}"

if [ ${#FAILED_FLAVORS[@]} -gt 0 ]; then
    echo -e "${RED}Flavors que falharam: ${FAILED_FLAVORS[*]}${NC}"
fi

echo -e "${CYAN}========================================${NC}"

if [ $FAIL_COUNT -gt 0 ]; then
    exit 1
fi

echo ""
echo -e "${GREEN}Todos os builds concluídos com sucesso!${NC}"
echo -e "${YELLOW}Os arquivos estão em: build/app/outputs/flutter-apk/ ou build/app/outputs/bundle/${NC}"
