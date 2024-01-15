import 'package:flutter/material.dart';

class DropdownItems<T> extends StatelessWidget {
  const DropdownItems({
    super.key,
    required this.titleText,
    required this.selectedItem,
    required this.dropdownList,
    required this.callback,
  });

  final String titleText;
  final T selectedItem;
  final List<T> dropdownList;
  final void Function(T) callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Text(
              titleText,
              style: const TextStyle(fontSize: 20.0),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 30.0),
          Flexible(
            flex: 2,
            child: DropdownButton<T>(
              focusColor: Colors.transparent,
              value: selectedItem,
              borderRadius: BorderRadius.circular(26.0),
              underline: Container(
                height: 2,
                color: Colors.grey.shade500,
              ),
              items: dropdownList.map<DropdownMenuItem<T>>((T value) {
                return DropdownMenuItem<T>(value: value, child: Text(value.toString()));
              }).toList(),
              onChanged: (value) => callback(value!),
              isDense: true,
              isExpanded: true,
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
