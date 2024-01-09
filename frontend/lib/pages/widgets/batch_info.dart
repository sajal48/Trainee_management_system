import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/models/batch.dart';
import 'package:front/models/user.dart';
import 'package:front/pages/widgets/user_avatar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controller/auth_controller.dart';

class BatchInfoWidget extends StatefulWidget {
  final Batch batch;

  const BatchInfoWidget({super.key, required this.batch});

  @override
  BatchInfoWidgetState createState() => BatchInfoWidgetState();
}

class BatchInfoWidgetState extends State<BatchInfoWidget> {
  bool isEditing = false;
  bool isAddingTrainee = false;
  late TextEditingController nameController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController activeController;
  late TextEditingController descriptionController;
  List<User> selectedTrainees = [];
  late bool active;

  @override
  void initState() {
    super.initState();

  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
      nameController = TextEditingController(text: widget.batch.batchName);
      startDateController = TextEditingController(text: widget.batch.startDate);
      endDateController = TextEditingController(text: widget.batch.endDate);
      activeController =
          TextEditingController(text: widget.batch.status.toString());
      descriptionController =
          TextEditingController(text: widget.batch.description);
    });
  }

  void toggleAddingTrainee() {
    setState(() {
      isAddingTrainee = !isAddingTrainee;
      selectedTrainees = widget.batch.trainees!;
    });
  }

  void saveChanges() async {
    var status = await context.read<AppController>().updateBatch(
        widget.batch.id!,
        nameController.text,
        descriptionController.text,
        startDateController.text,
        endDateController.text,
        activeController.text);
    if (status) {
      setState(() {
        isEditing = !isEditing;
      });
    }
  }

  final dateFormat = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context) {
    nameController = TextEditingController(text: widget.batch.batchName);
    startDateController = TextEditingController(text: widget.batch.startDate);
    endDateController = TextEditingController(text: widget.batch.endDate);
    activeController =
        TextEditingController(text: widget.batch.status.toString());
    descriptionController =
        TextEditingController(text: widget.batch.description);
    active = widget.batch.status!;
    print("build");
    final appController = context.read<AppController>();
    String role = context.read<AuthController>().role;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Batch Name: ${widget.batch.batchName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Visibility(
                visible: role == "ADMIN",
                child: Padding(
                  padding: const EdgeInsets.only(right: 70),
                  child: Row(
                    children: [
                      if (!isEditing)
                        IconButton(
                          onPressed: toggleEdit,
                          icon: const Icon(Icons.edit),
                        ),
                      if (!isAddingTrainee)
                        IconButton(
                          onPressed: toggleAddingTrainee,
                          icon: const Icon(Icons.person_add),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  child: TextField(
                    readOnly: !isEditing,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'batch name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 400,
                  child: TextField(
                    maxLines: 3,
                    readOnly: !isEditing,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(

                        readOnly: !isEditing,
                        controller: startDateController,
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onTap: role == "ADMIN"? () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            startDateController.text = dateFormat
                                .format(selectedDate); // Format the selected date
                          }
                        }:null,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        readOnly: !isEditing,
                        controller: endDateController,
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onTap: role == "ADMIN"? () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            endDateController.text = dateFormat
                                .format(selectedDate); // Format the selected date
                          }
                        }:null,
                      ),
                    ),
                    const SizedBox(width: 50,)
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Visibility(
              //   visible: isEditing,
              //   child: const Text("Status"),
              // ),
              // Visibility(
              //   visible: isEditing,
              //   child: Switch(
              //     value: active,
              //     onChanged: (value) {
              //       setState(() {
              //         active = value;
              //         activeController.text = value.toString();
              //       });
              //     },
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Visibility(
              //   visible: !isEditing,
              //   child: Container(
              //     padding: const EdgeInsets.all(8.0),
              //     decoration: BoxDecoration(
              //         color: activeController.text == "true"
              //             ? Colors.green
              //             : Colors.red,
              //         borderRadius: BorderRadius.circular(30)),
              //     child: Text("Active : ${activeController.text}"),
              //   ),
              // ),
              const SizedBox(height: 16),
              Visibility(
                visible: role == "ADMIN",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: isEditing,
                      child: ElevatedButton(
                        onPressed: saveChanges,
                        child: const Text('Save'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Visibility(
                      visible: isEditing,
                      child: TextButton(
                        onPressed: toggleEdit,
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),

          if (isAddingTrainee)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
                  child: Text('Select Trainees:',style: TextStyle(fontSize: 18),),
                ),
                const SizedBox(
                  height: 20,
                ),
                appController.unassignedTrainees.isEmpty
                    ? const Text("Every trainee is Assigned",style: TextStyle(color: Colors.redAccent),)
                    : SizedBox(
                        height: 200,
                        child: ListView(
                          children:
                              appController.unassignedTrainees.map((trainee) {
                            return CheckboxListTile(
                              title: Text(trainee.email!),
                              value: appController.check(
                                  trainee.userId!, selectedTrainees),
                              onChanged: (selected) {
                                setState(() {
                                  if (selected!) {
                                    selectedTrainees.add(trainee);
                                  } else {
                                    selectedTrainees.remove(trainee);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: toggleAddingTrainee,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        await appController.addTrainee(widget.batch);
                        toggleAddingTrainee();
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
              ],
            ),
          const SizedBox(
            height: 10,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const Material(
                  color: Colors.deepPurpleAccent,
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("Trainees",style: TextStyle(fontSize: 18),),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                height: 500,
                width: double.infinity,
                child: GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 4,
                  mainAxisSpacing: 2,
                  childAspectRatio: .8,// Number of columns in the grid
                  children: widget.batch.trainees!
                      .map((trainee) => UserAvatar(user: trainee))
                      .toList(),
                ),
              ),
            ],
          )

          //here show the UserDetailsWidget horizontally ----- from widgets.trainees! it should be scrollable
        ],
      ),
    );
  }
}

// SizedBox(
// height: 600,
// width: 500,
// child: SingleChildScrollView(
// scrollDirection: Axis.horizontal,
// child: Row(
// children: widget.batch.trainees!
//     .map((trainee) => UserAvatar(user: trainee))
//     .toList(),
// ),
// ),
// )
