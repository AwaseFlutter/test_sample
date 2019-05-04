import 'dart:async';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:awase_app/entities/user.dart';
import 'package:awase_app/entities/event.dart';
import 'package:awase_app/repositories/events_repository.dart';

@immutable
class EventDetailEvent extends Equatable {
  EventDetailEvent([List props = const []]) : super(props);
}

class IdSet extends EventDetailEvent {
  final String id;

  IdSet({ this.id }) : super([id]);

  @override
  String toString() => 'IdSet { id: $id }';
}

class ParticipantJoined extends EventDetailEvent {
  @override
  String toString() => 'ParticfipantJoined';
}

class EventDetailBloc extends Bloc<EventDetailEvent, Event> {
  EventsRepository _eventsRepository;

  Event _event;

  EventDetailBloc(EventsRepository eventsRepository) {
    _eventsRepository = eventsRepository;
  }

  @override
  Event get initialState => Event();

  @override
  Stream<Event> mapEventToState(EventDetailEvent event) async* {
    if (event is IdSet) {
      _event = await _eventsRepository.fetchDetail(event.id);
      yield _event;
    }
    if (event is ParticipantJoined) {
      await _eventsRepository.join(_event.id, participant: User()); // TODO: Set current user
      _event = await _eventsRepository.fetchDetail(_event.id);
      yield _event;
    }
  }

}
