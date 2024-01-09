import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/pages/info_graphics.dart';
import 'package:provider/provider.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<AppController>().getInfoGraphicsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return const Center(child: Text("Error occurred"));
            } else if (snapshot.hasData) {
              return InfographicPage(
                traineesCount: snapshot.data!.traineeCount,
                trainersCount: snapshot.data!.trainerCount,
                tasksCount: 0,
                batchCount: snapshot.data!.batchCount,
                finalEvaluations: snapshot.data!.finalScore,
                batches: snapshot.data!.batches,
              );

            } else {
              return const Center(child: Text("No Statics Data available"));
              //
            }
          }
        });
  }
}
