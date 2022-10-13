import 'package:anna/model.dart/anna_http_call.dart';
import 'package:anna/screen/ui_error.dart';
import 'package:anna/screen/ui_request.dart';
import 'package:anna/screen/ui_response.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class AnnaDetail extends StatefulWidget {
  final AnnaHttpCall call;

  const AnnaDetail({Key? key, required this.call}) : super(key: key);

  @override
  State<AnnaDetail> createState() => _AnnaDetailState();
}

class _AnnaDetailState extends State<AnnaDetail>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Anna"),
          bottom: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              controller: controller,
              tabs: const <Tab>[
                Tab(
                  text: "Request",
                ),
                Tab(
                  text: "Response",
                ),
                Tab(
                  text: "Error",
                ),
              ])),
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.share),
        closedForegroundColor: Colors.black,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.white,
        openBackgroundColor: Colors.black,
        // labelsStyle:
        labelsBackgroundColor: Colors.white,
        // controller: /* Your custom animation controller goes here */,
        speedDialChildren: <SpeedDialChild>[
          if (controller!.index != 2) ...{
            SpeedDialChild(
              child: const Icon(Icons.copy),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              label: 'Copy Header',
              onPressed: () {
                if (controller!.index == 0) {
                  FlutterClipboard.copy(widget.call.request!.headers.toString())
                      .then((value) =>
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Success Copied"),
                          )));
                } else {
                  FlutterClipboard.copy(
                          widget.call.response!.headers.toString())
                      .then((value) =>
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Success Copied"),
                          )));
                }
              },
              closeSpeedDialOnPressed: false,
            ),
            if (controller!.index == 0) ...{
              SpeedDialChild(
                child: const Icon(Icons.copy),
                foregroundColor: Colors.black,
                backgroundColor: Colors.green,
                label: 'Copy Parameters',
                onPressed: () {
                  if (controller!.index == 0) {
                    FlutterClipboard.copy(
                            widget.call.request!.queryParameters.toString())
                        .then((value) =>
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Success Copied"),
                            )));
                  }
                },
              ),
            },
            
              SpeedDialChild(
                child: const Icon(Icons.copy),
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
                label: 'Copy Body',
                onPressed: () {
                  if (controller!.index == 0) {
                    if (widget.call.request!.body != null || widget.call.request!.body != ""){
                    FlutterClipboard.copy(widget.call.request!.body.toString())
                        .then((value) => ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Success Copied"),
                            )));
                    }else{
                      FlutterClipboard.copy("empty")
                        .then((value) => ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Body is empty"),
                            )));
                    }
                  } else {
                    FlutterClipboard.copy(widget.call.response!.body.toString())
                        .then((value) => ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Success Copied"),
                            )));
                  }
                },
              ),
            
          } else ...{
            SpeedDialChild(
              child: const Icon(Icons.copy),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              label: 'Copy Error',
              onPressed: () {
                FlutterClipboard.copy(widget.call.error!.error.toString()).then(
                    (value) =>
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Success Copied"),
                        )));
              },
            ),
          }

          //  Your other SpeedDialChildren go here.
        ],
      ),
      body: TabBarView(controller: controller, children: <Widget>[
        AnnaCallRequestWidget(call: widget.call),
        AnnaCallResponseWidget(call: widget.call),
        AnnaCallErrorWidget(call: widget.call,)
      ]),
    );
  }
}
