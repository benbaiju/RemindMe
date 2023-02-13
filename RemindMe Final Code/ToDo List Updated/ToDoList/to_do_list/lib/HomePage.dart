//import 'dart:async';
//import 'dart:html';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:to_do_list/TaskPage.dart';
import 'package:to_do_list/alert.dart';
import 'alert.dart';
import 'dart:math';

flutterinitialize() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBONjxM5aRkyGK96HnpKgGbyOLl_Mo1R7I",
          appId: "1:309194721859:android:bfdf53fba0ebbffb5522f6",
          messagingSenderId: '309194721859',
          projectId: "todolist-2945a"));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  flutterinitialize();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Places you have to visit'),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List todos = List.empty();
  List completedTasks = List.empty();
  String title = "";
  String description = "";
  String title1 = "";
  List placename = [];
  List placegeolat = [];
  List placegeolong = [];
  late LocationPermission permission;
  double lat = 15.5057;
  double long = 80.0499;
  //late LatLng _current = const LatLng(15.5057, 80.0499);
  @override
  initState() {
    super.initState();
    todos = ["Hello", "Hey There"];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncabc();
    });
    getLocation();
  }

  asyncabc() async {
    placename = await nearby(lat, long);
    placegeolat = await nearbygeo1(lat, long);
    placegeolong = await nearbygeo2(lat, long);
  }

  createToDo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(title);

    Map<String, String> todoList = {
      "todoTitle": title,
      "todoDesc": description
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);
    title1 = item;
    documentReference
        .delete()
        .whenComplete(() => print("deleted successfully"));
  }

  completedtodos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodoscompleted").doc(title);

    Map<String, String> todoList = {
      "todoTitle": title,
      "todoDesc": description
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  // final placename = [];
  // Timer timer = Timer.periodic(Duration(seconds: 15), (Timer t) async {
  //    await nearby();
  // });
  @override
  Widget build(BuildContext context) {
    //final GlobalKey<ScaffoldState> _scaffoldKey =  new GlobalKey<ScaffoldState>();
    // void showInSnackBar(String value) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text(value)));
    // }

    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData ||
              // snapshot.data != null ||
              placename.isNotEmpty) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot<Object?>? documentSnapshot =
                      snapshot.data!.docs[index];
                  print(placename); //use it to find the places to search
                  if (placename.isNotEmpty) {
                    int flag = 0;
                    int ind = 0;
                    String name = "";
                    for (int i = 0; i < placename.length; i++) {
                      if (placename[i] == documentSnapshot["todoTitle"]) {
                        flag = 1;
                        name = placename[i];
                        ind = i;
                        break;
                      } else {
                        flag = 0;
                      }
                    }
                    if (flag == 1) {
                      double distance = geodistance(
                          lat,
                          long,
                          double.parse(placegeolat[ind]),
                          double.parse(placegeolong[ind]));

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Add Your Code here.
                        // ScaffoldMessenger.of(context)
                        //     .showSnackBar(SnackBar(content: Text("" + name)));
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(name),
                            content: Text('Place is near by ' +
                                double.parse(distance.toString())
                                    .toStringAsFixed(2) +
                                "km"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      });
                      print("yes"); //use push notification here
                      print(name);
                    }
                  }

                  //print(placename);
                  // _myStream.listen(
                  //   (event) {
                  //     print(event);
                  //   },
                  // );
                  // print(documentSnapshot!["todoTitle"]);
                  return Dismissible(
                      key: Key(index.toString()),
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                          title: Text((documentSnapshot != null)
                              ? (documentSnapshot["todoTitle"])
                              : ""),
                          subtitle: Text((documentSnapshot != null)
                              ? (documentSnapshot["todoDesc"])
                              : ""),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Color.fromARGB(255, 189, 181, 180),
                            onPressed: () {
                              setState(() {
                                // todos.removeAt(index);
                                completedtodos();
                                deleteTodo((documentSnapshot != null)
                                    ? (documentSnapshot["todoTitle"])
                                    : "");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "You visited" + " " + title1)));
                              });
                            },
                          ),
                        ),
                      ));
                });
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Add Place to Visit"),
                  content: Container(
                    width: 400,
                    height: 100,
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (String value) {
                            title = value;
                          },
                        ),
                        TextField(
                          onChanged: (String value) {
                            description = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          setState(() {
                            //todos.add(title);
                            createToDo();
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text("Add"))
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  nearbygeo1(double lat, double long) async {
    List<String> placesgeolat = [];
    int radius = 500;
    String query = "store";
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=' +
            query +
            '&location=' +
            lat.toString() +
            ',' +
            long.toString() +
            '&radius=' +
            radius.toString() +
            '&key=AIzaSyBRdhu_Z1q6fGolTEWt89J1geOx0kIrOyk'));

    final jsonStudent = await jsonDecode(response.body);

    //print(jsonStudent["results"][1]["name"]);
    for (int i = 0; i < jsonStudent["results"].length; i++) {
      placesgeolat.add(
          jsonStudent["results"][i]["geometry"]['location']['lat'].toString());
    }
    //print(placesnames);
    return placesgeolat;
  }

  nearbygeo2(double lat, double long) async {
    List<String> placesgeolong = [];
    int radius = 500;
    String query = "store";
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=' +
            query +
            '&location=' +
            lat.toString() +
            ',' +
            long.toString() +
            '&radius=' +
            radius.toString() +
            '&key=AIzaSyBRdhu_Z1q6fGolTEWt89J1geOx0kIrOyk'));

    final jsonStudent = await jsonDecode(response.body);

    //print(jsonStudent["results"][1]["name"]);
    for (int i = 0; i < jsonStudent["results"].length; i++) {
      placesgeolong.add(
          jsonStudent["results"][i]["geometry"]['location']['lng'].toString());
    }
    //print(placesnames);
    return placesgeolong;
  }

  geodistance(double lat1, double lng1, double lat2, double lng2) {
    double theta = lng1 - lng2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    dist = dist * 1.60934;
    return (dist);
  }

  deg2rad(double deg) {
    return (deg * (22 / 7) / 180.0);
  }

  rad2deg(double rad) {
    return (rad * 180.0 / (22 / 7));
  }

  getLocation() async {
    print("called");
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // final GoogleMapController controller = await _controller.future;
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    //controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 11));

    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }
}

nearby(double lat, double long) async {
  List<String> placesnames = [];
  int radius = 500;
  String query = "store";
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=' +
          query +
          '&location=' +
          lat.toString() +
          ',' +
          long.toString() +
          '&radius=' +
          radius.toString() +
          '&key=AIzaSyBRdhu_Z1q6fGolTEWt89J1geOx0kIrOyk'));

  final jsonStudent = await jsonDecode(response.body);

  //print(jsonStudent["results"][1]["name"]);
  for (int i = 0; i < jsonStudent["results"].length; i++) {
    placesnames.add(jsonStudent["results"][i]["name"]);
    //placesnames.add(jsonStudent["results"][i]["geometry"]['location'].toString());
  }
  //print(placesnames);
  return placesnames;
}
