import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class complaint extends StatefulWidget {
  static const String routeName = '/complaint-screen';
  const complaint({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<complaint> {
  final TextEditingController comp = TextEditingController();
  final TextEditingController rou = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Review'),
        ),
        body: ListView(
          padding: EdgeInsets.all(15),

          // alignment: Alignment.bottomCenter,
          children: <Widget>[
            TextField(
              controller: comp,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ENTER YOUR QUERIES',
                hintText: 'TYPE YOUR QUERIES HERE..',
              ),
            ),
            TextField(
              controller: rou,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ENTER THE PART YOU FACED AN ISSUE WITH',
                hintText: 'ENTER THE REASON',
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue, //bg
                  onPrimary: Colors.white // foreground
                  ),

              child: Text('SUBMIT'),
              onPressed: () //pop and display
                  {
                //also this has to be added to db
                final complaint = Complaint_(
                  complaint: comp.text,
                  route: rou.text,
                );
                createcomplaint(complaint);

                Navigator.pop(context, "complaint registered");
              }, //ack page
            )
          ],
        ));
  }

  Future createcomplaint(Complaint_ complaint) async {
    //reference to doc
    final docUser = FirebaseFirestore.instance.collection('Complaints').doc();
    complaint.id = docUser.id;

    final json = complaint.toJson();
    await docUser.set(json);
  }
}

class Complaint_ {
  String id;
  final String complaint;
  final String route;
  Complaint_({
    this.id = '',
    required this.complaint,
    required this.route,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'complaint': complaint,
        'route_': route,
      };
}
