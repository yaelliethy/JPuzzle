import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jpuzzle/common/constants.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _dimensions = 3;
  late Widget _icon;
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
    final user = FirebaseAuth.instance.currentUser!;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SvgPicture.asset(
          'assets/images/backgrounds/Kander.svg',
          fit: BoxFit.cover,
        ),
        toolbarHeight: size.height * 0.1,
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton<String>(
              elevation: 0,
              alignment: Alignment.center,
              focusColor: Colors.transparent,
              underline: Container(),
              items: <String>[
                'Logout',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
              icon: CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoURL!,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: [
                  const TextSpan(text: 'Hello '),
                  TextSpan(
                    text: user.displayName,
                    style: const TextStyle(
                      color: kTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Select Your Dimensions',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100.0,
                vertical: 30.0,
              ),
              child: Column(
                children: [
                  Text(
                    '${_dimensions.toInt().toString()} × ${_dimensions.toInt().toString()}',
                    style: const TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Slider(
                    value: _dimensions.toDouble(),
                    min: 3.0,
                    max: 9.0,
                    divisions: 6,
                    onChanged: (double value) {
                      setState(() {
                        _icon = SvgPicture.asset(
                          emojis[value.roundToDouble()]!,
                          key: ValueKey<int>(value.round()),
                          height: 100,
                        );
                        _dimensions = value.roundToDouble();
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
            ),
          ],
        ),
      ),
    );
  }
}
