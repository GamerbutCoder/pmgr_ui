import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:pgmr_ui/common.dart';
import 'package:pgmr_ui/vault.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault'),
      ),
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String userName = "";
  String password = "";

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  void setUserNameToState() {
    // debugPrint("${userNameController.text} -- ${userNameController.value.text}");
    setState(() {
      userName = userNameController.value.text;
    });
  }

  void setPasswordToState() {
    // debugPrint("${passwordController.text} ## ${passwordController.value.text}");

    setState(() {
      password = passwordController.value.text;
    });
  }

  @override
  void initState() {
    super.initState();
    userNameController.addListener(setUserNameToState);
    passwordController.addListener(setPasswordToState);
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> _login() async {
    var url = Uri.parse("http://localhost:3000/auth/login");
    var body = {
      'userName': userName,
      'password': password,
    };
    const headers = {'accept': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    //TODO: create UX/I for below cases
    // 401 -> user exists but password missmatch
    // 500 -> user doesn't exist
    // 201- > post success handled
    debugPrint("--> resp ${response.statusCode} ${response.body}");
    try {
      if (response.statusCode == 201) {
        var token = jsonDecode(response.body.toString())['access_token'];
        var refreshToken =
            jsonDecode(response.body.toString())['refresh_token'];
        debugPrint(token + "::::" + refreshToken);
        await storeToken(token);
        await storeRefreshToken(refreshToken);
        return true;
      } else if (response.statusCode == 401) {
        return false;
      }
    } catch (err) {
      debugPrint("$err");
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        TextField(
          key: const Key('UserName'),
          decoration: const InputDecoration(labelText: 'Username'),
          maxLength: 12,
          controller: userNameController,
        ),
        TextField(
          key: const Key('Password'),
          maxLength: 12,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          obscuringCharacter: 'x',
          controller: passwordController,
        ),
        ElevatedButton(
          onPressed: () {
            debugPrint("${userName} ${password}");
            _login().then((value) => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Vault()),
                  )
                });
          },
          child: const Text('Login'),
        )
      ]),
    );
  }
}
