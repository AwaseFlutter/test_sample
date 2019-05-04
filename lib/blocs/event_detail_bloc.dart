import 'dart:async';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:awase_app/models/user.dart';
import 'package:awase_app/models/event.dart';
import 'package:awase_app/repositories/events_repository.dart';

@immutable
class EventDetailEvent extends Equatable {
  EventDetailEvent([List props = const []]) : super(props);
}

class IdSet extends EventDetailEvent {
  final String id;

  IdSet({ @required this.id })
      : assert(id != null),
        super([id]);

  @override
  String toString() => 'IdSet { id: $id }';
}

class ParticipantJoined extends EventDetailEvent {
  final User participant;

  ParticipantJoined({ @required this.participant })
      : assert(participant != null),
        super([participant]);

  @override
  String toString() => 'ParticfipantJoined { participant: $participant }';
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
      await _eventsRepository.join(_event.id, participant: event.participant); // TODO: Set current user
      _event = await _eventsRepository.fetchDetail(_event.id);
      yield _event;
    }
  }

}
