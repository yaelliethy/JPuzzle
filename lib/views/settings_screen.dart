import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.network(
                'https://assets5.lottiefiles.com/packages/lf20_qiuhvo9f.json',
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Lottie.network(
                'https://assets4.lottiefiles.com/packages/lf20_q4h79bkv.json',
              ),
            );
          }
          return Column(
            children: [
              Text(
                'Hello ${user.displayName}',
              ),
            ],
          );
        }),
      ),
    );
  }
}
