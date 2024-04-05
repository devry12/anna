import 'dart:convert';

class AnnaHttpResponse {
  int? status = 0;
  int size;
  DateTime? time;
  dynamic body;
  Map<String, String>? headers;
  AnnaHttpResponse({
    this.status,
    this.size = 0,
    this.time,
    this.body,
    this.headers,
  });

 

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'size': size,
      'body': body,
      'headers': headers,
    };
  }

  factory AnnaHttpResponse.fromMap(Map<String, dynamic> map) {
    return AnnaHttpResponse(
      status: map['status']?.toInt(),
      size: map['size']?.toInt() ?? 0,
      body: map['body'],
      headers: Map<String, String>.from(map['headers']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AnnaHttpResponse.fromJson(String source) => AnnaHttpResponse.fromMap(json.decode(source));
}
