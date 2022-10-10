import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

void toastError(error) {
  toast('$error', gravity: ToastGravity.TOP, bgColor: Colors.red);
}
