import 'package:meta/meta.dart';

@immutable
class User {
  final String id;
  final String name;

  User({ @required this.id, @required this.name }):
    assert(id != null),
    assert(name != null);

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}
