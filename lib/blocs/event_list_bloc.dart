import 'dart:async';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:awase_app/models/data_with_cursor.dart';
import 'package:awase_app/models/event.dart';
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

class SearchTextChanged extends EventListFetchEvent {
  final String searchText;

  SearchTextChanged({ @required this.searchText })
      : assert(searchText != null),
        super([searchText]);

  @override
  String toString() => 'SearchTextChanged { searchText: $searchText }';
}

@immutable
abstract class EventListState extends Equatable {
  EventListState([List props = const []]) : super(props);
}

class EventListLoading extends EventListState {
  @override
  String toString() => 'EventListLoading';

  DataWithCursor<Event> get eventList => DataWithCursor();
}

class EventListLoaded extends EventListState {
  final DataWithCursor<Event> eventList;

  EventListLoaded({ @required this.eventList })
      : assert(eventList != null),
        super([eventList]);

  @override
  String toString() => 'EventListLoaded { event: $eventList }';
}

class EventListBloc extends Bloc<EventListFetchEvent, EventListState>  {
  EventsRepository _eventsRepository;

  String _cursor;
  String _searchText;

  EventListBloc(EventsRepository eventRepository) {
    _eventsRepository = eventRepository;
  }

  @override
  EventListState get initialState => EventListLoading();

  @override
  Stream<EventListState> mapEventToState(EventListFetchEvent event) async* {
    if (event is CursorChanged) {
      _cursor = event.cursor;
      final eventList = await _eventsRepository.search(cursor: _cursor, searchText: _searchText);
      yield EventListLoaded(eventList: eventList);
    }
    if (event is SearchTextChanged) {
      _searchText = event.searchText;
      final eventList = await _eventsRepository.search(cursor: _cursor, searchText: _searchText);
      yield EventListLoaded(eventList: eventList);
    }
  }
}
