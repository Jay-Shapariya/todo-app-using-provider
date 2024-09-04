import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/model/task_model.dart';

class TaskViewmodel extends ChangeNotifier {
  List<Task> tasks = [];
  String? taskName;
  final dateCount = TextEditingController();
  final timeCount = TextEditingController();

  bool get isValid =>
      taskName != null && dateCount.text == "" && timeCount.text == "";

  setTaskName(String? value) {
    taskName = value;
    notifyListeners();
    log(value.toString());
  }

  setDate(DateTime? date) {
    if (date == null) {
      return;
    }
    log(date.toString());

    DateTime currentDate = DateTime.now();
    DateTime now =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    int diff = date.difference(now).inDays;
    if (diff == 0) {
      dateCount.text = "Today";
    }else if(diff == 1){
      dateCount.text = "Tomorrow";
    }
    else{
      dateCount.text = "${date.day}-${date.month}-${date.year}";
    }

    notifyListeners();

  }

  setTime(TimeOfDay? time) {
    log(time.toString());
    if (time == null) {
      return;
    }
    if (time.hour == 0) {
      timeCount.text = "12:${time.minute} AM";
    }else if(time.hour < 12){
      timeCount.text = "${time.hour}:${time.minute} AM";
    }
    else if (time.hour == 12){
      timeCount.text = "${time.hour}:${time.minute} PM";
    }
    else{
      timeCount.text = "${time.hour-12}:${time.minute} PM";
    }
    notifyListeners();
  }

  addTask() {
    if (isValid) {
      return;
    }
    final task = Task( dateCount.text,taskName!, timeCount.text);
    dateCount.clear();
    timeCount.clear();
    tasks.add(task);
    log(tasks.length.toString());
    notifyListeners();
  }
}
