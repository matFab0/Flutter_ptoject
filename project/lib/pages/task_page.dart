import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:project/data/task.dart';
import 'package:intl/intl.dart';
import 'package:project/data/task_cubit.dart';
import 'package:project/data/task_tiles.dart';
import 'package:project/pages/add_task_page.dart';
import 'package:provider/provider.dart';


class TaskPage extends HookWidget {
  const TaskPage({ 
    Key? key, 
    required this.list,
    required this.groupId,
    required this.uid
    }) : super(key: key);

  final List<Task> list;
  final int groupId;
  final String uid;

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = list;
    final state = useState(tasks);
    final df = DateFormat.yMd().add_Hm();
    return MaterialApp(
      title: 'Task',
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      home: Scaffold(
        backgroundColor: Colors.yellow.shade200,
        appBar: AppBar(
          title: Text(state.value.first.groupName),
        ),
        body: 
           Column(
            children: [
               TaskTiles(
                  list: state.value, 
                  df: df
                ),
                ElevatedButton(
                  onPressed:() => Navigator.pop(context),
                  child: const Text("Go back")
                ),
            ],
          ),
        
      floatingActionButton: FloatingActionButton(
                  onPressed: () async { 
                    HapticFeedback.lightImpact();
                    SystemSound.play(SystemSoundType.click);
                    final taskId = await context.read<TaskCubit>().getTaskId();
                    await Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => AddTaskPage(groupId: groupId, taskId: taskId,userId: uid,groupName2: state.value.first.groupName,)),
                        ).then((value){
                          if(value!=null) {
                            state.value = [...state.value,value];
                          }  
                        });  
                  },
                  child: const Icon(Icons.add),
                ),
      )
    );
  }
}