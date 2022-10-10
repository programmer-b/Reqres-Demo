import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reqres_demo/utils.dart';

class ApiProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _requestSuccess = false;
  bool get requestSuccess => _requestSuccess;

  bool _requestFailure = false;
  bool get requestFailure => _requestFailure;

  void init() {
    _isLoading = false;
    _requestFailure = false;
    _requestSuccess = false;
    notifyListeners();
  }

  void load() {
    _isLoading = true;
    notifyListeners();
  }

  Future<Object> post({required Uri uri, required Object? body}) async {
    try {
      load();
      final data =
          await http.post(uri, body: body).timeout(const Duration(seconds: 10));
      if (data.statusCode == 200) {
        _isLoading = false;
        _requestSuccess = true;
        notifyListeners();
        return data.body;
      } else {
        _isLoading = false;
        _requestFailure = true;
        notifyListeners();
        return data.body;
      }
    } on TimeoutException {
      toastError('OOPS! CONNECTION TIMEOUT REACHED');
      _isLoading = false;
      notifyListeners();
      rethrow;
    } on SocketException {
      toastError('NO INTERNET CONNECTION');
      _isLoading = false;
      notifyListeners();
      rethrow;
    } catch (e) {
      toastError('SOMETHING WENT WRONG: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
