import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'listFromFirestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter K12 App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return ListPage();
                }));
              },
              child: Text(
                'Science Chapter 1 - Matter in our surroundings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              )),
          FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return ListChapPage();
                }));
              },
              child: Text(
                'Science Chapter 2 - Is Matter around us Pure?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              )),
        ],
      )),
      // body: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future _data;

  Future getData() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn =
        await firestore.collection('Beginner level').getDocuments();

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
    _data = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Matter in our surroundings')),
      body: Container(
          child: FutureBuilder(
              future: _data,
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

class DetailPage extends StatefulWidget {
  final DocumentSnapshot docSnap;

  DetailPage({this.docSnap});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docSnap.data['title']),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Card(
              //   child: Text(
              //     widget.docSnap.data['chap1'],
              //     style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              // ),

              Card(
                child: Text(
                  widget.docSnap.data['intro'],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),

              // Text(
              //   widget.docSnap.data['concepts'],
              //   style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500)),
            ],

            // child: ListTile(
            //   title: Text(widget.docSnap.data['title']),
            //   subtitle: Text(widget.docSnap.data['intro']),
            // )
          ),
        ),
      ),
    );
  }
}
