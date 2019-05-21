import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awase_app/blocs/event_list_bloc.dart';
import 'package:awase_app/models/data_with_cursor.dart';
import 'package:awase_app/models/event.dart';
import 'package:awase_app/repositories/current_user_repository.dart';
import 'package:awase_app/repositories/firebase/events_repository.dart';
import 'package:awase_app/screens/event_detail.dart';
import 'package:awase_app/screens/event_new.dart';

class EventList extends StatefulWidget {
  final CurrentUserRepository _currentUser;

  EventList({ Key key, @required CurrentUserRepository currentUser })
      : assert(currentUser != null),
        _currentUser = currentUser,
        super(key: key);

  @override
  EventListState createState() => EventListState(currentUser: _currentUser);
}

class EventListState extends State<EventList> {
  final CurrentUserRepository _currentUser;
  final EventListBloc _listBloc = EventListBloc(FirebaseEventsRepository());

  EventListState({ @required CurrentUserRepository currentUser })
      : assert(currentUser != null),
        _currentUser = currentUser,
        super();

  @override
  void initState() {
    super.initState();
    _listBloc.dispatch(CursorChanged(cursor: null));
  }

  @override
  void dispose() {
    _listBloc.dispose();
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
          _listBloc.dispatch(CursorChanged(cursor: null));
        },
        child: BlocBuilder(
          bloc: _listBloc,
          builder: (context, state) {
            final list = state is EventListLoaded ? state.eventList : DataWithCursor<Event>();

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
                        builder: (_context) => EventDetail(currentUser: _currentUser, id: event.id)
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute<void>(
            settings: RouteSettings(name: 'events/show'),
            builder: (_context) => EventNew(currentUser: _currentUser)
          ));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.plus_one),
      ),
    );
  }
}
