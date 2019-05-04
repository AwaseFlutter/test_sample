import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awase_app/entities/user.dart';
import 'package:awase_app/repositories/events_repository.dart';
import 'package:awase_app/entities/data_with_cursor.dart';
import 'package:awase_app/entities/event.dart';

class FirebaseEventsRepository implements EventsRepository {
  Future<DataWithCursor<Event>> fetch({ String cursor }) async {
    final snapshot = await firestore.collection('events').getDocuments();
    final dataWithCursor = {
      'cursor': null,
      'data': snapshot.documents.map((ds) => ds.data..addAll({ 'id': ds.documentID })).toList(),
    };

    return DataWithCursor.fromJson<Event>(dataWithCursor, (attrs) => Event.fromJson(attrs));
  }

  Future<Event> fetchDetail(String id) async {
    final snapshot = await firestore.collection('events').document(id).get();
    final event = snapshot.data..addAll({ 'id': snapshot.documentID });
    return Event.fromJson(event);
  }

  Future<void> join(String id, { User participant }) async {
    firestore.collection('events').document(id).collection('participants').add({
      'user': participant.id,
      'name': participant.name,
    });
  }

  Firestore get firestore => Firestore.instance;
}
