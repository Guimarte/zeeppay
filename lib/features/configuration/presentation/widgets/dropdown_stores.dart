import 'package:flutter/material.dart';
import 'package:zeeppay/shared/models/store_pos_model.dart';

class DropDownStores extends StatefulWidget {
  final List<StorePosModel> stores;
  final Function(StorePosModel) onChanged;
  final StorePosModel? initialValue;

  const DropDownStores({
    super.key,
    required this.stores,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<DropDownStores> createState() => _StoreDropdownState();
}

class _StoreDropdownState extends State<DropDownStores> {
  StorePosModel? selectedStore;

  @override
  void initState() {
    super.initState();
    // Sempre usa o initialValue se fornecido, senão pega a primeira
    selectedStore = widget.initialValue ??
                   (widget.stores.isNotEmpty ? widget.stores.first : null);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<StorePosModel>(
      value: selectedStore,
      isExpanded: true,
      hint: const Text('Selecione uma loja'),
      items: widget.stores.map((store) {
        return DropdownMenuItem<StorePosModel>(
          value: store,
          child: Text(store.name),
        );
      }).toList(),
      onChanged: (StorePosModel? newStore) {
        if (newStore != null) {
          setState(() => selectedStore = newStore);
          widget.onChanged(newStore);
        }
      },
    );
  }
}
