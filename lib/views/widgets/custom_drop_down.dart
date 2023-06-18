import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown(
      {Key? key,
      required this.hintText,
      required this.textList,
      this.onChanged,
      this.text})
      : super(key: key);

  final String hintText;
  final List textList;
  final ValueChanged? onChanged;
  final String? text;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
            ),
          ),
          isEmpty: widget.text == null || widget.text == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: widget.text,
              isDense: true,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              onChanged: widget.onChanged,
              items: widget.textList
                  .map<DropdownMenuItem<String>>(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                  .toList(),

              borderRadius: BorderRadius.circular(12),
              //  alignment: Alignment.center,
            ),
          ),
        );
      },
    );
  }
}
