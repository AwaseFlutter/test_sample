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
        child: new Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new RaisedButton(
                          child: const Text('Google login'),
                          onPressed: () {
                            _signInBloc.dispatch(GoogleSignInEvent());
                          }
                      )
                  )
                ]
            )
        )
    );
  }
}
