import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/utils/global_extensions.dart';

class CustomAppInputField extends StatelessWidget {
  const CustomAppInputField({
    super.key,
    this.placeholder,
    this.editingController,
    this.isSecured = false,
    this.suffix,
    this.prefix,
    this.keyboardType,
    this.onChanged,
    this.isTappable = false,
    this.onTap,
    this.isFilled = false,
    this.maxLines = 1,
    this.inputFormatters,
    this.errorText,
    this.focusNode,
    this.roundCorners = 999,
    this.contentPadding = const EdgeInsets.only(bottom: 3),
    this.maxLength,
    this.validator,
  });

  final String? placeholder;
  final TextEditingController? editingController;
  final bool isSecured;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool isTappable;
  final GestureTapCallback? onTap;
  final bool isFilled;
  final int? maxLines;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final double roundCorners;
  final EdgeInsets contentPadding;
  final int? maxLength;
  final FormFieldValidator? validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 44),
          //alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isFilled ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(roundCorners),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (prefix != null) prefix!,
              Expanded(
                child: Row(
                  children: [
                    if (prefix == null) 14.pw,
                    Expanded(
                      child: TextFormField(
                        maxLength: maxLength,
                        focusNode: focusNode,
                        controller: editingController,
                        cursorColor: const Color(0xFF0F1728),
                        readOnly: isTappable,
                        onTap: onTap,
                        keyboardType: keyboardType,
                        obscureText: isSecured,
                        inputFormatters: inputFormatters,
                        maxLines: maxLines,
                        onChanged: onChanged,
                        validator: validator,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            color: Color(0xFF98A1B2),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: placeholder,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          filled: false,
                          contentPadding: contentPadding,
                        ),
                      ),
                    ),
                    if (suffix == null && errorText == null) 14.pw,
                  ],
                ),
              ),
              if (errorText != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [SizedBox(height: 4), Icon(Icons.error)],
                ),
              if (suffix != null) suffix!,
            ],
          ),
        ),
        if (errorText != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              6.ph,
              Text(
                errorText!,
                style: const TextStyle(
                  color: Color(0xFFF04437),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    this.placeholder,
    this.editingController,
    this.isSecured = false,
    this.suffixIcon,
    this.prefix,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.isTappable = false,
    this.onTap,
    this.isFilled = false,
    this.maxLines = 1,
    this.inputFormatters,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 10,
    ),
    this.textInputAction,
    this.onEditingComplete,
  });

  final String? placeholder;
  final TextEditingController? editingController;
  final bool isSecured;
  final Widget? suffixIcon;
  final Widget? prefix;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool isTappable;
  final GestureTapCallback? onTap;
  final bool isFilled;
  final EdgeInsetsGeometry contentPadding;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: editingController,
      cursorColor: const Color(0xFF0F1728),
      readOnly: isTappable,
      onTap: onTap,
      keyboardType: keyboardType,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      obscureText: isSecured,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          color: Color(0xFF98A1B2),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        hintText: placeholder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(width: 1, color: Color(0xFFCFD4DC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(width: 1, color: Color(0xFFCFD4DC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(width: 1, color: Color(0xFFCFD4DC)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(width: 1, color: Color(0xff496579)),
        ),
        errorStyle: const TextStyle(fontSize: 12.0, color: Color(0xfffc2222)),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xFFCFD4DC), //0xFFCFD4DC
          ),
        ),
        filled: isFilled,
        fillColor: Colors.white,
        suffixIcon: suffixIcon != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [suffixIcon!],
              )
            : null,
        prefixIcon: prefix != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [prefix!],
              )
            : null,
        contentPadding: contentPadding,
      ),
    );
  }
}

class CustomAppTitleInputField extends StatelessWidget {
  const CustomAppTitleInputField({
    super.key,
    required this.title,
    this.placeholder,
    this.editingController,
    this.isSecured = false,
    this.suffix,
    this.prefix,
    this.keyboardType,
    this.onChanged,
    this.isTappable = false,
    this.onTap,
    this.isFilled = false,
    this.maxLines = 1,
    this.inputFormatters,
    this.errorText,
    this.focusNode,
    this.roundCornders = 8,
    this.contentPadding = const EdgeInsets.only(bottom: 0),
    this.direction,
    this.maxLength,
    this.validator,
    this.titleFontSize,
  });

  final String title;
  final String? placeholder;
  final TextEditingController? editingController;
  final bool isSecured;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool isTappable;
  final GestureTapCallback? onTap;
  final bool isFilled;
  final int? maxLines;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final double roundCornders;
  final EdgeInsets contentPadding;
  final TextDirection? direction;
  final int? maxLength;
  final FormFieldValidator? validator;
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(52, 64, 84, 1),
            fontSize: titleFontSize ?? 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        6.ph,
        Directionality(
          textDirection: direction ?? TextDirection.ltr,
          child: CustomAppInputField(
            validator: validator,
            maxLength: maxLength,
            placeholder: placeholder,
            editingController: editingController,
            isSecured: isSecured,
            suffix: suffix,
            prefix: prefix,
            keyboardType: keyboardType,
            onChanged: onChanged,
            isTappable: isTappable,
            onTap: onTap,
            isFilled: isFilled,
            errorText: errorText,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            focusNode: focusNode,
            roundCorners: roundCornders,
            contentPadding: contentPadding,
          ),
        ),
      ],
    );
  }
}
