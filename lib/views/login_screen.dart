import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jpuzzle/common/constants.dart';
import 'package:jpuzzle/services/authentication.dart';
import 'package:jpuzzle/views/home_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasData) {
              return const HomeScreen();
            } else if (snapshot.hasError) {
              return Container();
            }
            return Center(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100.0,
                          vertical: 10.0,
                        ),
                        child: Lottie.network(
                          'https://assets5.lottiefiles.com/packages/lf20_rhnmhzwj.json',
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 100.0,
                          vertical: 10.0,
                        ),
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: kPrimaryColor,
                        ),
                        child: InkWell(
                          onTap: () async {
                            final provider = Provider.of<Authentication>(
                              context,
                              listen: false,
                            );
                            await provider.googleLogin();
                          },
                          child: ListTile(
                            leading: Image.asset('assets/images/google.png'),
                            title: const Text(
                              'Login with Google',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
