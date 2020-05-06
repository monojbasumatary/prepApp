import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireapp1/main.dart';

class ListChapPage extends StatefulWidget {
  @override
  ListChapPageState createState() => ListChapPageState();
}

class ListChapPageState extends State<ListChapPage> {
  Future data;

  Future getData() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn =
        await firestore.collection('Science09 Chap 2').getDocuments();

    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot docSnap) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  docSnap: docSnap,
                )));
  }

  @override
  void initState() {
    super.initState();
    data = getData();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Is Matter Around us Pure?')),
      body: Container(
          child: FutureBuilder(
              future: data,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text('Loading ...'),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Text(snapshot.data[index].data['title']),
                          onTap: () => navigateToDetail(snapshot.data[index]),
                        );
                      });
                }
              })),
    );
  }
}
