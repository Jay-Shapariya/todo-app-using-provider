import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/const/const.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/viewmodel/tasks_viewmodel.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(
                Icons.check,
                size: 20,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "To Do List",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
        backgroundColor: primary,
      ),
      floatingActionButton: const CustomFAB(),
      body: Consumer<TaskViewmodel>(
        builder: (context,taskProvider,_) {
          return ListView.separated(
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return  TaskWidget(task: task,);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: primary,
                  height: 1,
                  thickness: 1,
                );
              },
              itemCount: taskProvider.tasks.length);
        }
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,required this.task
  });
  final Task task;

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      title: Text(
        task.taskName,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      subtitle: Text(
        "${task.date}, ${task.time}",
        style: const TextStyle(color: textBlue),
      ),
    );
  }
}

class CustomFAB extends StatelessWidget {
  const CustomFAB({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return const CustomDialog();
          },
        );
      },
      backgroundColor: primary,
      child: const Icon(
        Icons.add,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    final taskProvider = Provider.of<TaskViewmodel>(context, listen: false);
    return Dialog(
      backgroundColor: secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      child: SizedBox(
        height: h * 0.55,
        width: w * 0.8,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "New Task",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "What has to be done?",
                style: TextStyle(color: primary),
              ),
              CustomTextfield(
                onChanged: (v) {
                  taskProvider.setTaskName(v);
                  
                },
                hint: "Enter a task",
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Due date",
                style: TextStyle(color: primary),
              ),
              CustomTextfield(
                hint: "Enter a date",
                controller: taskProvider.dateCount,
                icon: Icons.calendar_month_outlined,
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2040),
                      initialDate: DateTime.now());

                      taskProvider.setDate(date);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextfield(
                hint: "Enter a time",
                icon: Icons.timer,
                controller: taskProvider.timeCount,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now(),);
                  taskProvider.setTime(time);
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async{
                      await taskProvider.addTask();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text(
                      "Create",
                      style: TextStyle(color: primary),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      required this.hint,
      this.icon,
      this.onTap,
      this.readOnly = false,
      this.controller,
      this.onChanged});
  final String hint;
  final IconData? icon;
  final bool readOnly;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextField(
        readOnly: readOnly,
        onChanged: onChanged,
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            suffixIcon: InkWell(
                onTap: onTap,
                child: Icon(
                  icon,
                  color: Colors.white,
                )),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
