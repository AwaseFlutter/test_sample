import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:awase_app/models/event.dart';
import 'package:awase_app/repositories/events_repository.dart';

@immutable
abstract class EventCreateEvent extends Equatable {
  EventCreateEvent([List props = const []]) : super(props);
}

class CreateEvent extends EventCreateEvent {
  final String ownerId;
  final String title;
  final String description;
  final File image;

  CreateEvent({
    @required this.ownerId,
    @required this.title,
    @required this.description,
    @required this.image,
  }):
    assert(ownerId != null),
    assert(title != null),
    assert(description != null),
    assert(image != null),
    super([ownerId, title, description, image]);

  @override
  String toString() => 'CreateEvent { ownerId: $ownerId, title: $title, description: $description, image: $image }';
}

@immutable
abstract class EventCreateState extends Equatable {
  EventCreateState([List props = const []]) : super(props);
}

class EventCreateInitial extends EventCreateState {
  @override
  String toString() => 'EventCreateInitial';
}

class EventCreated extends EventCreateState {
  final Event event;

  EventCreated({ @required this.event }):
    assert(event != null),
    super([event]);

  @override
  String toString() => 'EventCreated { event: $event }';
}

class EventCreateBloc extends Bloc<EventCreateEvent, EventCreateState> {
  final EventsRepository _eventsRepository;

  EventCreateBloc(eventsRepository):
    assert(eventsRepository != null),
    _eventsRepository = eventsRepository;

  @override
  EventCreateState get initialState => EventCreateInitial();

  @override
  Stream<EventCreateState> mapEventToState(EventCreateEvent event) async* {
    if (event is CreateEvent) {
      final eventData = await _eventsRepository.create(
        ownerId: event.ownerId,
        title: event.title,
        description: event.description,
        image: event.image,
      );
      yield EventCreated(event: eventData);
    }
  }
}
