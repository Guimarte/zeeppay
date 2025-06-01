import 'package:flutter/material.dart';
import 'package:zeeppay/shared/models/store_pos_model.dart';

class DropDownStores extends StatefulWidget {
  final List<StorePosModel> stores;
  final Function(StorePosModel) onChanged;

  const DropDownStores({
    super.key,
    required this.stores,
    required this.onChanged,
  });

  @override
  State<DropDownStores> createState() => _StoreDropdownState();
}

class _StoreDropdownState extends State<DropDownStores> {
  StorePosModel? selectedStore;

  @override
  void initState() {
    super.initState();
    if (widget.stores.isNotEmpty) {
      selectedStore = widget.stores.first;
      widget.onChanged(selectedStore!);
    }
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
