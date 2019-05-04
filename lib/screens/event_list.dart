import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awase_app/blocs/event_list_fetch_bloc.dart';
import 'package:awase_app/repository/current_user_repository.dart';
import 'package:awase_app/repositories/firebase/events_repository.dart';
import 'package:awase_app/screens/event_detail.dart';

class EventsList extends StatefulWidget {
  final CurrentUserRepository _currentUser;

  EventsList({ Key key, @required CurrentUserRepository currentUser })
      : assert(currentUser != null),
        _currentUser = currentUser,
        super(key: key);

  @override
  EventsListState createState() => EventsListState(currentUser: _currentUser);
}

class EventsListState extends State<EventsList> {
  final CurrentUserRepository _currentUser;
  final EventListFetchBloc _fetchBloc = EventListFetchBloc(FirebaseEventsRepository());

  EventsListState({ @required CurrentUserRepository currentUser })
      : assert(currentUser != null),
        _currentUser = currentUser,
        super();

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
                          builder: (_context) => EventsDetail(currentUser: _currentUser, id: event.id)
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
