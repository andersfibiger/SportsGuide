import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final GestureTapCallback onPressed;
  final Widget child;
  final IconData iconData;

  Button({
    @required this.onPressed,
    @required this.child,
    @required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        fillColor: Colors.deepOrange,
        splashColor: Colors.orangeAccent,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: Colors.amber),
              const SizedBox(width: 8.0),
              child,
            ],
          ),
        ),
        shape: const StadiumBorder(),
        textStyle: TextStyle(color: Colors.white));
  }
}
