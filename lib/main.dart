import 'package:flutter/material.dart';
import 'package:pgmr_ui/common.dart';
import 'package:pgmr_ui/sign_in.dart';
import 'package:pgmr_ui/vault.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var hasToken = null;

  //TODO: Implement a token expiry checker endpoint and verify with it
  void checkIfTokenExists() async {
    var token = await getToken();
    var tokenExists;
    if (token != null) {
      tokenExists = true;
    } else {
      tokenExists = false;
    }
    debugPrint("tokenExists == > ${tokenExists}");
    setState(() {
      hasToken = tokenExists;
    });
  }

  @override
  void initState() {
    super.initState();
    //clearToken();
    checkIfTokenExists();
  }

  @override
  void dispose() {
    debugPrint('clearing token');
    clearToken();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    if (hasToken == null) {
      return const ProgressIndicator();
    } else if (hasToken == true) {
      return const Vault();
    } else {
      return const SignIn();
    }
    //return (hasToken == null) ? const SignIn() : const Vault();
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
