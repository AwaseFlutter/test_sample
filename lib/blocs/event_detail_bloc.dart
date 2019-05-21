import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:awase_app/models/event.dart';
import 'package:awase_app/models/participant.dart';
import 'package:awase_app/models/user.dart';
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

class ClearEventJoinFailed extends EventDetailEvent {
  @override
  String toString() => 'ClearEventJoinFailed';
}

@immutable
abstract class EventDetailState extends Equatable {
  EventDetailState([List props = const []]) : super(props);
}

class EventDetailLoading extends EventDetailState {
  @override
  String toString() => 'EventDetailLoading';
}

class EventDetailLoaded extends EventDetailState {
  final Event event;
  final List<Participant> participants;

  EventDetailLoaded({ @required this.event, @required this.participants })
    : assert(event != null),
      assert(participants != null),
      super([event, participants]);

  @override
  String toString() => 'EventDetailLoaded { event: $event, participants: $participants }';
}

class EventDetailLoadFailed extends EventDetailState {
  final error;

  EventDetailLoadFailed({ @required this.error })
    : assert(error != null),
      super([error]);

  @override
  String toString() => 'EventDetailLoadFailed { error: $error }';
}

class EventJoinFailed extends EventDetailState {
  final Event event;
  final List<Participant> participants;
  final error;

  EventJoinFailed({ @required this.event, @required this.participants, @required this.error })
    : assert(event != null),
      assert(participants != null),
      assert(error != null),
      super([event, participants, error]);

  @override
  String toString() => 'EventJoinFailed { event: $event, participants: $participants, error: $error }';
}

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  EventsRepository _eventsRepository;

  Event _event;
  List<Participant> _participants;

  EventDetailBloc(EventsRepository eventsRepository)
    : assert(eventsRepository != null),
      _eventsRepository = eventsRepository;

  @override
  EventDetailState get initialState => EventDetailLoading();

  @override
  Stream<EventDetailState> mapEventToState(EventDetailEvent event) async* {
    if (event is IdSet) {
      yield await _fetchEvent(id: event.id);
    }
    if (event is ParticipantJoined) {
      try {
        await _eventsRepository.join(_event.id, participant: event.participant);
      } catch (error) {
        yield EventJoinFailed(event: _event, participants: _participants, error: error);
      }
      yield await _fetchEvent();
    }
    if (event is ClearEventJoinFailed) {
      yield EventDetailLoaded(event: _event);
    }
  }

  Future<EventDetailState> _fetchEvent({ String id }) async {
    try {
      _event = await _eventsRepository.fetchDetail(id ?? _event.id);
      _participants = await _eventsRepository.participants(_event.id);
      return EventDetailLoaded(event: _event, participants: _participants);
    } catch (error) {
      return EventDetailLoadFailed(error: error);
    }
  }
}
