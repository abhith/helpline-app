import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpline_app/common/loading_widget.dart';
import 'package:helpline_app/contacts/contact_list.dart';

class EventsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text('Events'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: Firestore.instance.collection('events').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget(
                visible: true,
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            document['name'],
            style: Theme.of(context).textTheme.headline,
          ))
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.red,
      ),
      trailing: Icon(Icons.arrow_right),
      onTap: (() => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactList(
                    eventId: document.documentID,
                  ),
            ),
          )),
    );
  }
}
