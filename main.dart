import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: MyHomePage()//TodosScreen(
       // todos: List.generate(
        //  20,
        //  (i) => Todo('Forum Title $i',
           //   'A description of what needs to be done for Forum $i', i),
       // ),
     // ),
    );
  }
}



class CommentScreen extends StatefulWidget
{
  final String name;
  final String description;
  CommentScreen(this.name,this.description);


  @override
  _CommentScreenDetail createState() => _CommentScreenDetail(name,description);

}

class _CommentScreenDetail extends State<CommentScreen>

{
final String name;
final String description;
_CommentScreenDetail(this.name,this.description);



  Widget _commentWidget = new Container(
    padding: const EdgeInsets.all(6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration.collapsed(
              hintText: '@Comment',
            ),
          ),
        ),
        new SizedBox(
          width: 80.0,
          height: 20.0,
          child: new RaisedButton(
            child: new Text('Post', style: TextStyle(color:Colors.lightBlueAccent),),
            onPressed: (){},
          ),
        ),

      ],
    ),
  );



  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ListView(
          children: <Widget>[
            Text(description),
       _commentWidget,
      ],
    ),
    );
  }


}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baby Name Votes')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('comments').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

        

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          onTap: (){

              Navigator.push(
              context,
             MaterialPageRoute(
              builder: (context) => CommentScreen(record.name,record.description),
              ),
            );
         },// => record.reference.updateData({'votes': record.votes + 1}),
        ),
      ),
    );
  }
}

class Record {
  final String name;
  final int votes;
  final String description;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        assert(map['description'] != null),
        name = map['name'],
        votes = map['votes'],
        description = map['description'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes:$description>";
}

