import 'package:awase_app/entities/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:awase_app/blocs/event_fetch_bloc.dart';

class EventsShow extends StatefulWidget {
  String _id;

  EventsShow({ Key key, @required String id }) : super(key: key) {
    _id = id;
  }

  @override
  EventsShowState createState() => EventsShowState(id: _id);
}

class EventsShowState extends State<EventsShow> {
  static const String DEFAULT_IMAGE_URL = 'https://img.icons8.com/material-sharp/24/000000/spinner-frame-5.png';

  String _id;
  EventFetchBloc _fetchBloc;

  EventsShowState({ @required String id }) {
    _id = id;
  }

  @override
  void initState() {
    super.initState();
    _fetchBloc = EventFetchBloc();
    _fetchBloc.id.add(_id);
  }

  @override
  void dispose() {
    _fetchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
      stream: _fetchBloc.event,
      builder: (context, snap) {
        final event = snap.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(null == event ? 'イベント詳細' : event.title),
          ),
          body: null == event ? Container() : Container(
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
        );
      }
    );
  }
}
