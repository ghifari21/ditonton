import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const baseImageUrl = 'https://image.tmdb.org/t/p/w500';

// colors
const richBlack = Color(0xFF000814);
const oxfordBlue = Color(0xFF001D3D);
const prussianBlue = Color(0xFF003566);
const mikadoYellow = Color(0xFFffc300);
const davyGrey = Color(0xFF4B5358);
const basicGrey = Color(0xFF303030);

// text style
final textHeading5 = GoogleFonts.poppins(
  fontSize: 23,
  fontWeight: FontWeight.w400,
);
final textHeading6 = GoogleFonts.poppins(
  fontSize: 19,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.15,
);
final textSubtitle = GoogleFonts.poppins(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.15,
);
final textBody = GoogleFonts.poppins(
  fontSize: 13,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.25,
);

// text theme
final textTheme = TextTheme(
  headlineMedium: textHeading5,
  headlineSmall: textHeading6,
  labelMedium: textSubtitle,
  bodyMedium: textBody,
);

final drawerTheme = DrawerThemeData(backgroundColor: Colors.grey.shade700);

const colorScheme = ColorScheme(
  primary: mikadoYellow,
  secondary: prussianBlue,
  secondaryContainer: prussianBlue,
  surface: richBlack,
  error: Colors.red,
  onPrimary: richBlack,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
