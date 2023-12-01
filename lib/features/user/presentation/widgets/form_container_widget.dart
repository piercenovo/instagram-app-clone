import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFiledSubmitted;
  final TextInputType? inputType;
  final TextInputAction? inputAction;

  const FormContainerWidget({
    super.key,
    this.controller,
    this.fieldKey,
    this.isPasswordField,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFiledSubmitted,
    this.inputType,
    this.inputAction,
  });

  @override
  State<FormContainerWidget> createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tSecondaryColor.withOpacity(0.35),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: TextFormField(
          key: widget.fieldKey,
          style: const TextStyle(color: tPrimaryColor),
          controller: widget.controller,
          keyboardType: widget.inputType,
          textInputAction: widget.inputAction,
          obscureText: widget.isPasswordField == true ? _obscureText : false,
          onSaved: widget.onSaved,
          validator: widget.validator,
          onFieldSubmitted: widget.onFiledSubmitted,
          decoration: InputDecoration(
            border: InputBorder.none,
            // filled: true,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: tSecondaryColor),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: widget.isPasswordField == true
                  ? Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                      color:
                          _obscureText == false ? tBlueColor : tSecondaryColor)
                  : const Text(''),
            ),
          ),
        ),
      ),
    );
  }
}
