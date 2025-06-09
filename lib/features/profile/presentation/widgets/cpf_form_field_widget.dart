import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CpfFormFieldWidget extends StatelessWidget {
  const CpfFormFieldWidget({super.key, required this.cpfController});
  final TextEditingController cpfController;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width * 0.7,
      child: TextField(
        controller: cpfController,
        enabled: false, // impede edição manual
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
