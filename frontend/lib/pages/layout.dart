import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/controller/auth_controller.dart';
import 'package:front/pages/evaluation_page.dart';
import 'package:front/pages/hr_page.dart';
import 'package:front/pages/managers_page.dart';
import 'package:front/pages/my_batch_page.dart';
import 'package:front/pages/my_task_page.dart';
import 'package:front/pages/submission_page.dart';
import 'package:front/pages/task_page.dart';
import 'package:front/pages/weightage_page.dart';
import 'package:front/pages/widgets/header.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'batch_page.dart';
import 'dasboard_page.dart';
import 'finalscore_page.dart';
import 'widgets/ink_item.dart';


class Layout extends StatefulWidget {


  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int selectedItemIndex = 0;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var userId = context.read<AuthController>().userId;
    context.read<AppController>().getUser(userId!);
         return  Scaffold(
           backgroundColor: Colors.white,
           body: Column(
             children: [
                const SizedBox(height: 110, child: Header(),),
               Expanded(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisSize: MainAxisSize.max,
                   children: [
                     sideNavBar(context.read<AuthController>().role),
                     Expanded(
                       child: Container(
                           padding:
                           const EdgeInsetsDirectional.only(top: 20,start: 15,end: 15),
                           decoration: BoxDecoration(
                             color: HexColor("#EEF2F6"),
                             borderRadius: BorderRadius.circular(10),
                           ),
                           child: _buildSelectedPage()
                       ),
                     ),
                     const SizedBox(
                       width: 20,
                     ),
                   ],
                 ),
               ),
             ],
           ),
         );




  }

  Widget _buildSelectedPage() {

    switch (selectedItemIndex) {
      case 0:
        return const DashBoardPage();
      case 1:
        return const BatchPage();
      case 2:
        return const TaskPage();
      case 3:
        return const EvaluationPage();
      case 4:
        return const ManagersEvaluationPage();
      case 5:
        return const HrEvaluationPage();
      case 6:
        return const WeightagePage();
      case 7:
        return const FinalScorePage();

      case 8:
        return  const MyTaskPage();
      case 10:
        return  const MyBatchPage();
      case 11:
        return  const SubmissionPage();
      default:
        return DashBoardPage();
    }
  }

  SizedBox sideNavBar(String role) {

    List<Widget> menuItems = [];
    void buildMenuItemIfAllowed(int index, String text, List<String> allowedRoles,
        {bool isSection = false,required IconData icon}) {
      if (allowedRoles.contains(role)) {
        if(isSection){
          menuItems.add(Section( text: text));
        }else{
        menuItems.add(buildMenuItem(index, text,icon));}
      }
    }
    buildMenuItemIfAllowed(99, 'Dashboard', ['ADMIN', 'TRAINER', 'TRAINEE'],isSection: true,icon: Icons.dashboard);
    buildMenuItemIfAllowed(0, 'Dashboard', ['ADMIN', 'TRAINER', 'TRAINEE'],icon: Icons.dashboard);
    buildMenuItemIfAllowed(99, 'Management', ['ADMIN', 'TRAINER', 'TRAINEE'],isSection: true,icon: Icons.manage_accounts);
    buildMenuItemIfAllowed(10, 'My Batch', ['TRAINEE'],icon: Icons.school);
    buildMenuItemIfAllowed(8, 'My Task', ['TRAINEE'],icon: Icons.task);
    buildMenuItemIfAllowed(6, 'Evaluation weightage', ['ADMIN'],icon: Icons.balance);
    buildMenuItemIfAllowed(1, 'Batch', ['ADMIN', 'TRAINER'],icon: Icons.school);
    buildMenuItemIfAllowed(2, 'Task', ['ADMIN', 'TRAINER',],icon: Icons.task);
    buildMenuItemIfAllowed(11, 'Submissions', ['TRAINER'],icon: Icons.file_copy);
    buildMenuItemIfAllowed(99, 'Evaluation', ['ADMIN', 'TRAINER', ],isSection: true,icon: Icons.draw);
    buildMenuItemIfAllowed(3, 'Task/Project', ['ADMIN', 'TRAINER'],icon: Icons.developer_board);
    buildMenuItemIfAllowed(4, 'Manager', ['ADMIN'],icon: Icons.groups_2);
    buildMenuItemIfAllowed(5, 'Ceo/Hr', ['ADMIN'],icon: Icons.group_work);
    buildMenuItemIfAllowed(7, 'Final Score', ['ADMIN', 'TRAINER'],icon: Icons.leaderboard);





    return SizedBox(
      width: 250,
      child:  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: menuItems,
        ),
      )

    );
  }

  Widget buildMenuItem(int index, String text,IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            selectedItemIndex = index;
          });
        },
        child: InkItem(
            selectedItemIndex: selectedItemIndex,
            index: index,
            icon: icon,
            text: text,
            selecteedColor: HexColor("#EDE7F6"),
            disabledColor: Colors.white),
      ),
    );
  }
}

class Section extends StatelessWidget {
  const Section({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
    );
  }
}
