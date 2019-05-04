import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awase_app/models/event.dart';
import 'package:awase_app/repository/current_user_repository.dart';
import 'package:awase_app/repositories/firebase/events_repository.dart';
import 'package:awase_app/blocs/event_detail_bloc.dart';

typedef Future<void> OnTapBottomNavigationType(int page);

class EventsDetail extends StatefulWidget {
  final CurrentUserRepository _currentUser;
  final String _id;

  EventsDetail({
    Key key,
    @required CurrentUserRepository currentUser,
    @required String id,
  })
      : assert(currentUser != null),
        assert(id != null),
        _currentUser = currentUser,
        _id = id,
        super(key: key);

  @override
  EventsDetailState createState() => EventsDetailState(currentUser: _currentUser, id: _id);
}

class EventsDetailState extends State<EventsDetail> {
  static const String DEFAULT_IMAGE_URL = 'https://img.icons8.com/material-sharp/24/000000/spinner-frame-5.png';

  final CurrentUserRepository _currentUser;
  final String _id;
  final EventDetailBloc _detailBloc = EventDetailBloc(FirebaseEventsRepository());

  EventsDetailState({ @required CurrentUserRepository currentUser, @required String id })
      : assert(currentUser != null),
        assert(id != null),
        _currentUser = currentUser,
        _id = id,
        super();

  @override
  void initState() {
    super.initState();
    _detailBloc.dispatch(IdSet(id: _id));
  }

  @override
  void dispose() {
    _detailBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _detailBloc,
      builder: (context, state) {
        final event = state is EventDetailLoaded ? state.event : null;

        return Scaffold(
          appBar: AppBar(
            title: Text(event == null ? 'イベント詳細' : event.title),
          ),
          body: event == null ? Container() : Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Column(
                    children: <Widget>[
                      Image.network(event.imageUrl, fit: BoxFit.fitWidth),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(event.description),
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: _getOnTapBottomNavigation(context, event),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_back),
                title: Text('キャンセル'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                title: Text('参加')
              ),
            ],
          ),
        );
      }
    );
  }

  OnTapBottomNavigationType _getOnTapBottomNavigation(BuildContext context, Event event) {
    return (int page) async {
      switch (page) {
        case 0:
          Navigator.pop(context);
          break;
        case 1:
          _showJoinDialog(context, event);
          break;
        // no default
      }
    };
  }

  void _showJoinDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('参加の確認'),
        content: Text('${event.title}に参加しますか？'),
        actions: <Widget>[
          FlatButton(
            child: Text('キャンセル'),
            onPressed: () { Navigator.of(context).pop(); },
          ),
          FlatButton(
            child: Text('参加'),
            onPressed: () async {
              _detailBloc.dispatch(ParticipantJoined(participant: _currentUser.user()));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
