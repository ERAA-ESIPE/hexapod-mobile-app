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
    return 'FF|$leftStickX|$leftStickY|$rightStickX|$rightStickY|$buttons|$nopeOctet|FF';
  }
}
