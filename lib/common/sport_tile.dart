import 'package:flutter/material.dart';

class SportTile extends StatelessWidget {
  const SportTile({Key key, @required this.sport, @required this.onDismissed})
      : super(key: key);

  final String sport;
  final Function(DismissDirection) onDismissed;

  double _getHeigt(BuildContext context) => MediaQuery.of(context).size.height * 0.08;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: _getHeigt(context),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete_outline),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Theme.of(context).errorColor
              ),
            ),
            Dismissible(
              key: Key(sport),
              onDismissed: onDismissed,
              direction: DismissDirection.endToStart,
              dismissThresholds: const <DismissDirection, double>{
                DismissDirection.endToStart: 0.3
              },
              child: Container(
                height: _getHeigt(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: ListTile(
                  title: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Text(sport, style: TextStyle(color: Colors.white))),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5)
      ],
    );
  }
}
