class Trame {
  final int nopeOctet = 0x0;
  final int startAndEndOctet = 0xFF;

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

  List<int> getInts() {
    return [
      startAndEndOctet,
      leftStickX,
      leftStickY,
      rightStickX,
      rightStickY,
      buttons,
      nopeOctet,
      startAndEndOctet,
    ];
  }

  @override
  String toString() {
    List<int> listInts = [
      startAndEndOctet,
      leftStickX,
      leftStickY,
      rightStickX,
      rightStickY,
      buttons,
      nopeOctet,
      startAndEndOctet,
    ];

    var charChodes = new String.fromCharCodes(listInts).trim();

    return charChodes;
  }
}
