import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:project/data/task.dart';
import 'package:project/data/task_cubit.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

class AddTaskPage extends HookWidget {
  const AddTaskPage({ 
    Key? key,
    required this.taskId,
    required this.groupId,
    required this.userId,
    required this.groupName2
   }) : super(key: key);

  final int taskId;
  final int groupId;
  final String userId;
  final String groupName2;
  
  @override
  Widget build(BuildContext context) {
    final name = useTextEditingController();
    final description = useTextEditingController();
    final date = useTextEditingController();
    final time = useTextEditingController();
    final groupName = useTextEditingController();
    groupName.text = groupName2;
    final DateTime dt = DateTime.now();
    final state = useState(dt);
    final isDone = useState(false);

    return MaterialApp(
      title: 'Task',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title:const Text('Add new task'),
        ),
        body: AddEditTaskBody(name: name, description: description, date: date, state: state, time: time,isDone: isDone,groupName: groupName,),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed:() { 
            HapticFeedback.lightImpact();
            SystemSound.play(SystemSoundType.click);
            context.read<TaskCubit>().addTask(groupId,taskId+1,name.text,description.text,state.value,userId,groupName.text,isDone.value);
            Task t = Task(groupId:groupId,id:taskId+1,name:name.text,description:description.text,date:state.value,userId:userId,groupName: groupName.text,isDone: isDone.value);
              context.read<TaskCubit>().updateGroupName(t, groupName.text);
            Navigator.pop(context,t); 
          }
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AddEditTaskBody extends StatelessWidget {
  AddEditTaskBody({
    Key? key,
    required this.name,
    required this.description,
    required this.date,
    required this.state,
    required this.time,
    required this.isDone,
    required this.groupName
  }) : super(key: key);

  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController date;
  final ValueNotifier<DateTime> state;
  final TextEditingController time;
  ValueNotifier<bool> isDone;
  final TextEditingController groupName;

  @override
  Widget build(BuildContext context) {
     Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'GroupName',
                    prefixIcon: Icon(Icons.task,color: Color(0xFF1B5E20)),
                  ),
                  controller: groupName,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (name){
                  if (name!.isEmpty){
                    return 'Name is required';
                  } else if (name.length < 4){
                    return "This name is too short (minimum 4 characters)";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Name',
                    prefixIcon: Icon(Icons.task,color: Color(0xFF1B5E20)),
                  ),
                  controller: name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (name){
                  if (name!.isEmpty){
                    return 'Name is required';
                  } else if (name.length < 4){
                    return "This name is too short (minimum 4 characters)";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: description,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Descritpion',
                    prefixIcon: Icon(Icons.description,color: Color(0xFF1B5E20))
                  ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: date,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Date',
                    prefixIcon: Icon(Icons.date_range,color: Color(0xFF1B5E20)),
                  ),
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2100, 12, 31,23,59),
                      theme: const DatePickerTheme(
                          headerColor: Color(0xFF1B5E20),
                          backgroundColor: Colors.green,
                          itemStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          cancelStyle: 
                              TextStyle(color: Colors.red, fontSize: 16)
                          ),
                    onConfirm: (pickedDate) {
                      String formattedDate = DateFormat.yMd().format(pickedDate);
                      date.text = formattedDate;
                      state.value = pickedDate;
                  }, currentTime: DateTime.now(), locale: LocaleType.pl);
                },  
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: time,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Time',
                    prefixIcon: Icon(Icons.timer,color: Color(0xFF1B5E20)),
                  ),
                onTap: () {
                  DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      theme: const DatePickerTheme(
                          headerColor: Color(0xFF1B5E20),
                          backgroundColor: Colors.green,
                          itemStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          cancelStyle: 
                              TextStyle(color: Colors.red, fontSize: 16)
                          ),
                    onConfirm: (pickedDate) {
                      String formattedDate = DateFormat.Hms().format(pickedDate);
                      time.text = formattedDate;
                      state.value = DateTime(state.value.year,state.value.month,state.value.day,pickedDate.hour,pickedDate.minute,pickedDate.second);
                  }, currentTime: DateTime.now(), locale: LocaleType.pl);
                },
              ),
              Row(
                children: [
                  const Text("Is the task done?"),
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isDone.value,
                    onChanged: (bool? value) {
                      isDone.value = value!;
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}