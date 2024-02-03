import 'dart:math';
import 'dart:ui';

Color getRandomColor() {
  final _random = Random();
  return Color.fromARGB(
      255, _random.nextInt(190), _random.nextInt(190), _random.nextInt(190));
}
