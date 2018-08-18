import 'package:flutter/material.dart';
import 'package:helpline_app/contacts/contact_list_bloc.dart';

class ContactListProvider extends InheritedWidget {
  final ContactListBloc contactListBloc;

  ContactListProvider({
    Key key,
    ContactListBloc contactListBloc,
    Widget child,
  })  : contactListBloc = contactListBloc ?? ContactListBloc(),
        super(key: key, child: child);

  static ContactListBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ContactListProvider)
            as ContactListProvider)
        .contactListBloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
