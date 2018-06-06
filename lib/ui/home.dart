import 'package:flutter/material.dart';
import 'notodo_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('NoTodo'),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: new NotoDoScreen(),
    );
  }
}
