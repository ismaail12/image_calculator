import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.color,
    this.onPressed,
    this.isFullWidth = true,
    this.icon,
  });

  final String text;
  final Color? color;
  final bool isFullWidth;
  final Function()? onPressed;
  final IconData? icon; 

  @override
  Widget build(BuildContext context) {
    final Brightness currentBrightness = Theme.of(context).brightness;

    final bool isDarkMode = currentBrightness == Brightness.dark;

    final bool isDisabled = onPressed == null;
    final ThemeData theme = Theme.of(context);
    final Color defaultColor = theme.colorScheme.primary;
    final Color disabledColor =
        isDarkMode ? Colors.grey[600]! : theme.disabledColor;
    final Color buttonColor =
        isDisabled ? disabledColor : (color ?? defaultColor);

    return MaterialButton(
      minWidth: isFullWidth ? MediaQuery.of(context).size.width : null,
      height: 40,
      elevation: 0,
      color: buttonColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      disabledColor: disabledColor,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: isDarkMode ? Colors.black : Colors.white,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              color: isDarkMode ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
