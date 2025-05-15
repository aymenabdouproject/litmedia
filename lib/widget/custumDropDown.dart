import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String? hintText;
  final Function(T?)? onChanged;
  final FormFieldValidator<T>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;
  final TextStyle? textStyle;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    this.hintText,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.018,
            ),
        hintText: hintText,
        hintStyle: textStyle ??
            TextStyle(
              fontSize: screenWidth * 0.04,
              color: const Color.fromARGB(255, 6, 3, 3),
            ),
        filled: true,
        fillColor: const Color(0xFFF7ECE1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.07),
          borderSide: const BorderSide(
            color: AppColors.vibrantBlue,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.07),
          borderSide: const BorderSide(
            color: AppColors.vibrantBlue,
            width: 3.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.07),
          borderSide: const BorderSide(
            color: AppColors.vibrantBlue,
            width: 3.0,
          ),
        ),
      ),
      style: textStyle ??
          TextStyle(
            fontSize: screenWidth * 0.04,
            color: const Color(0xFFF7ECE1),
          ),
      items: items,
      onChanged: onChanged,
      validator: validator,
      dropdownColor: AppColors.gris,
    );
  }
}
