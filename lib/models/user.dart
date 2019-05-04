import 'package:meta/meta.dart';

@immutable
class User {
  final String id;
  final String name;

  User({ this.id, this.name });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}
