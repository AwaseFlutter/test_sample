import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awase_app/blocs/event_list_fetch_bloc.dart';
import 'package:awase_app/entities/data_with_cursor.dart';
import 'package:awase_app/entities/event.dart';
import 'package:awase_app/repositories/firebase/events_repository.dart';
import 'package:awase_app/views/events/show.dart';

class EventsIndex extends StatefulWidget {
  @override
  EventsIndexState createState() => EventsIndexState();
}

class EventsIndexState extends State<EventsIndex> {
  final EventListFetchBloc _fetchBloc = EventListFetchBloc(FirebaseEventsRepository());

  @override
  void initState() {
    super.initState();
    _fetchBloc.dispatch(CursorChanged(cursor: null));
  }

  @override
  void dispose() {
    _fetchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('イベント一覧'),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            _fetchBloc.dispatch(CursorChanged(cursor: null));
          },
          child: BlocBuilder(
            bloc: _fetchBloc,
            builder: (context, list) {
              return ListView.builder(
                itemCount: list.data.length,
                itemBuilder: (context, index) {
                  final event = list.data[index];
                  return Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute<void>(
                          settings: RouteSettings(name: 'events/show'),
                          builder: (_context) => EventsShow(id: event.id)
                        ));
                      },
                      child: Card(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 6.0),
                                      child: Image.network(event.imageUrl, width: 100.0),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(event.title,
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
    );
  }
}
