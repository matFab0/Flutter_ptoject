import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:project/data/task.dart';
import 'package:project/data/task_cubit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'add_task_page.dart';

class EditTaskPage extends HookWidget {
  const EditTaskPage({ 
    Key? key,
    required this.task,
    required this.df,
   }) : super(key: key);

  final Task task;
  final DateFormat df;
  
  @override
  Widget build(BuildContext context) {
    final name = useTextEditingController();
    name.text = task.name;
    final description = useTextEditingController();
    description.text = task.description;
    final date = useTextEditingController();
    date.text = DateFormat.yMd().format(task.date);
    final time = useTextEditingController();
    time.text = DateFormat.Hms().format(task.date);
    final DateTime dt = DateTime.now();
    final state = useState(dt);
    final groupName = useTextEditingController();
    groupName.text = task.groupName;
    final isDone = useState(task.isDone);

    return MaterialApp(
      title: 'Task',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        body: AddEditTaskBody(name: name, description: description, date: date, state: state, time: time,groupName: groupName,isDone: isDone,),
        floatingActionButton: FloatingActionButton(
          onPressed:() {
            HapticFeedback.lightImpact();
            SystemSound.play(SystemSoundType.click); 
            context.read<TaskCubit>().updateTask(task.groupId,task.id,name.text,description.text,state.value,task.userId,groupName.text,isDone.value);
            Task t = Task(groupId:task.groupId,id:task.id,name:name.text,description:description.text,date:state.value,userId:task.userId,groupName: groupName.text,isDone: isDone.value);
            context.read<TaskCubit>().updateGroupName(t, groupName.text);
            Navigator.pop(context,t);
          }
        ),
      ),
    );
  }
}