import 'package:flutter/material.dart';

import '../../resources/spacing_resources.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    this.hintText,
    required this.items,
    required this.onSaved,
    this.validator,
    this.onChanged,
    this.selectedItem,
  });
  final String? hintText;
  final String? selectedItem;
  final List<String> items;
  final void Function(String?) onSaved;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? selectedItem;
  @override
  void initState() {
    if (widget.items.contains(widget.selectedItem)) {
      selectedItem = widget.selectedItem;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DropDownWidget oldWidget) {
    if (selectedItem != null) {
      if (!widget.items.contains(selectedItem!)) {
        selectedItem = null;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SpacingResources.mainWidth(context),
      child: Center(
        child: DropdownButtonFormField<String>(
          value: selectedItem,
          hint: hintText(),
          validator: widget.validator,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: widget.items.map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(
                "${widget.hintText ?? ""} : $e",
              ),
            );
          }).toList(),
          onSaved: (newValue) {
            widget.onSaved(newValue);
          },
          onChanged: (value) {
            setState(() {
              selectedItem = value;
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            });
          },
        ),
      ),
    );
  }

  Widget? hintText() {
    if (widget.hintText == null) return null;
    if (selectedItem != null) {
      return Text("${widget.hintText!} : $selectedItem");
    } else {
      return Text("${widget.hintText!} : غير محدد");
    }
  }
}
