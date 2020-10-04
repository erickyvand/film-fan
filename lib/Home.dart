import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            FlatButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/movies');
              },
              icon: Icon(Icons.add),
              label: Text(
                'View Now Playing Movies',
                style: TextStyle(fontSize: 25, color: Colors.blue[900]),
              ),
            ),
            SizedBox(height: 30),
            new Image.network('https://source.unsplash.com/random'),
          ],
        ),
      ),
    );
  }
}
