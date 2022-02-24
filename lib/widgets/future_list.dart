import 'package:flutter/material.dart';

class FutureList extends StatelessWidget {
  const FutureList({
    Key? key,
    this.future,
    required this.widget,
  }) : super(key: key);

  final Future? future;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      initialData: [
        Text('Nice'),
        Text('Nice'),
        Text('Nice'),
        Text('Nice'),
      ],
      builder: (context, snapshot) {
        return widget;
      },
    );
  }
}
