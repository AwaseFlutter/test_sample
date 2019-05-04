import 'dart:async';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:awase_app/entities/data_with_cursor.dart';
import 'package:awase_app/entities/event.dart';
import 'package:awase_app/repositories/events_repository.dart';

@immutable
abstract class EventListFetchEvent extends Equatable {
  EventListFetchEvent([List props = const[]]) : super(props);
}

class CursorChanged extends EventListFetchEvent {
  final String cursor;

  CursorChanged({ @required this.cursor }) : super([cursor]);

  @override
  String toString() => 'CursorChanged { cursor: $cursor }';
}

class EventListFetchBloc extends Bloc<EventListFetchEvent, DataWithCursor<Event>>  {
  EventsRepository _eventsRepository;

  EventListFetchBloc(EventsRepository eventRepository) {
    _eventsRepository = eventRepository;
  }

  @override
  DataWithCursor<Event> get initialState => DataWithCursor();

  @override
  Stream<DataWithCursor<Event>> mapEventToState(EventListFetchEvent event) async* {
    if (event is CursorChanged) {
      yield await _eventsRepository.fetch(cursor: event.cursor);
    }
  }
}
