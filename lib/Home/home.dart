import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/Home/Provider/provider.dart';
import 'package:todo_app/Home/test.dart';
import 'package:todo_app/Model/TaskDetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  late TabController _tabController;
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Define a function to show the bottom sheet
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return const NewTask();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                _drawerKey.currentState?.openEndDrawer();
              },
              icon: Icon(Icons.dashboard_outlined)),
          title: SizedBox(
            width: 100,
            height: kToolbarHeight,
            // Set the height to match the AppBar's height
            child: Center(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                // Remove horizontal padding
                leading: Icon(Icons.library_add_check_outlined),
                title: Text(
                  "To-do",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: Icon(Icons.calendar_month))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Center the widget at the bottom
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height*0,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay; // update `_focusedDay` here as well
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarFormat: CalendarFormat.week,
                  ),
                ),
                const Divider(),
                TabBar(controller: _tabController, tabs: [
                  Tab(
                    text: "All",
                  ),
                  Tab(
                    text: "Completed Tasks",
                  ),
                ]),
              ],
            ),
            Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.56,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Content for the "All" tab
                    Consumer<TaskProvider>(
                        builder: (context, taskProvider, child) {
                      return Container(
                        //    color: Colors.orange,
                        width: MediaQuery.of(context).size.width,
                        //height: 200,
                        height: MediaQuery.of(context).size.height * 0.02,
                        child: taskProvider.createdTasks.isEmpty
                            ? Center(
                                child: Text("No available Tasks"),
                              )
                            : Container(
                                //color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                child: ListView.builder(
                                  itemCount: taskProvider.createdTasks.length,
                                  itemBuilder: (context, index) {
                                    Task tasks =
                                        taskProvider.createdTasks[index];
                                    return Dismissible(
                                      background: Container(
                                          color: Colors.red,
                                          child: Icon(Icons.delete)),
                                      key: Key(tasks.id.toString()),
                                      onDismissed: (direction) {
                                        // Handle task dismissal here
                                        setState(() {
                                          // Remove the dismissed task from the list
                                          taskProvider.deleteTask(tasks);
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              // color: Color(0xFF5375DE),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.22,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  child: ListTile(
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                          tasks.title,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              tasks.isImportant,
                                                          child: Icon(
                                                            Icons.star,
                                                            color:
                                                                Colors.yellow,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    trailing: TextButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        "Edit",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ListTile(
                                                    title: Text(
                                                      tasks.description,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        height: 20,
                                                        child: Row(
                                                          children: [
                                                            Text(tasks.date
                                                                .toString()),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(tasks.time
                                                                .toString()),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width *
                                                                  0.25,
                                                            ),

                                                            Checkbox(
                                                              checkColor: Colors.green,
                                                              value: tasks
                                                                  .IsCompleted,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  tasks.IsCompleted =
                                                                      value!;
                                                                });
                                                              },
                                                            ),

                                                                Text(
                                                                  tasks.IsCompleted ? "Completed" : "",
                                                                  style: TextStyle(
                                                                    color: Colors.green
                                                                  ),
                                                                )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(thickness: 1,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      );
                    }),
                    Consumer<TaskProvider>(
                        builder: (context, taskProvider, child) {
                      return Container(
                          //    color: Colors.orange,
                          width: MediaQuery.of(context).size.width,
                          //height: 200,
                          height: MediaQuery.of(context).size.height * 0.02,
                          child: taskProvider.completedTasks.isEmpty
                              ? Center(
                                  child: Text("No Completed Tasks"),
                                )
                              : Container(
                                  //color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  child: ListView.builder(
                                      itemCount:
                                          taskProvider.completedTasks.length,
                                      itemBuilder: (context, index) {
                                        Task tasks =
                                            taskProvider.completedTasks[index];
                                        return
                                          Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(16),
                                                // color: Color(0xFF5375DE),
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.22,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    child: ListTile(
                                                      title: Row(
                                                        children: [
                                                          Text(
                                                            tasks.title,
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                Colors.black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Visibility(
                                                            visible:
                                                            tasks.isImportant,
                                                            child: Icon(
                                                              Icons.star,
                                                              color:
                                                              Colors.yellow,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      trailing: TextButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          "Edit",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: ListTile(
                                                      title: Text(
                                                        tasks.description,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.9,
                                                          height: 20,
                                                          child: Row(
                                                            children: [
                                                              Text(tasks.date
                                                                  .toString()),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(tasks.time
                                                                  .toString()),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .width *
                                                                    0.2,                                                              ),
                                                              Text(
                                                                tasks.IsCompleted ? "Completed" : "",
                                                                style: TextStyle(
                                                                  color: Colors.green
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(thickness: 1,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })));
                    }),
                  ],
                ),
              ),
            ]),
            Center(
              child: SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: Row(
                      children: [
                        Text("Add new task"),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5)
          ],
        ),
    );
  }
}
