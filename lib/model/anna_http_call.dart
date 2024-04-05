import 'package:anna/model.dart/anna_error.dart';
import 'package:anna/model.dart/anna_request_model.dart';
import 'package:anna/model.dart/anna_response_model.dart';

class AnnaHttpCall {
  final int id;
  late DateTime createdTime;
  String client = "";
  bool loading = true;
  bool secure = false;
  String method = "";
  String endpoint = "";
  String server = "";
  String uri = "";
  int duration = 0;

  AnnaHttpRequest? request;
  AnnaHttpResponse? response;
  AnnaHttpError? error;

  AnnaHttpCall(this.id) {
    loading = true;
    createdTime = DateTime.now();
  }

  void setResponse(AnnaHttpResponse response) {
    this.response = response;
    loading = false;
  }

  

  String getCurlCommand() {
    var compressed = false;
    var curlCmd = "curl";
    curlCmd += " -X $method";
    final headers = request!.headers;
    headers.forEach((key, dynamic value) {
      if ("Accept-Encoding" == key && "gzip" == value) {
        compressed = true;
      }
      curlCmd += " -H '$key: $value'";
    });

    final String requestBody = request!.body.toString();
    if (requestBody != '') {
      // try to keep to a single line and use a subshell to preserve any line breaks
      curlCmd += " --data \$'${requestBody.replaceAll("\n", "\\n")}'";
    }

    final queryParamMap = request!.queryParameters;
    int paramCount = queryParamMap.keys.length;
    var queryParams = "";
    if (paramCount > 0) {
      queryParams += "?";
      queryParamMap.forEach((key, dynamic value) {
        queryParams += '$key=$value';
        paramCount -= 1;
        if (paramCount > 0) {
          queryParams += "&";
        }
      });
    }

    // If server already has http(s) don't add it again
    if (server.contains("http://") || server.contains("https://")) {
      // ignore: join_return_with_assignment
      curlCmd +=
          "${compressed ? " --compressed " : " "}${"'$server$endpoint$queryParams'"}";
    } else {
      // ignore: join_return_with_assignment
      curlCmd +=
          "${compressed ? " --compressed " : " "}${"'${secure ? 'https://' : 'http://'}$server$endpoint$queryParams'"}";
    }

    return curlCmd;
  }

 
}
