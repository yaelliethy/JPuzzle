import 'package:flutter/material.dart';
import 'package:jpuzzle/widgets/future_list.dart';
class Leaderboard extends StatelessWidget {
  const Leaderboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          margin: const EdgeInsets.symmetric(
            horizontal: 100.0,
            vertical: 75.0,
          ),
          child: Expanded(
            child: FutureList(
              future: null,
              widget: Container(),
            ),
          ),
        ),
      ),
    );
  }
}
