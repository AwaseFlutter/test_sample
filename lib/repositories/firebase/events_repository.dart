import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:awase_app/models/data_with_cursor.dart';
import 'package:awase_app/models/event.dart';
import 'package:awase_app/models/participant.dart';
import 'package:awase_app/models/user.dart';
import 'package:awase_app/repositories/events_repository.dart';

class FirebaseEventsRepository implements EventsRepository {
  @override
  Future<DataWithCursor<Event>> search({ String cursor, String searchText }) async {
    final snapshot = await _firestore.collection('events').getDocuments();
    final dataWithCursor = {
      'cursor': null,
      'data': snapshot.documents.map((ds) => ds.data..addAll({ 'id': ds.documentID })).toList(),
    };

    return DataWithCursor.fromJson<Event>(dataWithCursor, (attrs) => Event.fromJson(attrs));
  }

  Future<Event> create({
    @required String ownerId,
    @required String title,
    @required String description,
    @required File image,
  }) async {
    final eventData = {
      'owner': _firestore.collection('users').document(ownerId),
      'title': title,
      'description': description,
      'image_url': '',
    };

    final reference = await _firestore.collection('events').add(eventData);

    try {
      final storageRef = _firebaseStorage.ref().child('events/images/${reference.documentID}');
      final imageUploadTask = storageRef.putFile(image);
      final imageUploadSnapshot = await imageUploadTask.onComplete;
      final imageUrl = await imageUploadSnapshot.ref.getDownloadURL();

      eventData.addAll({ 'image_url': imageUrl });
      await reference.setData(eventData);
    } catch (error) {
      await reference.delete();
    }

    final snapshot = await reference.get();
    return _buildEventFromSnapshot(snapshot);
  }

  @override
  Future<Event> fetchDetail(String id) async {
    final snapshot = await _firestore.collection('events').document(id).get();
    return _buildEventFromSnapshot(snapshot);
  }

  @override
  Future<void> join(String id, { User participant }) async {
    await _firestore.collection('events').document(id).collection('participants').document(participant.id).setData({
      'user': _firestore.collection('users').document(participant.id),
      'name': participant.name,
    });
  }

  @override
  Future<List<Participant>> participants(String eventId) async {
    final query = await _firestore.collection('events').document(eventId).collection('participants').getDocuments();

    final participants = query.documents.map((snapshot) {
      final data = snapshot.data..addAll({
        'user_id': (snapshot.data['user'] as DocumentReference).documentID
      });

      return Participant.fromJson(data);
    });

    return participants.toList();
  }

  Firestore get _firestore => Firestore.instance;
  FirebaseStorage get _firebaseStorage => FirebaseStorage.instance;

  Event _buildEventFromSnapshot(DocumentSnapshot snapshot) {
    assert(snapshot != null);

    final eventData = snapshot.data..addAll({ 'id': snapshot.documentID });
    return Event.fromJson(eventData);
  }
}
