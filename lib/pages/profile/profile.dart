import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        child: Column(
          children: [
            Text('Select notification interval'),
          ],
        ),
      ),
    );
  }
}
