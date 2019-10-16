import 'dart:convert' show utf8;

class Trame {
  final int nopeOctet = 0x0;
  final int startAndEndOctet = 255;

  int leftStickX;
  int leftStickY;
  int rightStickX;
  int rightStickY;
  int buttons;

  Trame(int leftStickX, int leftStickY, int rightStickX, int rightStickY,
      int buttons) {
    this.leftStickX = leftStickX;
    this.leftStickY = leftStickY;
    this.rightStickX = rightStickX;
    this.rightStickY = rightStickY;
    this.buttons = buttons;
  }

  _toUTF8(String args) {
    return utf8.encode(args);
  }

  @override
  String toString() {
    var converted = startAndEndOctet.toRadixString(16) +
        leftStickX.toRadixString(16) +
        leftStickY.toRadixString(16) +
        rightStickX.toRadixString(16) +
        rightStickY.toRadixString(16) +
        buttons.toRadixString(16) +
        nopeOctet.toRadixString(16) +
        startAndEndOctet.toRadixString(16);

    var utf8Converted = _toUTF8(converted);

    return utf8Converted.toString();
  }
}
