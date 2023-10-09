import 'package:flutter/material.dart';

class Task {
 final  int id;
  String title;
  String description;
  bool isImportant;
  bool NotImportant;
  bool IsCompleted;
  String date;
  String time;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isImportant=false,
    required this.NotImportant,
    this.IsCompleted=false,
    required this.date,
    required this.time,
  });
}
