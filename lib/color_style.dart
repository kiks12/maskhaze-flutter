import 'package:flutter/material.dart';

class ColorStyles {
  // Color constants
  static const Color primary = Color(0xFFDC2626); // Main red
  static const Color primaryDark = Color(0xFFB91C1C);
  static const Color accent = Color(0xFFF87171); // Lighter red for highlights
  static const Color accentDark = Color(0xFF7F1D1D);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color backgroundMain = Color(0xFF18181B); // Main dark background
  static const Color cardBackground = Color(0xFF232326); // Card background
  static const Color cardAlt = Color(0xFF1C1C1F);
  static const Color textMain = Color(0xFFF3F4F6); // Light text
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFA1A1AA); // Muted gray
  static const Color borderColor = Color(0xFF27272A);
  static const Color errorColor = Color(0xFFDC2626);

  // Color with opacity
  static const Color overlay = Color(0xB3000000); // rgba(0,0,0,0.7)
  static const Color overlayDark = Color(0xE6000000); // rgba(0,0,0,0.9)
  static const Color shadowColor = Color(0xB3000000); // rgba(0,0,0,0.7)

  // Text Styles
  static const TextStyle primaryTextStyle = TextStyle(color: primary);
  static const TextStyle primaryDarkTextStyle = TextStyle(color: primaryDark);
  static const TextStyle accentTextStyle = TextStyle(color: accent);
  static const TextStyle accentDarkTextStyle = TextStyle(color: accentDark);
  static const TextStyle whiteTextStyle = TextStyle(color: white);
  static const TextStyle blackTextStyle = TextStyle(color: black);
  static const TextStyle textStyle = TextStyle(color: textMain);
  static const TextStyle textLightStyle = TextStyle(color: textLight);
  static const TextStyle textMutedStyle = TextStyle(color: textMuted);
  static const TextStyle errorTextStyle = TextStyle(color: errorColor);

  // Container Decorations
  static const BoxDecoration backgroundDecoration = BoxDecoration(
    color: backgroundMain,
  );

  static const BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
  );

  static const BoxDecoration cardAltDecoration = BoxDecoration(
    color: cardAlt,
  );

  static const BoxDecoration overlayDecoration = BoxDecoration(
    color: overlay,
  );

  static const BoxDecoration overlayDarkDecoration = BoxDecoration(
    color: overlayDark,
  );

  // Border Decorations
  static const BoxDecoration borderDecoration = BoxDecoration(
    border: Border.fromBorderSide(BorderSide(color: borderColor)),
  );

  // Shadow Decorations
  static const List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: shadowColor,
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  // Input Decorations
  static const InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: cardBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: primary),
    ),
    contentPadding: EdgeInsets.all(12),
  );

  // Input Text Style
  static const TextStyle inputTextStyle = TextStyle(
    color: textMain,
    fontSize: 16,
  );

  // Textarea Decoration (for multiline TextFormField)
  static const InputDecoration textareaDecoration = InputDecoration(
    filled: true,
    fillColor: cardBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: primary),
    ),
    contentPadding: EdgeInsets.all(12),
    alignLabelWithHint: true,
  );

  // Helper methods for creating styled containers
  static Container styledContainer({
    required Widget child,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    Border? border,
  }) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? cardBackground,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: boxShadow,
        border: border,
      ),
      child: child,
    );
  }

  // Helper method for creating styled text
  static Text styledText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      style: style ?? textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // Helper method for creating styled TextFormField
  static TextFormField styledTextFormField({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int maxLines = 1,
    bool isTextarea = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: isTextarea ? 4 : maxLines,
      style: inputTextStyle,
      decoration: (isTextarea ? textareaDecoration : inputDecoration).copyWith(
        hintText: hintText,
        labelText: labelText,
        hintStyle: textMutedStyle,
        labelStyle: textMutedStyle,
      ),
    );
  }

  // Theme Data for the entire app
  static ThemeData get appTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(0xFFDC2626, {
        50: Color(0xFFFEF2F2),
        100: Color(0xFFFEE2E2),
        200: Color(0xFFFECACA),
        300: Color(0xFFFCA5A5),
        400: Color(0xFFF87171),
        500: Color(0xFFEF4444),
        600: Color(0xFFDC2626),
        700: Color(0xFFB91C1C),
        800: Color(0xFF991B1B),
        900: Color(0xFF7F1D1D),
      }),
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundMain,
      cardColor: cardBackground,
      dividerColor: borderColor,
      textTheme: const TextTheme(
        displayLarge: textLightStyle,
        displayMedium: textLightStyle,
        displaySmall: textLightStyle,
        headlineLarge: textLightStyle,
        headlineMedium: textLightStyle,
        headlineSmall: textLightStyle,
        titleLarge: textLightStyle,
        titleMedium: textLightStyle,
        titleSmall: textLightStyle,
        bodyLarge: textStyle,
        bodyMedium: textStyle,
        bodySmall: textMutedStyle,
        labelLarge: textStyle,
        labelMedium: textStyle,
        labelSmall: textMutedStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: primary),
        ),
        hintStyle: textMutedStyle,
        labelStyle: textMutedStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}