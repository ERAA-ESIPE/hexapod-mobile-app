import 'dart:convert';
import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:utf/utf.dart';

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
    /*var startConvt = HEX.encode([
      startAndEndOctet,
      leftStickX,
      leftStickY,
      rightStickX,
      rightStickY,
      buttons,
      nopeOctet,
      startAndEndOctet
    ]);
*/

/*
    var message = Uint8List(4);
    var bytedata = ByteData.view(message.buffer);

    bytedata.setUint8(0, startAndEndOctet);
    bytedata.setUint8(1, leftStickX);
    bytedata.setUint8(2, leftStickY);
    bytedata.setUint8(3, rightStickX);
    bytedata.setUint8(4, rightStickY);
    bytedata.setUint8(5, buttons);
    bytedata.setUint8(6, nopeOctet);
    bytedata.setUint8(7, startAndEndOctet);

*/
    var converted =
        '$startAndEndOctet$leftStickX$leftStickY$rightStickX$rightStickY$buttons$nopeOctet$startAndEndOctet';

    print('conveted:$startAndEndOctet');

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

    var b = new String.fromCharCodes(listInts, 0, listInts.length);

    var c = b.codeUnitAt(0);

    var first = String.fromCharCode(startAndEndOctet);
    var second = String.fromCharCode(leftStickX);
    var trois = String.fromCharCode(leftStickY);
    var quatre = String.fromCharCode(rightStickX);
    var cinq = String.fromCharCode(leftStickY);
    var six = String.fromCharCode(buttons);

    var seven = String.fromCharCode(nopeOctet);
    var eight = String.fromCharCode(startAndEndOctet);

    var f = first + second + trois + quatre + cinq + six + seven + eight;

    var buffer = new Uint8List(8).buffer;
    var bdata = new ByteData.view(buffer);

    bdata.setUint8(0, startAndEndOctet);
    bdata.setUint8(1, leftStickX);
    bdata.setUint8(2, leftStickY);
    bdata.setUint8(3, rightStickX);
    bdata.setUint8(4, leftStickY);
    bdata.setUint8(5, buttons);
    bdata.setUint8(6, nopeOctet);
    bdata.setUint8(7, startAndEndOctet);

    print('buff:' + bdata.toString());

    return bdata.toString();

    //print('aaaa: $startConvt');

    /*
    var utf8Converted = _toUTF8(converted);
  
    print('message$utf8Converted');
 return utf8Converted.toString();
 
*/
  }
}
