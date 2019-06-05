import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awase_app/blocs/event_create_bloc.dart';
import 'package:awase_app/repositories/current_user_repository.dart';
import 'package:awase_app/repositories/firebase/events_repository.dart';
import 'package:awase_app/screens/event_detail.dart';

class EventNew extends StatefulWidget {
  final CurrentUserRepository _currentUser;

  EventNew({ Key key, @required CurrentUserRepository currentUser })
    : assert(currentUser != null),
      _currentUser = currentUser,
      super(key: key);

  @override
  EventNewState createState() => EventNewState(currentUser: _currentUser);
}

class EventNewState extends State<EventNew> {
  final CurrentUserRepository _currentUser;
  final _createBloc = EventCreateBloc(FirebaseEventsRepository());
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File _image;


  EventNewState({ @required CurrentUserRepository currentUser })
      : assert(currentUser != null),
        _currentUser = currentUser,
        super();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _createBloc,
      listener: (context, state) async {
        if (state is EventCreated) {
          Navigator.of(context).pop();
          await Navigator.push(context, MaterialPageRoute<void>(
            settings: RouteSettings(name: 'events/show'),
            builder: (_context) => EventDetail(currentUser: _currentUser, id: state.event.id),
          ));
        }
        if (state is EventCreateFailed) {
          // TODO: Show alert.
        }
      },
      child: BlocBuilder(
        bloc: _createBloc,
        builder: (context, state) {
          return  Scaffold(
            appBar: AppBar(
              title: Text('イベントを作成')
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'イベントのタイトル',
                        ),
                        controller: _titleController,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'イベントの詳細',
                        ),
                        controller: _descriptionController,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom:8.0, top: 8.0),
                      child: Column(
                        children: <Widget>[
                          _image == null ? Text('画像を選択してください') : Image.file(_image),
                          Container(
                            child: RaisedButton(
                              child: Icon(Icons.add_a_photo),
                              onPressed: () async {
                                final image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                setState(() { _image = image; });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: RaisedButton(
                        color: Colors.blue,
                        child: Text('作成'),
                        onPressed: () {
                          _createBloc.dispatch(CreateEvent(
                            ownerId: _currentUser.user().id,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            image: _image,
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
