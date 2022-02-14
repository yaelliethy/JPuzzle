import 'package:firebase_auth/firebase_auth.dart';
import 'package:jpuzzle/common/constants.dart';
import 'package:jpuzzle/services/authentication.dart';
import 'package:jpuzzle/views/home_page.dart';
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
              return const HomePage();
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100.0,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor,
                        ),
                        onPressed: () async {
                          final provider = Provider.of<Authentication>(
                            context,
                            listen: false,
                          );
                          await provider.googleLogin();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            leading: Image.asset('assets/images/google.png'),
                            title: const Text(
                              'Login With Google',
                              style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.bold,
                              ),
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
        },
      ),
    );
  }
}
