import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  // Bersihkan prefiks # dan 0x jika ada
  String cleanHex = hex.toUpperCase().replaceAll('#', '').replaceAll('0X', '');
  if (cleanHex.length == 6) {
    cleanHex = 'FF$cleanHex';
  }
  return Color(int.parse(cleanHex, radix: 16));
}

extension ColorHex on Color {}

extension HexColor on String {
  Color toColorFill() {
    return hexToColor(this);
  }
}

String initials(String word) {
  return word
      .trim()
      .split(RegExp(r'\s+'))
      .map((e) => e[0].toUpperCase())
      .take(2)
      .join();
}

extension CreateInitials on String {
  String toInitials() {
    return initials(this);
  }
}
