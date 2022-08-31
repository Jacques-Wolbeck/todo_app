import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme customTextTheme() {
  return TextTheme(
    headline1: GoogleFonts.roboto(
      fontSize: 88,
      fontWeight: FontWeight.w300,
      //letterSpacing: -1.5,
    ),
    headline2: GoogleFonts.roboto(
      fontSize: 55,
      fontWeight: FontWeight.w300,
      //letterSpacing: -0.5,
    ),
    headline3: GoogleFonts.roboto(
      fontSize: 44,
      fontWeight: FontWeight.w400,
    ),
    headline4: GoogleFonts.roboto(
      fontSize: 31,
      fontWeight: FontWeight.w400,
      //letterSpacing: 0.25,
    ),
    headline5: GoogleFonts.roboto(
      fontSize: 22,
      fontWeight: FontWeight.w400,
    ),
    headline6: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      //letterSpacing: 0.15,
    ),
    subtitle1: GoogleFonts.roboto(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      //letterSpacing: 0.15,
    ),
    subtitle2: GoogleFonts.roboto(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      //letterSpacing: 0.1,
    ),
    bodyText1: GoogleFonts.roboto(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      //letterSpacing: 0.5,
    ),
    bodyText2: GoogleFonts.roboto(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      //letterSpacing: 0.25,
    ),
    button: GoogleFonts.roboto(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      //letterSpacing: 1.25,
    ),
    caption: GoogleFonts.roboto(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      //letterSpacing: 0.4,
    ),
    overline: GoogleFonts.roboto(
      fontSize: 9,
      fontWeight: FontWeight.w400,
      //letterSpacing: 1.5,
    ),
  );
}
