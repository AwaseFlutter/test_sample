import 'package:flutter/material.dart';
import 'package:awase_app/screens/event_list.dart';

import 'package:awase_app/navigator.dart';
import 'package:awase_app/repositories/current_user_repository.dart';
import 'package:awase_app/widgets/sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final CurrentUserRepository currentUser;

  MyApp()
      : this.currentUser = CurrentUserRepository(),
        super();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        Nav.SIGN_IN: (BuildContext context) =>
            new SignInPage(currentUser: currentUser),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "App"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  final CurrentUserRepository currentUser = CurrentUserRepository();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final CurrentUserRepository _currentUser = CurrentUserRepository();
  int _selectedIndex = 0;

  List<Widget> _pages() => [
        EventList(currentUser: _currentUser),
        Text(
          '$_selectedIndex',
          key: Key("page"),
        ),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('ホーム'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, key: Key("search")),
                title: Text('検索')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), title: Text('アカウント')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('設定')),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey[800],
          onTap: _onItemTapped),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Nav.SIGN_IN);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
