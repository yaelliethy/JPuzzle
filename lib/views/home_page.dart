import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jpuzzle/common/constants.dart';
import 'package:jpuzzle/services/authentication.dart';
import 'package:jpuzzle/views/game.dart';
import 'package:jpuzzle/views/game_history.dart';
import 'package:jpuzzle/views/game_history_item.dart';
import 'package:jpuzzle/widgets/widgets.dart';
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
          fit: BoxFit.fitWidth,
        ),
        toolbarHeight: size.height * 0.1,
        title: Text(
          'Home',
          style: kHeaderStyle,
        ),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton2<IconData>(
              buttonElevation: 0,
              underline: Container(),
              alignment: Alignment.center,
              focusColor: Colors.transparent,
              items: <IconData>[
                FontAwesomeIcons.signOutAlt,
              ].map((IconData value) {
                return DropdownMenuItem<IconData>(
                  value: value,
                  alignment: Alignment.center,
                  child: Icon(
                    value,
                    color: Colors.black,
                  ),
                );
              }).toList(),
              onChanged: (_) async {
                print('Nice');
                final provider = context.read<Authentication>();
                await provider.signOut();
              },
              hint: CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoURL!,
                ),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.transparent,
                size: 15,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    color: kAccentColor,
                    shadows: [
                      BoxShadow(
                        spreadRadius: 5.0,
                        offset: Offset(4.0, 4.0),
                      ),
                    ],
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
                    color: kAccentColor,
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
                  thumbColor: kAccentColor,
                  activeColor: kPrimaryColor,
                  inactiveColor: kPrimaryColor.withOpacity(0.3),
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 100.0,
              vertical: 10.0,
            ),
            child: Column(
              children: [
                RoundedButton(
                  dimensions: _dimensions,
                  text: 'Start',
                  icon: FontAwesomeIcons.play,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(
                          dimension: _dimensions.toInt(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10,),
                RoundedButton(
                  dimensions: _dimensions,
                  text: 'History',
                  icon: FontAwesomeIcons.play,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameHistory(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}


