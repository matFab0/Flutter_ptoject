import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project/data/task.dart';
import 'package:project/data/task_cubit.dart';
import 'package:project/data/task_tiles.dart';
import 'package:project/data/tasks_data_source.dart';
import 'package:project/pages/task_page.dart';
import 'package:provider/provider.dart';
import 'add_task_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    String uid = "";
    String userName = "Guest";
    if(user!=null){
      uid=user.uid;
      if(user.displayName!=null)
      {
        userName = user.displayName!;
      }
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Provider<TasksDataSource>(
        create: (context) => TasksDataSource(
          firestore: FirebaseFirestore.instance,
          uid: uid
        ),
        child: BlocProvider(
            create: (context) => TaskCubit(
              tasksDataSource: context.read(),
              uid: uid
            )..refresh(),
            child: MaterialApp(
              title: "$userName's TodoList",
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              home: Builder(
                builder: (context) {
                  return Scaffold(
                    floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        SystemSound.play(SystemSoundType.click);
                        final groupId = await context.read<TaskCubit>().getGroup();
                        final taskId = await context.read<TaskCubit>().getTaskId();
                        Navigator.push(context, MaterialPageRoute(
                                builder: (context) => AddTaskPage(groupId: groupId+1, taskId: taskId,userId: uid,groupName2: "",)
                                ),
                              );
                      },
                      child: const Icon(Icons.add),
                    ),
                    appBar: AppBar(
                      title: Text("$userName's Todo List"),
                      actions: [
                        PopupMenuButton(itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text("Sign Out"),
                            onTap: () {
                              auth.signOut();
                              Navigator.of(context, rootNavigator: true).pop(context);
                    },
                  ),
                ],)
                      ],
                    ),
                    body: Column(
                      children: [
                        TodayTasks(uid: uid),
                        Expanded(
                          child: _List(uid: uid),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ),
    );
  }
}

class TodayTasks extends StatelessWidget {
  const TodayTasks({
    Key? key,
    required this.uid
  }) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit,TodoListState>(
      builder: (context,state) {
        return FutureBuilder<List<Task>>(
          future: context.read<TaskCubit>().getTodayTasks(),
          builder: (context,AsyncSnapshot<List<Task>> snapshot) {
              if(snapshot.hasData && state is TodoListLoadedState)
              {
                final DateFormat df2 = DateFormat.yMd();
                final DateFormat df = DateFormat.Hm();
                
                return ColoredBox(
                  color: Colors.lightGreen,
                  child: Column(
                    children: [
                      Text("Today's(${df2.format(DateTime.now())}) tasks:",
                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          children:List.generate(
                            snapshot.data!.length,
                            (i) => Center(
                              child: 
                              Container(
                                child: Text('${snapshot.data![i].name} ${df.format(snapshot.data![i].date)}'),
                                color: Colors.lightGreen,
                                ))
                        )
                        ),
                      ),
                    ],
                  ),
                );
              }
              else {
                return const SizedBox();
              }
          },
        );
      }
    );
    
  }
}

class _List extends StatelessWidget {
  const _List({
    Key? key,
    required this.uid
  }) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.watch<TaskCubit>().refresh,
      child: BlocBuilder<TaskCubit, TodoListState>(
        builder: (context, state) {
          if (state is TodoListLoadedState) {
            int groups = 0; //liczba grup
            if(state.tasks.isNotEmpty){
              groups = state.tasks.last.groupId;
            }
            return GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(
                groups,
                (i) {
                  return _TaskTile(
                  message: state.tasks,
                  groupId: i+1,
                  uid: uid,
                );
              },
            ),
          );
        } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  _TaskTile({
    Key? key,
    required this.message,
    required this.groupId,
    required this.uid
  }) : super(key: key);

  final df = DateFormat.yMd().add_Hm();
  final List<Task> message;
  final int groupId;
  final String uid;

  @override
  Widget build(BuildContext context) {
    
    List<Task> list = List.empty(growable: true);
    for(int j=0;j<message.length;j++)
    {
      if(groupId == message[j].groupId)
        {
          list.add(message[j]);
        }
    }
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(seconds: 1),
      openBuilder: (context,_) => TaskPage(list: list,groupId: groupId,uid: uid,),
      
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xfffff59d), width: 1)),
      closedColor: Colors.yellow.shade200,
      closedBuilder:(context,_) { 
        context.read<TaskCubit>().refresh;
        return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            ColoredBox(
                      color: Colors.orange.shade300,
                      child: Center(
                        child: Text(list[0].groupName,
                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
                        ),
                      ),
                    ),
            TaskTiles(
              list: list, 
              df: df
            ),
          ],
        ),
      );
    }
    );
  }
}
