import 'package:meta/meta.dart';

@immutable
class Participant {
  final String userId;
  final String name;

  Participant({ @required this.userId, @required this.name })
    : assert(userId != null),
      assert(name != null);

  static Participant fromJson(Map<String, dynamic> json) {
    return new Participant(
      userId: json['user_id'],
      name: json['name'],
    );
  }
}
