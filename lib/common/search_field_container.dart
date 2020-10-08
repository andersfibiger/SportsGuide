import 'package:flutter/material.dart';

class SearchFieldContainer extends StatelessWidget {
  final Widget child;

  SearchFieldContainer({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.4),
      ),
      child: child,
    );
  }
}
