import 'dart:convert';

import 'package:anna/core.dart';
import 'package:anna/model.dart/anna_error.dart';
import 'package:anna/model.dart/anna_from_data_field.dart';
import 'package:anna/model.dart/anna_from_data_file.dart';
import 'package:anna/model.dart/anna_http_call.dart';
import 'package:anna/model.dart/anna_request_model.dart';
import 'package:anna/model.dart/anna_response_model.dart';
import 'package:dio/dio.dart';

InterceptorsWrapper dioInterceptors({required AnnaCore core}) {
  return InterceptorsWrapper(onRequest: (options, handler) {
    final AnnaHttpCall call = AnnaHttpCall(options.hashCode);
    var data = options.data;
    final Uri uri = options.uri;
    call.method = options.method;
    var path = options.uri.path;
    if (path.isEmpty) {
      path = "/";
    }
    call.endpoint = path;
    call.server = uri.host;
    call.client = "Dio";
    call.uri = options.uri.toString();

    if (uri.scheme == "https") {
      call.secure = true;
    }
    AnnaHttpRequest annaRequest = AnnaHttpRequest();
    if (data == null) {
      annaRequest.body = "";
      annaRequest.size = 0;
    } else {
      annaRequest.body = data;
      annaRequest.size = utf8.encode(data.toString()).length;
    }
    if (data is FormData) {
      annaRequest.body += "Form data";

      if (data.fields.isNotEmpty == true) {
        final List<AnnaFormDataField> fields = [];
        for (var entry in data.fields) {
          fields.add(AnnaFormDataField(entry.key, entry.value));
        }
        annaRequest.formDataFields = fields;
      }
      if (data.files.isNotEmpty == true) {
        final List<AnnaFormDataFile> files = [];
        for (var entry in data.files) {
          files.add(
            AnnaFormDataFile(
              entry.value.filename,
              entry.value.contentType.toString(),
              entry.value.length,
            ),
          );
        }

        annaRequest.formDataFiles = files;
      } else {
        annaRequest.size = utf8.encode(data.toString()).length;
        annaRequest.body = data;
      }
    }
    annaRequest.time = DateTime.now();
    annaRequest.headers = options.headers;
    annaRequest.contentType = options.contentType.toString();
    annaRequest.queryParameters = options.queryParameters;

    call.request = annaRequest;
    call.response = AnnaHttpResponse();
    core.addCall(call);
    return handler.next(options); //continue
  }, onResponse: (response, handler) {
    var annaResponse = AnnaHttpResponse();
    if (response.data == null) {
      annaResponse.body = "";
      annaResponse.size = 0;
    } else {
      annaResponse.body = response.data;
      annaResponse.size = utf8.encode(response.data.toString()).length;
    }
    annaResponse.time = DateTime.now();
    annaResponse.status = response.statusCode;
    final Map<String, String> headers = {};
    response.headers.forEach((header, values) {
      headers[header] = values.toString();
    });
    annaResponse.headers = headers;
    core.addResponse(annaResponse, response.requestOptions.hashCode);
    return handler.next(response); // continue
  }, onError: (DioError error, handler) {
    final annaError = AnnaHttpError();
    annaError.error = error.toString();
    if (error is Error) {
      final basicError = error as Error;
      annaError.stackTrace = basicError.stackTrace;
    }

    core.addError(annaError, error.requestOptions.hashCode);
    final httpResponse = AnnaHttpResponse();
    httpResponse.time = DateTime.now();
    if (error.response == null) {
      httpResponse.status = -1;
      core.addResponse(httpResponse, error.requestOptions.hashCode);
    } else {
      httpResponse.status = error.response!.statusCode;

      if (error.response!.data == null) {
        httpResponse.body = "";
        httpResponse.size = 0;
      } else {
        httpResponse.body = error.response!.data;
        httpResponse.size = utf8.encode(error.response!.data.toString()).length;
      }
      final Map<String, String> headers = {};
      error.response!.headers.forEach((header, values) {
        headers[header] = values.toString();
      });
      httpResponse.headers = headers;
      core.addResponse(
        httpResponse,
        error.response!.requestOptions.hashCode,
      );
    }
    return handler.next(error); //continue
  });
}
