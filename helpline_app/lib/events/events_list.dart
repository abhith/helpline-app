import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Firestore.instance.collection('events').snapshots() , builder: (context, snapshot){
      if(!snapshot.hasData) return const CircularProgressIndicator();
      
      return ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder:(context, index) => _buildListItem(context, snapshot.data.documents[index]),
              );
        
            },);
          }
        
         Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
           return ListTile(title:Text(document['name']));
         }
}