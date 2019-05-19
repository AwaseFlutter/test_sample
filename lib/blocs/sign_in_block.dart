import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'package:awase_app/repositories/current_user_repository.dart';

abstract class SignInState {}

class SignInInitialized extends SignInState {
  @override
  String toString() {
    return 'SignInInitialized';
  }
}

class SignInFinished extends SignInState {
  @override
  String toString() {
    return 'SignInFinished';
  }
}

abstract class SignInEvent {}

class GoogleSignInEvent extends SignInEvent {}

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  CurrentUserRepository _currentUser;

  SignInBloc({Key key, @required CurrentUserRepository currentUser})
      : assert(currentUser != null),
        _currentUser = currentUser;

  @override
  SignInState get initialState {
    if (_currentUser.isSingIn()) {
      return SignInFinished();
    } else {
      return SignInInitialized();
    }
  }

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is GoogleSignInEvent) {
      yield *googleSigInIn(event);
    }
  }

  Stream<SignInState> googleSigInIn(GoogleSignInEvent event) async* {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    _currentUser.firebaseUser = user;

    yield SignInFinished();
  }
}
