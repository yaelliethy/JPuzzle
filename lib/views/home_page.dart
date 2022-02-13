import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jpuzzle/common/constants.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Widget _icon;
  double _value = 3;
  @override
  void initState() {
    _icon = SvgPicture.asset(
      emojis[3]!,
      key: const ValueKey<int>(3),
      height: 100,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user!.photoURL!),
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            'Hello ${user.displayName}',
          ),
          Slider(
            value: _value.toDouble(),
            max: 9,
            min: 3,
            divisions: 6,
            onChanged: (value) {
              setState(() {
                _icon = SvgPicture.asset(
                  emojis[value.roundToDouble()]!,
                  key: ValueKey<int>(value.round()),
                  height: 100,
                );
                _value = value.roundToDouble();
              });
            },
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _icon,
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}