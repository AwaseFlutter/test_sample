import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awase_app/entities/event.dart';
import 'package:awase_app/repositories/firebase/events_repository.dart';
import 'package:awase_app/blocs/event_detail_bloc.dart';

typedef Future<void> OnTapBottomNavigationType(int page);

class EventsShow extends StatefulWidget {
  final String _id;

  EventsShow({ Key key, @required String id }): _id = id, super(key: key);

  @override
  EventsShowState createState() => EventsShowState(id: _id);
}

class EventsShowState extends State<EventsShow> {
  static const String DEFAULT_IMAGE_URL = 'https://img.icons8.com/material-sharp/24/000000/spinner-frame-5.png';

  final String _id;
  final EventDetailBloc _detailBloc = EventDetailBloc(FirebaseEventsRepository());

  EventsShowState({ @required String id }): _id = id;

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
      builder: (context, event) {
        return Scaffold(
          appBar: AppBar(
            title: Text(null == event.id ? 'イベント詳細' : event.title),
          ),
          body: null == event.id ? Container() : Container(
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
              _detailBloc.dispatch(ParticipantJoined());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
