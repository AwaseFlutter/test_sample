import 'dart:async';
import 'package:awase_app/models/user.dart';
import 'package:awase_app/models/event.dart';
import 'package:awase_app/models/data_with_cursor.dart';

abstract class EventsRepository {
  Future<DataWithCursor<Event>> fetch({ String cursor });

  Future<Event> fetchDetail(String id);

  Future<void> join(String id, { User participant });
}
