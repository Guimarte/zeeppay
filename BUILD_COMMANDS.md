# Comandos de Build - ZeepPay

Este documento contém todos os comandos necessários para gerar APKs e App Bundles para cada flavor da aplicação.

## Estrutura de Flavors

A aplicação possui duas dimensões de flavors:
- **Device**: `gpos760` e `gpos780`
- **Brand**: `devee`, `yano`, `bandcard`, `jbcard`, `taustepay`, `queirozpremium`, `tridico`, `sindbank`

## Comandos para Gerar APK (Release)

### GPOS 760

#### Devee
```bash
flutter build apk --flavor gpos760Devee --target lib/flavors/main_devee.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Yano
```bash
flutter build apk --flavor gpos760Yano --target lib/flavors/main_yano.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Bandcard
```bash
flutter build apk --flavor gpos760Bandcard --target lib/flavors/main_bandcard.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### JBCard
```bash
flutter build apk --flavor gpos760Jbcard --target lib/flavors/main_jbcard.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Taustepay
```bash
flutter build apk --flavor gpos760Taustepay --target lib/flavors/main_taustepay.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Queiroz Premium
```bash
flutter build apk --flavor gpos760Queirozpremium --target lib/flavors/main_queirozpremium.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Tridicopay
```bash
flutter build apk --flavor gpos760Tridico --target lib/flavors/main_tridicopay.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Sindbank
```bash
flutter build apk --flavor gpos760Sindbank --target lib/flavors/main_sindbank.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

---

### GPOS 780

#### Devee
```bash
flutter build apk --flavor gpos780Devee --target lib/flavors/main_devee.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Yano
```bash
flutter build apk --flavor gpos780Yano --target lib/flavors/main_yano.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Bandcard
```bash
flutter build apk --flavor gpos780Bandcard --target lib/flavors/main_bandcard.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### JBCard
```bash
flutter build apk --flavor gpos780Jbcard --target lib/flavors/main_jbcard.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Taustepay
```bash
flutter build apk --flavor gpos780Taustepay --target lib/flavors/main_taustepay.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Queiroz Premium
```bash
flutter build apk --flavor gpos780Queirozpremium --target lib/flavors/main_queirozpremium.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Tridicopay
```bash
flutter build apk --flavor gpos780Tridico --target lib/flavors/main_tridicopay.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Sindbank
```bash
flutter build apk --flavor gpos780Sindbank --target lib/flavors/main_sindbank.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

---

## Comandos para Gerar App Bundle (Para Google Play Store)

### GPOS 760

#### Devee
```bash
flutter build appbundle --flavor gpos760Devee --target lib/flavors/main_devee.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Yano
```bash
flutter build appbundle --flavor gpos760Yano --target lib/flavors/main_yano.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Bandcard
```bash
flutter build appbundle --flavor gpos760Bandcard --target lib/flavors/main_bandcard.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### JBCard
```bash
flutter build appbundle --flavor gpos760Jbcard --target lib/flavors/main_jbcard.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Taustepay
```bash
flutter build appbundle --flavor gpos760Taustepay --target lib/flavors/main_taustepay.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Queiroz Premium
```bash
flutter build appbundle --flavor gpos760Queirozpremium --target lib/flavors/main_queirozpremium.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Tridicopay
```bash
flutter build appbundle --flavor gpos760Tridico --target lib/flavors/main_tridicopay.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

#### Sindbank
```bash
flutter build appbundle --flavor gpos760Sindbank --target lib/flavors/main_sindbank.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release
```

---

### GPOS 780

#### Devee
```bash
flutter build appbundle --flavor gpos780Devee --target lib/flavors/main_devee.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Yano
```bash
flutter build appbundle --flavor gpos780Yano --target lib/flavors/main_yano.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Bandcard
```bash
flutter build appbundle --flavor gpos780Bandcard --target lib/flavors/main_bandcard.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### JBCard
```bash
flutter build appbundle --flavor gpos780Jbcard --target lib/flavors/main_jbcard.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Taustepay
```bash
flutter build appbundle --flavor gpos780Taustepay --target lib/flavors/main_taustepay.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Queiroz Premium
```bash
flutter build appbundle --flavor gpos780Queirozpremium --target lib/flavors/main_queirozpremium.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Tridicopay
```bash
flutter build appbundle --flavor gpos780Tridico --target lib/flavors/main_tridicopay.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

#### Sindbank
```bash
flutter build appbundle --flavor gpos780Sindbank --target lib/flavors/main_sindbank.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos780 --release
```

---

## Localização dos Arquivos Gerados

### APKs
Os APKs gerados estarão localizados em:
```
build/app/outputs/flutter-apk/app-[device]-[brand]-release.apk
```

Exemplo:
```
build/app/outputs/flutter-apk/app-gpos760-tridico-release.apk
```

### App Bundles
Os App Bundles gerados estarão localizados em:
```
build/app/outputs/bundle/[device][Brand]Release/app-[device]-[brand]-release.aab
```

Exemplo:
```
build/app/outputs/bundle/gpos760TridicoRelease/app-gpos760-tridico-release.aab
```

---

## Notas Importantes

1. **Arquivo token.json**: Certifique-se de que o arquivo `envs/token.json` existe e contém as configurações necessárias.

2. **Assinatura do APK**: Os APKs/Bundles de release são assinados automaticamente usando as credenciais em `android/app/key.properties`.

3. **DEVICE_MODEL**: O parâmetro `--dart-define=DEVICE_MODEL` é crucial para determinar se o dispositivo usa teclado físico (gpos760) ou virtual (gpos780).

4. **Google Play Store**: Para publicar na Play Store, use App Bundle (`.aab`) em vez de APK (`.apk`).

5. **Ícones por Flavor**: Certifique-se de que cada pasta em `assets/flavors/[brand]/` contém um arquivo `icon.png` (512x512px recomendado).

---

## Comandos Úteis

### Limpar build anterior
```bash
flutter clean
flutter pub get
```

### Verificar flavors disponíveis
```bash
flutter build apk --flavor
```

### Build para todas as arquiteturas (APK universal)
Adicione `--split-per-abi` para gerar APKs separados por arquitetura (reduz tamanho):
```bash
flutter build apk --flavor gpos760Tridico --target lib/flavors/main_tridicopay.dart --dart-define-from-file=envs/token.json --dart-define=DEVICE_MODEL=gpos760 --release --split-per-abi
```
