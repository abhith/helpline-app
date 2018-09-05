import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:helpline_app/common/loading_widget.dart';
import 'package:helpline_app/contacts/contact_list_bloc.dart';
import 'package:helpline_app/contacts/contact_list_provider.dart';
import 'package:helpline_app/contacts/empty_widget.dart';
import 'package:helpline_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactList extends StatefulWidget {
  final String eventId;
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  ContactList({Key key, this.eventId, this.observer, this.analytics})
      : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _ContactListSearchDelegate _delegate = _ContactListSearchDelegate();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _lastSelected;
  ContactListBloc bloc;

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .collection('events')
        .document(widget.eventId)
        .collection('contacts')
        .orderBy('name')
        // .limit(5)
        .snapshots()
        .listen(onContactsUpdated);
  }

  @override
  Widget build(BuildContext context) {
    bloc = ContactListProvider.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(bloc.contacts.length > 0
            ? 'Helplines (${bloc.contacts.length.toString()})'
            : 'Helplines'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String selected = await showSearch<String>(
                context: context,
                delegate: _delegate,
              );
              if (selected != null && selected != _lastSelected) {
                setState(() {
                  _lastSelected = selected;
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  // Fade in a loading screen when results are being fetched
                  LoadingWidget(visible: bloc.contacts.length == 0),
                  // Fade in the contacts if available
                  _ContactList(
                    contacts: bloc.contacts,
                    analytics: widget.analytics,
                    observer: widget.observer,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onContactsUpdated(QuerySnapshot event) {
    setState(() {
      bloc.contacts = event.documents;
    });
  }
}

class _ContactListSearchDelegate extends SearchDelegate<String> {
  final List<String> _history = <String>[
    'Police',
    'Control Room',
  ];

  ContactListBloc bloc;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    bloc = ContactListProvider.of(context);

    final Iterable<String> suggestions = query.isEmpty
        ? _history
        : bloc.contacts
            .where((contact) => contact['name']
                .toString()
                .toLowerCase()
                .startsWith(query.toLowerCase()))
            .map((contact) => contact['name'].toString());

    return _SuggestionList(
      query: query,
      suggestions: suggestions.map((String i) => '$i').toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    bloc = ContactListProvider.of(context);
    final filteredContacts = bloc.contacts
        .where((contact) => contact['name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return filteredContacts.length > 0
        ? _ContactList(
            contacts: filteredContacts,
            observer: MyApp.observer,
            analytics: MyApp.analytics)
        : EmptyWidget(visible: true);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }
}

class _ContactList extends StatelessWidget {
  final List<DocumentSnapshot> contacts;
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  const _ContactList({Key key, this.contacts, this.observer, this.analytics})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) => _buildListItem(context, contacts[index]),
    );
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
          onPressed: () => _initiateCall(document),
        );

      case 'landline':
        return IconButton(
          icon: Icon(Icons.call),
          onPressed: () => _initiateCall(document),
        );
      default:
        return IconButton(
          icon: Icon(Icons.call),
          onPressed: () => _initiateCall(document),
        );
    }
  }

  Future<Null> _initiateCall(DocumentSnapshot document) async {
    try {
      await analytics.logEvent(
        name: 'call_initiated',
        parameters: <String, dynamic>{
          'contact': document['name'],
        },
      );
    } catch (e) {
      // print(e);
    }

    await launch("tel:${document['phone']}");
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style:
                  theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
