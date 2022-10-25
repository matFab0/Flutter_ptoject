import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:project/data/task.dart';
import 'package:project/data/task_cubit.dart';
import 'package:project/pages/edit_task_page.dart';
import 'package:intl/intl.dart';

class TaskTiles extends StatefulWidget {
  const TaskTiles({
    Key? key,
    required this.list,
    required this.df,
  }) : super(key: key);

  final List<Task> list;
  final DateFormat df;

  @override
  // ignore: no_logic_in_create_state
  State<TaskTiles> createState() => _TaskTilesState();
}

class _TaskTilesState extends State<TaskTiles> {
  @override
  Widget build(BuildContext context) {
          return Flexible(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.list.length,
              itemBuilder: (_,i) {
                final item = widget.list[i];
                    return Dismissible(
                      key: Key(item.id.toString()),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          HapticFeedback.mediumImpact();
                          SystemSound.play(SystemSoundType.alert);
                          TaskCubit cubit = BlocProvider.of<TaskCubit>(context);
                          final bool? res = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("Are you sure you want to delete ${item.name}?"),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text("Cancel", style: TextStyle(color: Colors.black)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      setState(() {
                                        widget.list.remove(item);
                                        cubit.deleteTask(item);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            }
                          );
                          return res;     
                        } else {
                          await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => EditTaskPage(task: item,df:DateFormat.yMd().add_Hms())
                            )).then((value){
                          setState(() {
                              widget.list.removeWhere((element) => element.id == value.id);
                              widget.list.add(value);
                            });
                          });
                        }
                      },
                      background: slideRightBackground(),
                      secondaryBackground: slideLeftBackground(),
                      child: TaskTile(task: widget.list[i], df: widget.df)
                    );
                }
            )
          );
        }
      }

class TaskTile extends HookWidget {
  const TaskTile({
    Key? key,
    required this.task,
    required this.df,
  }) : super(key: key);

  final Task task;
  final DateFormat df;

  @override
  Widget build(BuildContext context) {
    final state = useState(DateTime.now());
      return ColoredBox(
        color: task.isDone ? Colors.green :state.value.isGreaterDate(task.date) ? Colors.red :  Colors.yellow.shade200,
          child: Column(
            children: [
                  Center(
                    child: Text(task.name,
                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
                    )
                  ),
                  Center(
                    child: Text(df.format(task.date),
                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
                    ),
                  ),
                  Center(
                    child: Text(task.description),
                  ),
                  const Divider(
                    height: 16,
                    thickness: 2,
                  )
                ],
              ),
            );
          }
      }

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
