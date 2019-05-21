import 'package:meta/meta.dart';

typedef T FromJsonCallback<T>(Map<String, dynamic> json);

@immutable
class DataWithCursor<T> {
  final String cursor;
  final List<T> data;

  DataWithCursor({ @required this.cursor, @required List<T> data }):
    this.data = data ?? [];

  static DataWithCursor<T> fromJson<T>(Map<String, dynamic> json, FromJsonCallback<T> callback) {
    final data = (json['data'] as List<Map<String, dynamic>>).map(callback);

    return DataWithCursor(cursor: json['cursor'], data: data.toList());
  }
}
