import 'package:flutter/material.dart';
import 'package:to_do_list/Complaint.dart';
import 'HomePage.dart';
import 'TaskPage.dart';
import 'PlacesToVisit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Home_screen.dart';
import 'CompletedTasks.dart';
import 'SendNot.dart';
//import 'Complaint.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBONjxM5aRkyGK96HnpKgGbyOLl_Mo1R7I",
          appId: "1:309194721859:android:bfdf53fba0ebbffb5522f6",
          messagingSenderId: '309194721859',
          projectId: "todolist-2945a"));
  runApp(const Newmain());
}

class Newmain extends StatelessWidget {
  const Newmain({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  get screens => [
        HomePage(),
        TaskPage(),
        PlacesToVisit(),
        CompletedTasks(),
        SendNot(),
        HomeScreen(),

        //complaint(),
      ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RemindMe'),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task_rounded),
            label: 'Add Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location_alt_rounded),
            label: 'Places to Visit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_sharp),
            label: 'Completed Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_rounded),
            label: 'Notification Scheduler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.task_sharp),
            label: 'Complaint',
          ),*/
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
