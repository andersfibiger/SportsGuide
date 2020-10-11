import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final GestureTapCallback onPressed;
  final Widget child;
  final IconData iconData;

  const Button({
    @required this.onPressed,
    @required this.child,
    @required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        fillColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).primaryColorDark,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 36.0),
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
