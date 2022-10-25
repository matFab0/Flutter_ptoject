import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/data/task.dart';

class TasksDataSource{
  TasksDataSource({
    required FirebaseFirestore firestore,
    required this.uid})
    : _firestore = firestore;

    final FirebaseFirestore _firestore;
    final String uid;

    Future<List<Task>> getTasks(String uid) async {
      final tasks = await _firestore
            .collection('tasks')
            .where('userId',isEqualTo: uid)
            .orderBy('groupId')
            .get();
      return tasks.docs.map(Task.fromSnapshot).toList();
    }

    Future<int> getGroup(String uid) async {
      final tasks = await getTasks(uid);
      if(tasks.isNotEmpty)
      {
        return tasks.last.groupId;
      }
      return 0;
    }

    Future<int> getTaskId(String uid) async {
      final tasks = await _firestore
            .collection('tasks')
            .where('userId',isEqualTo: uid)
            .orderBy('id')
            .get();
      if(tasks.size>0)
      {
        final List<Task> task = tasks.docs.map(Task.fromSnapshot).toList();
        return task.last.id;
      }
      return 0;
    }
    Future<void> addTask(Task task) =>
      _firestore.collection('tasks').doc(task.id.toString()).set(task.toMap());

    Future<void> deleteTask(Task task) =>
      _firestore.collection('tasks').doc(task.id.toString()).delete();
    
    Future<void> updateTask(Task task) =>
      _firestore.collection('tasks').doc(task.id.toString()).set(task.toMap());

    Stream<List<Task>> get tasksStream => _firestore
      .collection('tasks')
      .where('userId',isEqualTo: uid)
      .orderBy('groupId')
      .snapshots()
      .map((m) => m.docs.map(Task.fromSnapshot).toList());
}