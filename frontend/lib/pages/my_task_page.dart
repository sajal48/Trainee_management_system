import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/controller/auth_controller.dart';
import 'package:front/pages/widgets/my_task_table.dart';
import 'package:provider/provider.dart';

import '../models/task_types.dart';

class MyTaskPage extends StatefulWidget {
  const MyTaskPage({super.key});

  @override
  MyTaskPageState createState() => MyTaskPageState();
}

class MyTaskPageState extends State<MyTaskPage> {
  String? selectedTaskType;

  int? selectedBatchId;

  List<String> tasks = [];
  List<String> taskTypes = TaskType.values.map((e) => e.name).toList();

  @override
  void initState() {
    super.initState();
    context.read<AppController>().getData();
  }

  @override
  Widget build(BuildContext context) {
    int userId = context.read<AuthController>().userId!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text("Task"),
        // ),
        body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              DropdownButtonFormField<String>(
                                value: selectedTaskType,
                                hint: const Text("Select Task Type"),
                                items: taskTypes.map((String taskType) {
                                  return DropdownMenuItem<String>(
                                    value: taskType,
                                    child: Text(taskType),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedTaskType = newValue!;
                                  });
                                },
                              ),
                              if (selectedTaskType != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedTaskType = null;
                                      });
                                    },
                                    icon: Icon(Icons.clear),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                      child: (selectedTaskType== null)?Container():Padding(
                    padding: const EdgeInsets.all(18),
                    child: FutureBuilder(
                        future: context.read<AppController>().getBatchId(userId, selectedTaskType!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("Error occurred"));
                            } else if (!snapshot.hasData) {
                              return const Center(
                                  child: Text(
                                      "Not Task info found"));
                            } else {
                              return MyTaskTable(
                                taskList:snapshot.data!,
                                selectedBatchId: selectedBatchId,
                                selectedTaskType: selectedTaskType,
                              );
                            }

                          }
                        }),
                  )),
                ],
              ),
      ),
    );
  }
}
