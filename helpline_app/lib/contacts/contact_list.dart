import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactList extends StatelessWidget {
  final String eventId;

  const ContactList({Key key, this.eventId}) : super(key: key);

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
          title: new Text('Helplines'),
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('events')
              .document(eventId)
              .collection('contacts')
              .orderBy('name')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          },
        ));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['name']),
      subtitle: Text(document['phone']),
      trailing: _itemAction(context, document),
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
    );
  }

  Widget _itemAction(BuildContext context, DocumentSnapshot document) {
    switch (document['type']) {
      case 'mobile':
        return IconButton(
          icon: Icon(Icons.phone_android),
          onPressed: () => launch("tel:${document['phone']}"),
        );

      case 'landline':
        return IconButton(
          icon: Icon(Icons.call),
          onPressed: () => launch("tel:${document['phone']}"),
        );
      default:
        return IconButton(
          icon: Icon(Icons.call),
          onPressed: () => launch("tel:${document['phone']}"),
        );
    }
  }
}