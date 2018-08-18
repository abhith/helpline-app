import 'package:flutter/material.dart';
import 'package:helpline_app/contacts/contact_list_bloc.dart';
import 'package:helpline_app/contacts/contact_list_provider.dart';
import 'package:helpline_app/events/events_list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() {
  final ContactListBloc bloc = ContactListBloc();

  runApp(new MyApp(
    bloc: bloc,
  ));
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      new FirebaseAnalyticsObserver(analytics: analytics);

  final ContactListBloc bloc;

  const MyApp({Key key, this.bloc}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ContactListProvider(
      contactListBloc: bloc,
      child: MaterialApp(
        title: 'Helpline',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new EventsList(
          observer: observer,
          analytics: analytics,
        ),
        navigatorObservers: <NavigatorObserver>[observer],
      ),
    );
  }
}
