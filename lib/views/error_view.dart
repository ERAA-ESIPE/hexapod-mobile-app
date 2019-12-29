import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Image.asset(
        "assets/socker-error.png",
        width: (MediaQuery.of(context).size.height),
        alignment: Alignment.center,
      ),
    );
  }
}
