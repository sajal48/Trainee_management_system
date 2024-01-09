import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/api/api_service.dart';
import 'package:front/models/api_response.dart';
import 'package:front/models/user_type.dart';
import 'package:front/pages/widgets/toasts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';

import '../main.dart';

class AuthController extends ChangeNotifier {
  FToast fToast = FToast();

  final LocalStorage store;
  bool isLoggedIn = false;
  late ApiService apiService;

  var log = Logger();

  int? get userId => getUserId();

  String get role => getRole();

  initToast(context){
    fToast.init(context);
  }


  AuthController(this.store) {
    apiService = ApiService(store);
  }


  bool saveToken(String token) {
    log.i("token saved");
    store.setItem("JwtToken", token);
    return true;
  }


  String? getToken() {
    return store.getItem("JwtToken");
  }

  Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  int? getUserId() {
    String? token = getToken();
    Map<String, dynamic> map = decodeToken(token!);
    var id = map['userId'];
    isLoggedIn = true;
    return id;
  }

  String getRole() {
    String? token = getToken();
    Map<String, dynamic> map = decodeToken(token!);
    return map['role'];
  }

  void logOut(context) async {
    isLoggedIn = false;
    notifyListeners();
    await store.clear();
    Navigator.pushReplacementNamed(context, '/');
  }

  void checkLoggedInStatus() {
    String? token = getToken();
    if (token == null) {
      isLoggedIn = false;
    } else {
      if((JwtDecoder.isExpired(token!))) {
        isLoggedIn = false;
      }else{
        isLoggedIn = true;
      }
    }
    log.i(isLoggedIn);
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<bool> login(String email, String password) async {
    ApiResponse response = await apiService.login(email, password);
    if (response.status == ApiResponseStatus.success) {
      log.i('success');
      saveToken(response.data['token']);
      isLoggedIn = true;
      notifyListeners();
      // Access the response data
      return true;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: Duration(seconds: 2),
      );
    }
    return false;
  }

  Future<bool> register(String email, String password,
      UserType userType) async {
    ApiResponse response = await apiService.register(email, password, userType);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Registered Successfully go to Login"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: Duration(seconds: 2),
      );// Access the response data
      return true;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: Duration(seconds: 2),
      );// Access the error data
    }
    return false;
  }

}
