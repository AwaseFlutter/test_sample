import 'package:meta/meta.dart';

@immutable
class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  Event({ this.id, this.title, this.description, this.imageUrl });

  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }
}
