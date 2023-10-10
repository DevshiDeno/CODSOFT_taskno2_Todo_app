import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Home/Provider/provider.dart';
import 'package:todo_app/Model/TaskDetails.dart';
import 'package:intl/intl.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool importantChecked = false; // Separate variable for "Important"
  bool notImportantChecked = false; // Separate variable for "Not Important"
  DateTime? selectedDate=DateTime.now(); // Provide a default date
  TimeOfDay? selectedTime=TimeOfDay.now(); // Define a variable to store the selected date
  //List<Task> createdTask = [];

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(
      text: selectedDate != null
          ? "${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}"
          : "",
    );
    timeController = TextEditingController(
      text: selectedTime != null
          ? "${selectedTime?.hour}:${selectedTime?.minute}"
          : "",
    );
  }

  @override
  void dispose() {
    super.dispose();
    taskController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.72,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    'New Task',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Divider(),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 420,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Task title"),
                      TextFormField(
                        controller: taskController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Task cannot be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Add Task Name...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text("Description"),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                            labelText: "Add description...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
//                            color: Colors.orange,
                              width: MediaQuery.of(context).size.width * 0.36,
                              child: Center(
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                  title: Row(
                                    children: [
                                      Text("Important"),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              importantChecked =
                                                  !importantChecked;
                                            });
                                          },
                                          icon: importantChecked
                                              ? Icon(Icons.check_box)
                                              : Icon(Icons
                                                  .check_box_outline_blank_outlined))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            Container(
                              height: 40,
                              //color: Colors.orange,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Center(
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                  title: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
                                    children: [
                                      Text(" Not Important"),
                                      IconButton(
                                          padding: EdgeInsets.all(0),
                                          // Remove padding around the IconButton
                                          onPressed: () {
                                            setState(() {
                                              notImportantChecked =
                                                  !notImportantChecked;
                                            });
                                          },
                                          icon: notImportantChecked
                                              ? Icon(Icons.check_box)
                                              : Icon(Icons
                                                  .check_box_outline_blank_outlined))
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //color: Colors.orange,
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text("Date"),
                                ),
                                TextFormField(
                                  controller: dateController,
                                  decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                          onPressed: () async {
                                            DateTime? picked =
                                                await showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2030),
                                                    initialDate: selectedDate ??
                                                        DateTime.now());
                                            if (picked != null &&
                                                picked != selectedDate) {
                                              setState(() {
                                                selectedDate = picked;
                                                dateController.text = DateFormat("dd/MM/yy").format(selectedDate!);
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.date_range)),
                                      // Add the icon inside the text field
                                      labelText: "dd/mm/yy",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            // color: Colors.orange,
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text("Time"),
                                ),
                                TextFormField(

                                  controller: timeController,
                                  decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                          onPressed: () async {
                                            TimeOfDay? timePicked =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime ??
                                                        TimeOfDay.now());
                                            if (timePicked != null &&
                                                timePicked != selectedTime) {
                                              setState(() {
                                                selectedTime = timePicked;
                                                timeController.text = selectedTime!.format(context);
                                              });
                                            }
                                          },
                                          icon:
                                              Icon(Icons.watch_later_outlined)),
                                      labelText: "hh:mm",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Close the bottom sheet
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Task currentTask = Task(
                                    title: taskController.text,
                                    description: descriptionController.text,
                                    isImportant: importantChecked,
                                    NotImportant: notImportantChecked,
                                    time: timeController.text,
                                    date: dateController.text,
                                    id: Random().nextInt(100000),
                                  );
                                  //Access the TaskProvider and add the task
                                  final taskProvider =
                                      Provider.of<TaskProvider>(context,
                                          listen: false);
                                  taskProvider.addTask(currentTask);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Create'),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
