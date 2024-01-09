import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/models/batch.dart';
import 'package:front/pages/widgets/batch_info.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controller/auth_controller.dart';

class BatchPage extends StatefulWidget {
  const BatchPage({Key? key}) : super(key: key);

  @override
  BatchPageState createState() => BatchPageState();
}

class BatchPageState extends State<BatchPage> {
  int selectedItemIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<AppController>().getData();
  }


  @override
  Widget build(BuildContext context) {

    String role = context.read<AuthController>().role;
    final appController = context.watch<AppController>();


    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Scaffold(
        appBar: AppBar(title: Text("Batch",),  automaticallyImplyLeading: false,),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: role == "ADMIN"
              ? Padding(
                  padding: const EdgeInsets.only(right: 20,top: 10),
                  child: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      _showAddBatchDialog();
                    },
                  ),
                )
              : null,
          body: appController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      batchListItems(appController.batches),
                      Expanded(
                        child: Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: appController.batches.isEmpty
                                ? const Text("No Batches")
                                : BatchInfoWidget(
                                    batch:appController.batches[selectedItemIndex])),
                      ),
                    ],
                  ),
                )),
    );
  }

  Widget batchListItems(List<Batch> batches) {
    if (batches.isEmpty) {
      return Container();
    }
    return SizedBox(
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: batches.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: selectedItemIndex == index ? HexColor("#EDE7F6") : null,
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.top,
                    selected: selectedItemIndex == index,
                    // selectedColor: Colors.purple,
                    title: Text(batches[index].batchName!),
                    onTap: () {
                      setState(() {
                        selectedItemIndex = index;
                      });
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddBatchDialog() {
    TextEditingController batchNameController = TextEditingController();
    TextEditingController batchDescriptionController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();

    final dateFormat = DateFormat('yyyy/MM/dd');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Batch'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: batchNameController,
                  decoration: const InputDecoration(labelText: 'Batch Name'),
                ),
                TextFormField(
                  controller: batchDescriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Batch Description'),
                ),
                TextFormField(
                  controller: startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                  onTap: () async {
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
                  },
                ),
                TextFormField(
                  controller: endDateController,
                  decoration: const InputDecoration(labelText: 'End Date'),
                  onTap: () async {
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
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                String batchName = batchNameController.text;
                String startDate = startDateController.text;
                String endDate = endDateController.text;
                String description = batchDescriptionController.text;
                var response = await context
                    .read<AppController>()
                    .addBatch(batchName, description, startDate, endDate);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
