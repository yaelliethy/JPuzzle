import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kBackgroundColor = Color(0xFF810034);

const Color kPrimaryColor = Color(0xFFFF005C);

const Color kAccentColor = Color(0xFFFFF600);

const Color kOrange = Color(0xFFFF4C29);

TextStyle kHeaderStyle = GoogleFonts.poppins(
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  color: kAccentColor,
  shadows: [
    BoxShadow(
      spreadRadius: 10.0,
      offset: Offset(4.0, 4.0),
    ),
  ],
);

const emojis = <int, String>{
  3: 'assets/images/3.svg',
  4: 'assets/images/4.svg',
  5: 'assets/images/5.svg',
  6: 'assets/images/6.svg',
  7: 'assets/images/7.svg',
  8: 'assets/images/8.svg',
  9: 'assets/images/9.svg',
};