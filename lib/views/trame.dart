import "package:hex/hex.dart";

class Trame {
  final int nopeOctet = 0x0;

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

  @override
  String toString() {
    String hexLeftStickX = HEX.encode([leftStickX]);
    String hexLeftStickY = HEX.encode([leftStickY]);
    String hexRightStickX = HEX.encode([rightStickX]);
    String hexRightStickY = HEX.encode([rightStickY]);
    String hexButtons = HEX.encode([buttons]);

    return 'FF' +
        hexLeftStickX +
        hexLeftStickY +
        hexRightStickX +
        hexRightStickY +
        hexButtons +
        'FF';
  }
}
