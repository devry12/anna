import 'package:anna/debug.dart';
import 'package:anna/model.dart/anna_error.dart';
import 'package:anna/model.dart/anna_http_call.dart';
import 'package:anna/model.dart/anna_response_model.dart';
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
    final callsCount = controller.callsSubject.length;
    if (callsCount >= maxCallsCount) {
      final originalCalls = controller.callsSubject;
      final calls = List<AnnaHttpCall>.from(originalCalls);
      calls.sort(
        (call1, call2) => call1.createdTime.compareTo(call2.createdTime),
      );
      final indexToReplace = originalCalls.indexOf(calls.first);
      originalCalls[indexToReplace] = call;
      controller.callsSubject = originalCalls;
      // callsSubject.avdd(originalCalls);
    } else {
      if (noDup(call)) {
        controller.callsSubject.add(call);
      }else{
      int index = controller.callsSubject.indexWhere((element) => element.endpoint == call.endpoint);
       controller.callsSubject.removeAt(index);
       controller.callsSubject.add(call);
    }
    }
  }

  void addError(AnnaHttpError error, int requestId) {
    final AnnaHttpCall? selectedCall = _selectCall(requestId);

    if (selectedCall == null) {
      logDebug("Selected call is", "null");
      return;
    }

    selectedCall.error = error;
    if (noDup(selectedCall)) {
      controller.callsSubject.add(selectedCall);
    }else{
      int index = controller.callsSubject.indexWhere((element) => element.endpoint == selectedCall.endpoint);
       controller.callsSubject.removeAt(index);
       controller.callsSubject.add(selectedCall);
    }
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
    int dup = 0;
    for (var item in controller.callsSubject) {
      if (item.endpoint == call.endpoint) {
        dup++;
      }
    }
    if (dup < 1) {
      return true;
    } else {
      return false;
    }
  }

  AnnaHttpCall? _selectCall(int requestId) =>
      controller.callsSubject.firstWhereOrNull((call) => call.id == requestId);
}

class AnnaController extends GetxController {
  RxList<AnnaHttpCall> callsSubject = RxList([]);
  RxBool isOpen = RxBool(false);
}
