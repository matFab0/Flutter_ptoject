import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/data/task.dart';
import 'package:project/data/tasks_data_source.dart';

class TaskCubit extends Cubit<TodoListState> {
  TaskCubit({required TasksDataSource tasksDataSource,
  required this.uid})
      : _tasksDataSource = tasksDataSource,
        super(const TodoListInitialState()) {
    _sub = _tasksDataSource.tasksStream.listen((tasks) =>
        emit(TodoListLoadedState(tasks: tasks.toList())));
  }

  final TasksDataSource _tasksDataSource;
  late final StreamSubscription _sub;
  final String uid;

  Future<void> refresh() async {
    final tasks = await _tasksDataSource.getTasks(uid);
    emit(TodoListLoadedState(
      tasks: tasks.toList(),
    ));
  }

  Future<List<Task>> getTodayTasks() async {
    final tasks = await _tasksDataSource.getTasks(uid);
    List<Task> list = List<Task>.empty(growable: true);
    for(var task in tasks)
    {
      if(task.date.isSameDate(DateTime.now())) {
        list.add(task);
      }
    }
    return list;
  }

  Future<int> getGroup() async {
    final group = await _tasksDataSource.getGroup(uid);
    return group;
  }

  Future<int> getTaskId() async {
    final taskId = await _tasksDataSource.getTaskId(uid);
    return taskId;
  }
  Future<void> updateGroupName(Task task,String groupName) async {
    int groupId = task.groupId;
    final tasks = await _tasksDataSource.getTasks(task.userId);
      for(var t in tasks)
      {
        if(t.groupId == groupId)
        {
          Task pom = Task(
            groupId: t.groupId,
            id: t.id,
            userId: t.userId,
            groupName: groupName,
            name: t.name,
            description: t.description,
            date: t.date,
            isDone: t.isDone
          );
        _tasksDataSource.updateTask(pom);
        }
      }
  }
  Future<void> deleteTask(Task task) async {
    int groupId = task.groupId;
    _tasksDataSource.deleteTask(task);
    final tasks = await _tasksDataSource.getTasks(task.userId);
    
    if(tasks.where((element) => element.groupId == groupId).isEmpty)
    {
      for(var t in tasks)
      {
        if(t.groupId>groupId)
        {
          Task pom = Task(
            groupId: t.groupId-1,
            id: t.id,
            userId: t.userId,
            groupName: t.groupName,
            name: t.name,
            description: t.description,
            date: t.date,
            isDone: t.isDone
          );
        _tasksDataSource.updateTask(pom);
        }
      }
    }
  }

  Future<void> addTask(int groupId,int id, String name, String description, DateTime dateTime, String userId,String groupName,bool isDone) =>
      _tasksDataSource.addTask(Task(
        groupId: groupId,
        id: id,
        userId: userId,
        groupName: groupName,
        name: name,
        description: description,
        date: dateTime,
        isDone: isDone
      ));
  Future<void> updateTask(int groupId,int id, String name, String description, DateTime dateTime, String userId,String groupName,bool isDone) =>
      _tasksDataSource.updateTask(Task(
        groupId: groupId,
        id: id,
        userId: userId,
        groupName: groupName,
        name: name,
        description: description,
        date: dateTime,
        isDone: isDone
      ));

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}

abstract class TodoListState {
  const TodoListState();
}

class TodoListInitialState extends TodoListState {
  const TodoListInitialState();
}

class TodoListLoadedState extends TodoListState {
  const TodoListLoadedState({
    required this.tasks,
  });

  final List<Task> tasks;
}

extension DateCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
           && day == other.day;
  }

  bool isGreaterDate(DateTime other) {
    return year > other.year || (year == other.year && month > other.month) 
          || (year == other.year && month == other.month && day > other.day)
          || (year == other.year && month == other.month && day == other.day && hour > other.hour)
          || (year == other.year && month == other.month && day == other.day && hour == other.hour && minute > other.minute);
  }
}


