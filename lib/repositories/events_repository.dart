import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:awase_app/models/data_with_cursor.dart';
import 'package:awase_app/models/event.dart';
import 'package:awase_app/models/participant.dart';
import 'package:awase_app/models/user.dart';

abstract class EventsRepository {
  Future<DataWithCursor<Event>> search({ String cursor, String searchText });

  Future<Event> fetchDetail(String id);

  Future<Event> create({
    @required String ownerId,
    @required String title,
    @required String description,
    @required File image,
  });

  Future<void> join(String id, { User participant });

  Future<List<Participant>> participants(String eventId);
}
