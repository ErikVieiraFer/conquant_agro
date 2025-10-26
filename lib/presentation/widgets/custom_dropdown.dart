import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final String labelText;
  final T? selectedItem;
  final Function(T?) onChanged;
  final String? Function(T?)? validator;
  final String Function(T)? itemAsString;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.labelText,
    this.selectedItem,
    required this.onChanged,
    this.validator,
    this.itemAsString,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: items,
      selectedItem: selectedItem,
      onChanged: onChanged,
      validator: validator,
      itemAsString: itemAsString ?? (item) => item.toString(),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      popupProps: const PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            hintText: "Buscar...",
          ),
        ),
      ),
    );
  }
}