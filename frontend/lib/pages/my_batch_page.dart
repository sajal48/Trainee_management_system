import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/pages/widgets/batch_info.dart';
import 'package:provider/provider.dart';

import '../controller/auth_controller.dart';

class MyBatchPage extends StatefulWidget {
  const MyBatchPage({Key? key}) : super(key: key);

  @override
  MyBatchPageState createState() => MyBatchPageState();
}

class MyBatchPageState extends State<MyBatchPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int? userId = context.read<AuthController>().userId;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Scaffold(
          body: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: FutureBuilder(
                                future: context
                                    .read<AppController>()
                                    .getBatchByUserId(userId),
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
                                          child: Text("Not Task info found"));
                                    } else {
                                      return BatchInfoWidget(
                                          batch: snapshot.data!);
                                    }
                                  }
                                })),
                      ),
                    ],
                  ),
                )),
    );
  }
}
