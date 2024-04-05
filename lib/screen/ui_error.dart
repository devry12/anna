import 'package:flutter/material.dart';

import 'package:anna/model/anna_http_call.dart';

class AnnaCallErrorWidget extends StatefulWidget {
  final AnnaHttpCall call;
  const AnnaCallErrorWidget({
    Key? key,
    required this.call,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnnaCallErrorWidgetState();
  }
}

class _AnnaCallErrorWidgetState
    extends State<AnnaCallErrorWidget> {
  AnnaHttpCall get _call => widget.call;

  @override
  Widget build(BuildContext context) {
    if (_call.error != null) {
      final List<Widget> rows = [];
      final dynamic error = _call.error!.error;
      var errorText = "Error is empty";
      if (error != null) {
        errorText = error.toString();
      }
      rows.add(getListRow("Error:", errorText));

      return Container(
        padding: const EdgeInsets.all(6),
        child: ListView(children: rows),
      );
    } else {
      return const Center(child: Text("Nothing to display here"));
    }
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
        )
      ],
    );
  }
}