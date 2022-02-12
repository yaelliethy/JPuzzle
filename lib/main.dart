import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jpuzzle/services/authentication.dart';
import 'package:jpuzzle/views/login_screen.dart';
import 'package:jpuzzle/views/settings_screen.dart';
import 'common/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Authentication(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme,
        home: const SettingsScreen(),
      ),
    );
  }
}