import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';

import 'package:awase_app/repositories/current_user_repository.dart';

abstract class SignInState { }

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

abstract class SignInEvent { }

class EmailSignInEvent extends SignInEvent {
  String email;
  String password;

  EmailSignInEvent({@required this.email, @required this.password});
}

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  CurrentUserRepository _currentUser;

  SignInBloc({Key key, @required CurrentUserRepository currentUser})
      : assert(currentUser != null), _currentUser = currentUser;

  @override
  SignInState get initialState {
    if (_currentUser.isSingIn()) {
      return SignInFinished();
    }else{
      return SignInInitialized();
    }
  }

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is EmailSignInEvent) {
      yield emailSigInIn(event);
    }
  }

  SignInState emailSigInIn(EmailSignInEvent event) {
    return SignInFinished();
  }
}
