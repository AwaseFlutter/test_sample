import 'package:meta/meta.dart';

@immutable
class User {
  final String id;
  String name;

  User({@required this.id, @required this.name})
      : assert(id != null),
        assert(name != null);

  rename(String newName) {
    assert(newName != null);
    this.name = newName;
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}
