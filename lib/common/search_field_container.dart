import 'package:flutter/material.dart';

class SearchFieldContainer extends StatelessWidget {
  final Widget child;

  SearchFieldContainer({@required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.grey.withOpacity(0.4)
      ),
      child: child,
    );
  }
}