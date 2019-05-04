import 'dart:async';
import 'package:awase_app/entities/event.dart';
import 'package:awase_app/repositories/events_repository.dart';

class EventFetchBloc {
  final _id = StreamController<String>();
  Sink<String> get id => _id.sink;

  final _event = StreamController<Event>();
  Stream<Event> get event => _event.stream;

  EventFetchBloc() {
    _id.stream.listen(_handleIdChanged);
  }

  Future<void> dispose() async {
    await _id.close();
    await _event.close();
  }

  Future<void> _handleIdChanged(String id) async {
    final event = await EventsRepository().show(id);
    _event.sink.add(event);
  }
}
