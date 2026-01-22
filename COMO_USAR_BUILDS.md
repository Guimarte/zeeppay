# Como Usar os Scripts de Build

## Script PowerShell Interativo (RECOMENDADO)

### Passo 1: Habilitar Execução de Scripts PowerShell

Abra o PowerShell como **Administrador** e execute:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Passo 2: Executar o Script

#### Modo Interativo (Mais Fácil)
Simplesmente execute o script sem parâmetros:

```powershell
.\build_flavors.ps1
```

O script vai te guiar com menus para:
1. Selecionar o dispositivo (GPOS760, GPOS780 ou Ambos)
2. Selecionar o tipo de build (APK ou App Bundle)
3. Selecionar quais flavors buildar (pode escolher múltiplos ou todos)

#### Modo Linha de Comando
Se preferir, pode passar os parâmetros diretamente:

```powershell
# Buildar Yano e BandCard para GPOS760 em APK
.\build_flavors.ps1 -Device gpos760 -BuildType apk -Flavors yano,bandcard

# Buildar TaustePay para ambos os dispositivos em App Bundle
.\build_flavors.ps1 -Device both -BuildType appbundle -Flavors taustepay

# Buildar todos os flavors para GPOS780
.\build_flavors.ps1 -Device gpos780 -BuildType apk
```

## Flavors Disponíveis

| Flavor | Nome | Usa Token | Target |
|--------|------|-----------|--------|
| devee | Devee | ✅ | lib/main.dart |
| yano | Yano | ❌ | lib/flavors/main_yano.dart |
| bandcard | BandCard | ✅ | lib/flavors/main_bandcard.dart |
| jbcard | JBCard | ✅ | lib/flavors/main_jbcard.dart |
| taustepay | TaustePay | ✅ | lib/flavors/main_taustepay.dart |
| queirozpremium | QueirozPremium | ✅ | lib/flavors/main_queirozpremium.dart |
| tridico | TridicoPay | ✅ | lib/flavors/main_tridicopay.dart |
| sindbank | SindBank | ✅ | lib/flavors/main_sindbank.dart |

## Configurações Aplicadas

O script automaticamente aplica as configurações corretas de acordo com o `launch.json`:

- **Dispositivo GPOS760 ou GPOS780** - definido via `--dart-define=DEVICE_MODEL`
- **Target correto** - cada flavor tem seu arquivo main específico
- **Token** - aplica `--dart-define-from-file=envs/token.json` quando necessário

## Saída dos Builds

### APK
```
build\app\outputs\flutter-apk\
```

### App Bundle
```
build\app\outputs\bundle\
```

## Solução de Problemas

### "Não é possível carregar o arquivo porque a execução de scripts foi desabilitada"

Execute como Administrador:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "flutter não é reconhecido"

Certifique-se de que o Flutter está no PATH do sistema.

### Builds falhando

1. Verifique se o arquivo `envs/token.json` existe (para flavors que usam token)
2. Execute `flutter clean` antes de buildar
3. Verifique se todas as dependências estão instaladas com `flutter pub get`

## Scripts Alternativos

### build_all_flavors.bat (Windows - CMD)
```batch
build_all_flavors.bat gpos760 apk
```

### build_all_flavors.sh (Linux/Mac)
```bash
chmod +x build_all_flavors.sh
./build_all_flavors.sh gpos760 apk
```

### build_all_flavors.ps1 (Antigo - build paralelo)
```powershell
.\build_all_flavors.ps1 -Device gpos760 -BuildType apk -Parallel
```

---

**Recomendação:** Use `build_flavors.ps1` no modo interativo para a melhor experiência!
