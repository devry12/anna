import 'package:anna/core.dart';
import 'package:anna/debug.dart';
import 'package:anna/screen/detail_ui.dart';
import 'package:anna/helper/removedup.dart';
import 'package:anna/model.dart/anna_http_call.dart';
import 'package:anna/screen/ui_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class AnnaCallList extends StatefulWidget {
  AnnaCore? core;
  AnnaCallList({this.core});

  @override
  State<AnnaCallList> createState() => _AnnaCallListState();
}

class _AnnaCallListState extends State<AnnaCallList>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Anna"),
      ),
      body: GetBuilder<AnnaController>(
        init: AnnaController(),
        initState: (_) {},
        builder: (_) {
          var dist = _.callsSubject.reversed.toList();

          return Container(
            child: ListView.builder(
                itemCount: dist.length,
                itemBuilder: ((context, index) {
                  var data = dist[index];
                  return AnnaItem(
                    call: data,
                  );
                })),
          );
        },
      ),
    );
  }
}

class AnnaItem extends StatelessWidget {
  AnnaHttpCall call;
  AnnaItem({Key? key, required this.call}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (context) => AnnaDetail(
                call: call,
              ),
            ),
          );
        },
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(call.method.toUpperCase() + " " + call.endpoint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: annaStyle(color: statusColor(call))),
                  Row(
                    children: [
                      call.secure
                          ? const Padding(
                              padding: EdgeInsets.only(right: 3),
                              child: Icon(Icons.lock, size: 15),
                            )
                          : Container(),
                      Text(call.server),
                    ],
                  ),
                  Row(
                    children: [
                      Text(DateFormat('HH:mm a')
                          .format(call.response!.time ?? DateTime.now())),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(call.loading.toString()),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(call.duration.toString() + " ms"),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(call.response!.size.toString() + " B")
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),
            Center(
              child: call.loading
                  ? const CircularProgressIndicator()
                  : Text(
                      call.response!.status.toString() == "-1"
                          ? "Error"
                          : call.response!.status.toString(),
                      style: annaStyle(fontSize: 20, color: statusColor(call))),
            )
          ],
        ),
      ),
    );
  }
}

Color statusColor(AnnaHttpCall call) {
  if (call.response == null) {
    return Colors.red;
  }
  if (call.response!.status == null) {
    return Colors.red;
  }
  if (call.response!.status! >= 200) {
    return Colors.green;
  }
  if (call.response!.status! >= 400) {
    return Colors.yellow;
  }
  return Colors.red;
}

TextStyle annaStyle({Color color = Colors.black, double fontSize = 15.0}) {
  return TextStyle(color: color, fontSize: fontSize);
}
