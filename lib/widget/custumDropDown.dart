import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String hintText;
  final Function(T?)? onChanged;
  final FormFieldValidator<T>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF7ECE1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: AppColors.vibrantBlue,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: AppColors.vibrantBlue,
            width: 3.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: AppColors.vibrantBlue,
            width: 3.0,
          ),
        ),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
      dropdownColor: AppColors.grayPurple,
    );
  }
}
