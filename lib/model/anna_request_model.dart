import 'package:anna/model.dart/anna_from_data_field.dart';
import 'package:anna/model.dart/anna_from_data_file.dart';
import 'dart:io';
class AnnaHttpRequest {
  int size = 0;
  DateTime time = DateTime.now();
  Map<String, dynamic> headers = <String, dynamic>{};
  dynamic body = "";
  String? contentType = "";
  List<Cookie> cookies = [];
  Map<String, dynamic> queryParameters = <String, dynamic>{};
  List<AnnaFormDataFile>? formDataFiles;
  List<AnnaFormDataField>? formDataFields;
}