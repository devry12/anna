import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:anna/core.dart';
import 'package:anna/model.dart/anna_http_call.dart';
import 'package:anna/screen/detail_ui.dart';
import 'package:clipboard/clipboard.dart';

class AnnaCallList extends StatefulWidget {
  final AnnaCore? core;
  const AnnaCallList({Key? key, this.core}) : super(key: key);

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
          title: const Text("Anna", style: TextStyle(color: Colors.white))),
      body: GetX<AnnaController>(
        init: AnnaController(),
        initState: (_) {},
        builder: (_) {
          var dist = _.callsSubject.reversed.toList();
          return dist.isEmpty
              ? const Center(
                  child: Text("data not found"),
                )
              : ListView.builder(
                  itemCount: dist.length,
                  itemBuilder: ((context, index) {
                    var data = dist[index];
                    return AnnaItem(
                      call: data,
                    );
                  }));
        },
      ),
    );
  }
}

class AnnaItem extends StatelessWidget {
  final AnnaHttpCall call;
  const AnnaItem({
    Key? key,
    required this.call,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onLongPress:(){
          FlutterClipboard.copy(
                          call.uri)
                      .then((value) =>
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Success Copied"),
                          )));
        },
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
  print(call.response!.status is int);
  if (call.response == null) {
    return Colors.red;
  }
  if (call.response!.status == null) {
    return Colors.red;
  }
  if (call.response!.status! >= 200 && call.response!.status! < 300) {
    return Colors.green;
  }
  if (call.response!.status! >= 400 && call.response!.status! < 500) {
    return Colors.orange;
  }
  if (call.response!.status! >= 500) {
    return Colors.red;
  }
  return Colors.red;
}

TextStyle annaStyle({Color color = Colors.black, double fontSize = 15.0}) {
  return TextStyle(color: color, fontSize: fontSize);
}
