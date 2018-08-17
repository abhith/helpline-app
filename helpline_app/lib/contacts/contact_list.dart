import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpline_app/common/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactList extends StatelessWidget {
  final String eventId;
  ContactList({Key key, this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('events')
            .document(eventId)
            .collection('contacts')
            .orderBy('name')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget(
              visible: true,
            );
          }
          return new Scaffold(
            appBar: new AppBar(
              title: Text(
                  'Helplines (${snapshot.data.documents.length.toString()})'),
            ),
            body: ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            ),
          );
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['name']),
      subtitle: Text(document['phone']),
      trailing: _itemAction(context, document),
      leading: CircleAvatar(
        child: Text(document['name'][0]),
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
