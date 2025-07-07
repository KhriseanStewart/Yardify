import 'dart:ui';

Color hexToColor(String hexCode) {
  final buffer = StringBuffer();
  if (hexCode.startsWith('#')) hexCode = hexCode.substring(1);
  if (hexCode.length == 6) buffer.write('ff');
  buffer.write(hexCode.toUpperCase());
  return Color(int.parse(buffer.toString(), radix: 16));
}