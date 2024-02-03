import 'dart:math';
import 'dart:ui';

Color getRandomColor() {
  final random = Random();
  return Color.fromARGB(
      255, random.nextInt(190), random.nextInt(190), random.nextInt(190));
}
