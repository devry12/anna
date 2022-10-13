import 'package:flutter/material.dart';

import 'package:anna/helper/anna_conversion_helper.dart';
import 'package:anna/helper/anna_parser.dart';
import 'package:anna/model.dart/anna_http_call.dart';

class AnnaCallRequestWidget extends StatefulWidget {
  final AnnaHttpCall call;

  const AnnaCallRequestWidget({
    Key? key,
    required this.call,}
  ) : super(key: key);

 @override
  State<StatefulWidget> createState() {
    return _AnnaCallRequestWidgetState();
  }

 
}

class _AnnaCallRequestWidgetState
    extends State<AnnaCallRequestWidget>{
      AnnaHttpCall get _call => widget.call;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];
    rows.add(getListRow("Started:", _call.request!.time.toString()));
    rows.add(getListRow("Bytes sent:", formatBytes(_call.request!.size)));
    rows.add(
      getListRow("Content type:", getContentType(_call.request!.headers)!),
    );

    final dynamic body = _call.request!.body;
    var bodyContent = "Body is empty";
    if (body != null) {
      bodyContent = formatBody(body, getContentType(_call.request!.headers));
    }
    rows.add(getListRow("Body:", bodyContent));
    final formDataFields = _call.request!.formDataFields;
    if (formDataFields?.isNotEmpty == true) {
      rows.add(getListRow("Form data fields: ", ""));
      for (var field in formDataFields!) {
          rows.add(getListRow("   • ${field.name}:", field.value));
        }
    }
    final formDataFiles = _call.request!.formDataFiles;
    if (formDataFiles?.isNotEmpty == true) {
      rows.add(getListRow("Form data files: ", ""));
      for (var field in formDataFiles!) {
          rows.add(
            getListRow(
              "   • ${field.fileName}:",
              "${field.contentType} / ${field.length} B",
            ),
          );
        }
    }

    final headers = _call.request!.headers;
    var headersContent = "Headers are empty";
    if (headers.isNotEmpty) {
      headersContent = "";
    }
    rows.add(getListRow("Headers: ", headersContent));
    _call.request!.headers.forEach((header, dynamic value) {
      rows.add(getListRow("   • $header:", value.toString()));
    });
    final queryParameters = _call.request!.queryParameters;
    var queryParametersContent = "Query parameters are empty";
    if (queryParameters.isNotEmpty) {
      queryParametersContent = "";
    }
    rows.add(getListRow("Query Parameters: ", queryParametersContent));
    _call.request!.queryParameters.forEach((query, dynamic value) {
      rows.add(getListRow("   • $query:", value.toString()));
    });

    return Container(
      padding: const EdgeInsets.all(6),
      child: ListView(children: rows),
    );
  }

   Widget getListRow(String name, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 5),
        ),
        Flexible(
          child: SelectableText(
            value,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 18),
        ),
      ],
    );
  }

   String formatBytes(int bytes) => AnnaConversionHelper.formatBytes(bytes);

  String formatDuration(int duration) =>
      AnnaConversionHelper.formatTime(duration);

  String formatBody(dynamic body, String? contentType) =>
      AnnaParser.formatBody(body, contentType);

  String? getContentType(Map<String, dynamic>? headers) =>
      AnnaParser.getContentType(headers);
}