import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jpuzzle/common/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jpuzzle/services/authentication.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        toolbarHeight: size.height * 0.2,
        leading: Container(
          margin: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              user.photoURL!,
            ),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Home',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () async {
                final provider = context.read<Authentication>();
                await provider.signOut();
              },
              icon: const FaIcon(FontAwesomeIcons.signOutAlt),
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
