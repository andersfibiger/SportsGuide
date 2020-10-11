import 'package:flutter/material.dart';

class SearchFieldContainer extends StatelessWidget {
  final Widget child;

  SearchFieldContainer({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: Colors.grey.withOpacity(0.4),
      ),
      child: child,
    );
  }
}
