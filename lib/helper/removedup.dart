import 'package:anna/model.dart/anna_http_call.dart';
import 'package:get/state_manager.dart';

RxList<AnnaHttpCall> removeDuplicates(RxList<AnnaHttpCall> call) {
  //create one list to store the distinct models 
  RxList<AnnaHttpCall> distinct;
  RxList<AnnaHttpCall> dummy = call;

  for(int i = 0; i < call.length; i++) {
    for (int j = 1; j < dummy.length; j++) {
      if (dummy[i].endpoint == call[j].endpoint) {
        dummy.removeAt(j);
      }
    }
  }
  distinct = dummy;

  return distinct;
}