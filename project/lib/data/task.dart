import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  const Task({
    required this.groupId,
    required this.id,
    required this.userId,
    required this.groupName,
    required this.name,
    required this.description,
    required this.date,
    required this.isDone
  });

  final int groupId;
  final int id;
  final String userId;
  final String name;
  final String description;
  final DateTime date;
  final String groupName;
  final bool isDone;

  static Task fromSnapshot(
    QueryDocumentSnapshot<Map<String,dynamic>> snapshot)=>
    Task(
      groupId: snapshot.data()['groupId'],
      id: snapshot.data()['id'],
      userId: snapshot.data()['userId'],
      groupName: snapshot.data()['groupName'],
      name: snapshot.data()['name'],
      description: snapshot.data()['description'],
      date: (snapshot.data()['date'] as Timestamp).toDate(),
      isDone: snapshot.data()['isDone']
     );

  Map<String,dynamic> toMap() => {
    'groupId': groupId,
    'id': id,
    'userId': userId,
    'groupName': groupName,
    'name': name,
    'description': description,
    'date': Timestamp.fromDate(date),
    'isDone': isDone
  };
}