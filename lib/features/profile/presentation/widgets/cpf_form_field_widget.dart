import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeeppay/flavors/flavor_config.dart';

class CpfFormFieldWidget extends StatefulWidget {
  const CpfFormFieldWidget({super.key, required this.cpfController});
  final TextEditingController cpfController;

  @override
  State<CpfFormFieldWidget> createState() => _CpfFormFieldWidgetState();
}

class _CpfFormFieldWidgetState extends State<CpfFormFieldWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    final hasPhysicalKeyboard = FlavorConfig.instance.hasPhysicalKeyboard;
    if (hasPhysicalKeyboard) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final hasPhysicalKeyboard = FlavorConfig.instance.hasPhysicalKeyboard;

    return SizedBox(
      width: width * 0.7,
      child: TextField(
        controller: widget.cpfController,
        focusNode: _focusNode,
        enabled: hasPhysicalKeyboard ? true : false,
        readOnly: !hasPhysicalKeyboard,
        keyboardType: hasPhysicalKeyboard ? TextInputType.none : null,
        maxLength: hasPhysicalKeyboard ? 14 : null,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: '000.000.000-00',
          prefixIcon: const Icon(Icons.perm_identity),
          filled: true,
          fillColor: Colors.grey.shade200,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';

    for (int i = 0; i < digits.length && i < 11; i++) {
      if (i == 3 || i == 6) formatted += '.';
      if (i == 9) formatted += '-';
      formatted += digits[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

bool isValidCPF(String cpf) {
  cpf = cpf.replaceAll(RegExp(r'\D'), '');

  if (cpf.length != 11 || RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;

  List<int> digits = cpf.split('').map(int.parse).toList();

  int calcDigit(List<int> slice, int factor) {
    int sum = 0;
    for (int i = 0; i < slice.length; i++) {
      sum += slice[i] * (factor - i);
    }
    int mod = (sum * 10) % 11;
    return mod == 10 ? 0 : mod;
  }

  int d1 = calcDigit(digits.sublist(0, 9), 10);
  int d2 = calcDigit(digits.sublist(0, 10), 11);

  return d1 == digits[9] && d2 == digits[10];
}
