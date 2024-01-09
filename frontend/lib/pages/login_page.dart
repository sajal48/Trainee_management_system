import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:front/controller/auth_controller.dart';
import 'package:front/models/user_type.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailValidator = ValidationBuilder()
      .required('please provide a email')
      .email("please provide a valid email")
      .build();
  final _passwordValidator = ValidationBuilder()
      .required('please provide a password')
      .minLength(6, "at least 6")
      .maxLength(20, "max 20")
      .build();
  toogleVisibility() => setState(
        () {
      passwordVisible = !passwordVisible;
    },
  );

  void _updateButtonState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formKey.currentState?.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            alignment: Alignment.center,
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("EMS",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 27),),
                const SizedBox(
                  height: 50,
                ),
                Form(
                    key: _formKey,
                    onChanged: _updateButtonState,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(children: [
                      TextFormField(
                        validator: _emailValidator,
                        controller: _email,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.email),
                            labelText: 'Email',
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        validator: _passwordValidator,
                        controller: _password,
                        textAlign: TextAlign.center,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: toogleVisibility,
                            ),
                            labelText: 'Password',
                            border: const OutlineInputBorder()),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _formKey.currentState?.validate() ?? false
                            ? ()async {
                          bool status = await context
                              .read<AuthController>()
                              .login(_email.text, _password.text);
                          if(status){
                            Navigator.pushNamed(context, '/home');
                          }

                        }
                            : null,
                        child: Text("Log In",
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ])),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.black38,
                  thickness: 0.3,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register/${UserType.trainee.name}');
                    },
                    child: const Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ));
  }
}