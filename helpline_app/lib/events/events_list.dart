import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpline_app/common/loading_widget.dart';
import 'package:helpline_app/contacts/contact_list.dart';

class EventsList extends StatelessWidget {
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  const EventsList({Key key, this.observer, this.analytics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
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
            ),
          )
        ],
      ),
      leading: Icon(Icons.contact_phone, color: Colors.red),
      trailing: Icon(Icons.arrow_forward),
      onTap: (() => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactList(
                    eventId: document.documentID,
                    observer: observer,
                    analytics: analytics,
                  ),
            ),
          )),
    );
  }
}
