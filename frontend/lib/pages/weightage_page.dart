import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/models/weightage.dart';
import 'package:provider/provider.dart';

class WeightagePage extends StatefulWidget {
  const WeightagePage({Key? key}) : super(key: key);

  @override
  WeightagePageState createState() => WeightagePageState();
}

class WeightagePageState extends State<WeightagePage> {
  late Weightage data;

  final TextEditingController dailyTaskController = TextEditingController();
  final TextEditingController midProjectController = TextEditingController();
  final TextEditingController miniProjectController = TextEditingController();
  final TextEditingController finalProjectController = TextEditingController();
  final TextEditingController domainController = TextEditingController();
  final TextEditingController managerController = TextEditingController();
  final TextEditingController trainingController = TextEditingController();
  final TextEditingController hrInterviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    data = Weightage();
  }

  @override
  void dispose() {
    dailyTaskController.dispose();
    midProjectController.dispose();
    miniProjectController.dispose();
    finalProjectController.dispose();
    domainController.dispose();
    managerController.dispose();
    trainingController.dispose();
    hrInterviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: FutureBuilder(
              future: Provider.of<AppController>(context, listen: false)
                  .getWeightage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error occurred"));
                  } else if (!snapshot.hasData) {
                    return const Center(
                        child: Text("No Batch info found for evaluation"));
                  } else {
                    data = snapshot.data as Weightage;
                    dailyTaskController.text =
                        data.dailyTaskEvaluationWeightage.toString();
                    midProjectController.text =
                        data.midProjectEvaluationWeightage.toString();
                    miniProjectController.text =
                        data.miniProjectEvaluationWeightage.toString();
                    finalProjectController.text =
                        data.finalProjectEvaluationWeightage.toString();
                    domainController.text = data.domainWeightage.toString();
                    managerController.text =
                        data.managerEvaluationWeightage.toString();
                    trainingController.text = data.trainingWeightage.toString();
                    hrInterviewController.text =
                        data.hrInterviewEvaluationWeightage.toString();

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: buildWeightageTextField(
                                  labelText: 'Daily Task Evaluation Weightage',
                                  controller: dailyTaskController,
                                ),
                              ),
                              Expanded(
                                child: buildWeightageTextField(
                                  labelText: 'Mid Project Evaluation Weightage',
                                  controller: midProjectController,
                                ),
                              ),
                              Expanded(
                                child: buildWeightageTextField(
                                  labelText: 'Mini Project Evaluation Weightage',
                                  controller: miniProjectController,
                                ),
                              ),
                            ],
                          ),
                          buildWeightageTextField(
                            labelText: 'Final Project Evaluation Weightage',
                            controller: finalProjectController,
                          ),

                          // Displaying "Domain" and "Managers" weightages in one row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: buildWeightageTextField(
                                  labelText: 'Domain Evaluation Weightage',
                                  controller: domainController,
                                ),
                              ),
                              Expanded(
                                child: buildWeightageTextField(
                                  labelText: 'Managers Evaluation Weightage',
                                  controller: managerController,
                                ),
                              ),
                            ],
                          ),

                          // Displaying "Training" and "Ceo/Hr" weightages in one row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: buildWeightageTextField(
                                  labelText: 'Training Evaluation Weightage',
                                  controller: trainingController,
                                ),
                              ),
                              Expanded(
                                child: buildWeightageTextField(
                                  labelText: 'Ceo/Hr Evaluation Weightage',
                                  controller: hrInterviewController,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  Weightage updatedData = Weightage(
                                    dailyTaskEvaluationWeightage:
                                        double.parse(dailyTaskController.text),
                                    midProjectEvaluationWeightage:
                                        double.parse(midProjectController.text),
                                    miniProjectEvaluationWeightage:
                                        double.parse(miniProjectController.text),
                                    finalProjectEvaluationWeightage:
                                        double.parse(
                                            finalProjectController.text),
                                    domainWeightage:
                                        double.parse(domainController.text),
                                    managerEvaluationWeightage:
                                        double.parse(managerController.text),
                                    trainingWeightage:
                                        double.parse(trainingController.text),
                                    hrInterviewEvaluationWeightage:
                                        double.parse(
                                            hrInterviewController.text),
                                  );

                                  await context
                                      .read<AppController>()
                                      .updateWeightage(updatedData);
                                },
                                child: const Text(
                                  'Update',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    dailyTaskController.text =
                                        data.dailyTaskEvaluationWeightage.toString();
                                    midProjectController.text =
                                        data.midProjectEvaluationWeightage.toString();
                                    miniProjectController.text =
                                        data.miniProjectEvaluationWeightage.toString();
                                    finalProjectController.text =
                                        data.finalProjectEvaluationWeightage.toString();
                                    domainController.text = data.domainWeightage.toString();
                                    managerController.text =
                                        data.managerEvaluationWeightage.toString();
                                    trainingController.text = data.trainingWeightage.toString();
                                    hrInterviewController.text =
                                        data.hrInterviewEvaluationWeightage.toString();
                                  });
                                },
                                child: const Text(
                                  'Clear',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWeightageTextField({
    required String labelText,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextFormField(
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}