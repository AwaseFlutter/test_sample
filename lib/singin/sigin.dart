import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {

  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ログイン")),
      body: SignInForm(),
    );
  }
}

class SignInForm extends StatefulWidget {
  SignInForm({Key key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Column(children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: "メ〜ルアドレス", hintText: "sample@lifelogapps.com"),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: _emailController,
          ),
          TextFormField(
            decoration:
            InputDecoration(labelText: "パスワ〜ド", hintText: "8文字以上の英数字"),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _passwordController,
          ),
          MaterialButton(
            shape: StadiumBorder(),
            color: Colors.red,
            textColor: Colors.white,
            onPressed: () {
              _onSingInButtonPressed();
            },
            child: Text("ログイン"),
          ),
          InkWell(
            child: Text("アカウントを作成する"),
            onTap: () {

            },
          )
        ]));
  }

  _onSingInButtonPressed() {
  }
}
