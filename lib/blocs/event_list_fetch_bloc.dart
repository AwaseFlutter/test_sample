import 'dart:async';
import 'package:awase_app/entities/data_with_cursor.dart';
import 'package:awase_app/entities/event.dart';
import 'package:awase_app/repositories/events_repository.dart';

class EventListFetchBloc {
  final _cursor = StreamController<String>();
  Sink<String> get cursor => _cursor.sink;

  final _eventList = StreamController<DataWithCursor<Event>>();
  Stream<DataWithCursor<Event>> get eventList => _eventList.stream;
  DataWithCursor<Event> get initialEventList => DataWithCursor();

  EventListFetchBloc() {
    _cursor.stream.listen(handleCursorChanged);
  }

  Future<void> handleCursorChanged(String cursor) async {
    final list = await EventsRepository().index(cursor: cursor);
    _eventList.sink.add(list);
  }

  Future<void> dispose() async {
    await _cursor.close();
    await _eventList.close();
  }
}
