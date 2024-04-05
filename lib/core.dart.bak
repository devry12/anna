import 'package:anna/debug.dart';
import 'package:anna/model/anna_error.dart';
import 'package:anna/model/anna_http_call.dart';
import 'package:anna/model/anna_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnnaCore {
  GlobalKey<NavigatorState>? navigatorKey;
  int maxCallsCount;

  AnnaCore({this.navigatorKey, this.maxCallsCount = 100});
  var controller = Get.put(AnnaController());


  List<AnnaHttpCall> removeDuplicates(List<AnnaHttpCall> call) {
    //create one list to store the distinct models
    List<AnnaHttpCall> distinct;
    List<AnnaHttpCall> dummy = call;

    for (int i = 0; i < call.length; i++) {
      for (int j = 1; j < dummy.length; j++) {
        if (dummy[i].endpoint == call[j].endpoint) {
          dummy.removeAt(j);
        }
      }
    }
    distinct = dummy;

    return distinct.map((e) => e).toList();
  }

 void addCall(AnnaHttpCall call) {
  final callsSubject = controller.callsSubject;
  final callsCount = callsSubject.length;
  
  if (callsCount >= maxCallsCount) {
    final calls = List<AnnaHttpCall>.from(callsSubject)
      ..sort((call1, call2) => call1.createdTime.compareTo(call2.createdTime));
    final indexToReplace = callsSubject.indexOf(calls.first);
    callsSubject[indexToReplace] = call;
  } else {
    if (!noDup(call)) {
      final index = callsSubject.indexWhere((element) => element.endpoint == call.endpoint);
      callsSubject.removeAt(index);
    }
    callsSubject.add(call);
  }
}

  void addError(AnnaHttpError error, int requestId) {
  final AnnaHttpCall? selectedCall = _selectCall(requestId);

  if (selectedCall == null) {
    logDebug("Selected call is", "null");
    return;
  }

  selectedCall.error = error;

  if (!noDup(selectedCall)) {
    final index = controller.callsSubject.indexWhere((element) => element.endpoint == selectedCall.endpoint);
    controller.callsSubject.removeAt(index);
  }
  
  controller.callsSubject.add(selectedCall);
}


  void addResponse(AnnaHttpResponse response, int requestId) {
    final AnnaHttpCall? selectedCall = _selectCall(requestId);

    if (selectedCall == null) {
      return;
    }
    selectedCall.loading = false;
    selectedCall.response = response;
    selectedCall.duration = response.time!.millisecondsSinceEpoch -
        selectedCall.request!.time.millisecondsSinceEpoch;
    if (noDup(selectedCall)) {
      controller.callsSubject.add(selectedCall);
    }else{
      int index = controller.callsSubject.indexWhere((element) => element.endpoint == selectedCall.endpoint);
       controller.callsSubject.removeAt(index);
       controller.callsSubject.add(selectedCall);
    }
  }

  // void addHttpCall(AnnaHttpCall annaHttpCall) {
  //   assert(annaHttpCall.request != null, "Http call request can't be null");
  //   assert(annaHttpCall.response != null, "Http call response can't be null");
  //   controller.callsSubject.add(annaHttpCall);
  // }

  /// Remove all calls from calls subject
  void removeCalls() {
    controller.callsSubject.clear();
  }

 bool noDup(AnnaHttpCall call) {
  return !controller.callsSubject.any((item) => item.endpoint == call.endpoint);
}


  AnnaHttpCall? _selectCall(int requestId) =>
      controller.callsSubject.firstWhereOrNull((call) => call.id == requestId);
}

class AnnaController extends GetxController {
  RxList<AnnaHttpCall> callsSubject = RxList([]);
  RxBool isOpen = RxBool(false);
}
