import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
