import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final int dimension;

  const GameScreen({Key? key, required this.dimension}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}
class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: widget.dimension,
          children: List.generate(widget.dimension * widget.dimension, (index) {
            return Container(
              color: Colors.blue,
            );
          }),
        ),
      ),
    );
  }
}