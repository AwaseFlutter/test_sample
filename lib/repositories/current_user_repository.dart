import 'package:awase_app/models/user.dart';

class CurrentUserRepository {
  bool isSingIn() {
    return false;
  }

  User user() {
    return User();
  }
}
