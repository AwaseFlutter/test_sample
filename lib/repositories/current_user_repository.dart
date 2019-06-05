import 'package:awase_app/models/user.dart';

import 'package:firebase_auth/firebase_auth.dart';

class CurrentUserRepository {
  FirebaseUser firebaseUser;

  bool isSingIn() {
    return firebaseUser != null;
  }

  User user() {
    return User(id: this.firebaseUser.uid, name: this.firebaseUser.displayName);
  }
}
