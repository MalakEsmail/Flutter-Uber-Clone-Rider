import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getRequest({required String url}) async {
    http.Response response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        print("response : $decodedData");
        return decodedData;
      } else {
        print("failed");
        return "failed";
      }
    } catch (e) {
      print("failed : $e");
      return "failed";
    }
  }
}
