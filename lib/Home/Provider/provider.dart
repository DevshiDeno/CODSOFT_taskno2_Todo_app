import 'package:flutter/cupertino.dart';
import 'package:todo_app/Model/TaskDetails.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> createdTasks = [];
  List<Task> get tasks => createdTasks;

  void addTask(Task task) {
    createdTasks.add(task);
    notifyListeners(); // Notify listeners when the list changes
  }
  void deleteTask(Task task) {
    createdTasks.remove(task);
    notifyListeners(); // Notify listeners when the list changes
  }
  List<Task> get completedTasks => createdTasks.where((task) => task.IsCompleted).toList();

// void edit Task(Task){
//   cre
// }
}
