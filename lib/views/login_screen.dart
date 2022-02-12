import 'package:jpuzzle/services/authentication.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100.0,
                ),
                child: Lottie.network(
                  'https://assets5.lottiefiles.com/packages/lf20_rhnmhzwj.json',
                ),
              ),
              const Text(
                'Hey, Welcome to JPuzzle!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
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
                  color: Color(0xFF4FBDBA),
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
  }
}
