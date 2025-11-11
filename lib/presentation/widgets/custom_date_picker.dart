import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      widget.controller.text = Formatters.date(widget.initialDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      validator: widget.validator,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: widget.initialDate ?? DateTime.now(),
          firstDate: widget.firstDate ?? DateTime(2000),
          lastDate: widget.lastDate ?? DateTime(2101),
          locale: const Locale('pt', 'BR'),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          setState(() {
            widget.controller.text = Formatters.date(pickedDate);
          });
        }
      },
    );
  }
}