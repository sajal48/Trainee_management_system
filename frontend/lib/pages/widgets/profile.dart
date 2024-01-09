import 'dart:js_interop';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:front/controller/app_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controller/auth_controller.dart';
import '../../models/user.dart';

class ProfileWidget extends StatefulWidget {
  final User user;

  const ProfileWidget({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late TextEditingController _roleController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactNoController;
  late TextEditingController _dobController;
  late TextEditingController _educationalInstituteController;
  late TextEditingController _degreeNameController;
  late TextEditingController _passingYearController;
  late TextEditingController _cgpaController;
  late TextEditingController _designationController;
  late TextEditingController _expertiseController;
  late TextEditingController _joiningDateController;
  late TextEditingController _presentAddressController;
  PlatformFile? file;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName??"  ");
    _roleController = TextEditingController(text: widget.user.role);
    _emailController = TextEditingController(text: widget.user.email);
    _contactNoController = TextEditingController(text: widget.user.contactNo);
    _dobController = TextEditingController(text: widget.user.dob);
    _educationalInstituteController = TextEditingController(text: widget.user.educationalInstitute);
    _degreeNameController = TextEditingController(text: widget.user.degreeName);
    _passingYearController = TextEditingController(text: widget.user.passingYear);
    _cgpaController = TextEditingController(text: widget.user.cgpa);
    _designationController = TextEditingController(text: widget.user.designation);
    _expertiseController = TextEditingController(text: widget.user.expertise);
    _joiningDateController = TextEditingController(text: widget.user.joiningDate);
    _presentAddressController = TextEditingController(text: widget.user.presentAddress);
    file = widget.user.file;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _contactNoController.dispose();
    _dobController.dispose();
    _educationalInstituteController.dispose();
    _degreeNameController.dispose();
    _passingYearController.dispose();
    _cgpaController.dispose();
    _designationController.dispose();
    _expertiseController.dispose();
    _joiningDateController.dispose();
    _presentAddressController.dispose();
    super.dispose();
  }
  Widget imagebuilder(PlatformFile? file,int? fileId ){
    if(file== null){
      if(fileId== null){
        return const CircleAvatar(
              radius: 60,
              backgroundImage:AssetImage('avatar.png'),
            );
      }else{
        return CircleAvatar(
                radius: 60,
                backgroundImage:  NetworkImage('http://localhost:8080/api/v1/file/$fileId'),
              );
      }

    }else{
      return CircleAvatar(
              radius: 60,
              backgroundImage:  MemoryImage(file!.bytes!),
            );
    }

  }


  @override
  Widget build(BuildContext context) {

    var role = context.read<AuthController>().role;
    final dateFormat = DateFormat('yyyy/MM/dd');
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Center(
                  child: InkWell(
                    onTap: ()async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if(result!=null){
                        setState(() {
                          file = result.files.first;
                        });
                      }
                    },
                    child: imagebuilder(file,widget.user.profilePictureId),
                    // child:(widget.user.profilePictureId!=null) ? Container(
                    //   child: file== null? CircleAvatar(
                    //     radius: 60,
                    //     backgroundImage:  NetworkImage('http://localhost:8080/api/v1/file/${widget.user.profilePictureId}'),
                    //   ) : CircleAvatar(
                    //     radius: 60,
                    //     backgroundImage:  MemoryImage(file!.bytes!),
                    //   ),
                    // ): const CircleAvatar(
                    //   radius: 60,
                    //   backgroundImage:AssetImage('avatar.png'),
                    // )
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  child: TextField(
                    readOnly: true,
                    controller: _roleController,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          readOnly: true,
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          controller: _contactNoController,
                          decoration: InputDecoration(
                            labelText: 'Contact no',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),

                    ),
                    SizedBox(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _presentAddressController,
                          decoration: InputDecoration(
                            labelText: 'Present Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 600,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _dobController,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          _dobController.text = dateFormat.format(selectedDate); // Format the selected date
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Date Of Birth',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: role == "TRAINEE",
                  child: Column(
                    children: [
                      SizedBox(
                        width: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: _educationalInstituteController,
                            decoration: InputDecoration(
                              labelText: 'Institute',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: _degreeNameController,
                            decoration: InputDecoration(
                              labelText: 'Degree',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                _passingYearController.text =dateFormat
                                    .format(selectedDate); // Format the selected date
                              }
                            },
                            controller: _passingYearController,
                            decoration: InputDecoration(
                              labelText: 'Passing Year',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: _cgpaController,
                            decoration: InputDecoration(
                              labelText: 'CGPA',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Visibility(
                  visible: role == "TRAINER",
                  child: Column(
                    children: [
                      SizedBox(
                        width: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: _designationController,
                            decoration: InputDecoration(
                              labelText: 'Designation',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: _expertiseController,
                            decoration: InputDecoration(
                              labelText: 'Expertise',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: _joiningDateController,
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                _joiningDateController.text = dateFormat
                                    .format(selectedDate); // Format the selected date
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Joining Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 30,),


                ElevatedButton(
                  onPressed: () async{
                    User user =User(
                      file: file,
                      userId: widget.user.userId,
                      role: _roleController.text,
                      fullName: _nameController.text,
                      email: _emailController.text,
                      contactNo: _contactNoController.text,
                      dob: _dobController.text,
                      educationalInstitute: _educationalInstituteController.text,
                      degreeName: _degreeNameController.text,
                      passingYear: _passingYearController.text,
                      cgpa: _cgpaController.text,
                      designation: _designationController.text,
                      expertise: _expertiseController.text,
                      joiningDate: _joiningDateController.text,
                      presentAddress: _presentAddressController.text,
                    );
                    await context.read<AppController>().updateUser(user);
                  },
                  child: const Text('Update'),
                ),
                const SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}