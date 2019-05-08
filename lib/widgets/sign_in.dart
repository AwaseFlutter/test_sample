import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:awase_app/repositories/current_user_repository.dart';
import 'package:awase_app/blocs/sign_in_block.dart';

class SignInPage extends StatefulWidget {
  final CurrentUserRepository currentUser;

  SignInPage({Key key, @required this.currentUser})
      : assert(currentUser != null),
        super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  SignInBloc _signInBloc;

  CurrentUserRepository get _currentUser => widget.currentUser;

  @override
  void initState() {
    super.initState();
    _signInBloc = SignInBloc(currentUser: _currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ログイン")),
      body: SignInForm(signInBloc: _signInBloc),
    );
  }
}

class SignInForm extends StatefulWidget {
  final SignInBloc signInBloc;

  SignInForm({Key key, @required this.signInBloc}) : assert(signInBloc != null), super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignInBloc get _signInBloc => widget.signInBloc;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInEvent, SignInState>(
        bloc: _signInBloc,
        listener: (context, state) {
          if (state is SignInFinished) {
            Navigator.of(context).pop();
          }
        },
        child: Column(children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: "mailaddress", hintText: "sample@example.com"),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: _emailController,
          ),
          TextFormField(
            decoration:
            InputDecoration(labelText: "password", hintText: "8文字以上の英数字"),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _passwordController,
          ),
          MaterialButton(
            shape: StadiumBorder(),
            color: Colors.red,
            textColor: Colors.white,
            onPressed: () {
              _signInBloc.dispatch(EmailSignInEvent(
                  email: _emailController.text,
                  password: _passwordController.text)
              );
            },
            child: Text("ログイン"),
          ),
          InkWell(
            child: Text("アカウントを作成する"),
            onTap: () {
            },
          )
        ])
    );
  }
}
