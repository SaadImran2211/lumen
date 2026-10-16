import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/global_extensions.dart';

class AppCustomButton extends StatelessWidget {
  const AppCustomButton({
    super.key,
    required this.buttonText,
    this.bgColor = const Color.fromARGB(255, 10, 9, 9),
    this.textColor = const Color(0xffffffff),
    required this.height,
    required this.width,
    required this.onPress,
    this.border,
    this.borderRadius,
    this.buttonTextIcon,
    this.buttonTextSize,
    this.isLoading = false,
    this.boxShadow,
  });

  final VoidCallback onPress;
  final double height;
  final double width;
  final String buttonText;
  final Color bgColor;
  final Color textColor;
  final Border? border;
  final double? borderRadius;
  final double? buttonTextSize;
  final Widget? buttonTextIcon;
  final bool isLoading;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        child: InkWell(
          onTap: isLoading ? null : onPress,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          child: Container(
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(borderRadius ?? 16),
              boxShadow: boxShadow,
            ),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: textColor,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (buttonTextIcon != null) ...[buttonTextIcon!, 16.pw],
                      Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: buttonTextSize ?? 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
