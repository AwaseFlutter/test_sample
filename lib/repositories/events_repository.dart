import 'dart:async';
import 'package:awase_app/models/user.dart';
import 'package:awase_app/models/event.dart';
import 'package:awase_app/models/data_with_cursor.dart';

abstract class EventsRepository {
  Future<DataWithCursor<Event>> search({ String cursor, String searchText });

  Future<Event> fetchDetail(String id);

  Future<void> join(String id, { User participant });
}
