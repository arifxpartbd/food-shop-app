import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/my_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    required this.textInputType,
    required this.prefixIcon,
    required this.controller,
    required this.validator,
    this.textFieldEnable,
    this.maxLine,
    this.focusNode,
    this.onChange
  });
  final String hintText;
  final TextInputType textInputType;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool? textFieldEnable;
  final int? maxLine;
  final FocusNode? focusNode;
  final String? Function(String?)? onChange;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      maxLines: maxLine,
      enabled: textFieldEnable,
      controller: controller,
      validator: validator,
      onChanged: onChange,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
          color: MyColors.brandColor,
        ),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: textInputType,
    );
  }
}
