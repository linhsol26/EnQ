import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:EnQ/models/test_exam_history.dart';
import 'package:EnQ/utils/env.dart';

class HistoryService {
  Future<http.Response> updateUserHistory(
      String id, TestExamHistory testHistory) async {
    Map<String, dynamic> testHistoryJson = testHistory.toJson();
    List<Map<String, dynamic>> testHistoryList = [testHistoryJson];
    Map<String, String> header = {"Content-Type": "application/json"};
    var response = await http.patch(
      // Uri.https('enq-server.herokuapp.com', '/v1/users/?userId=$id'),
      Enviroment.prod + '/users/?userId=$id',
      headers: header,
      body: jsonEncode({
        "_id": id,
        "testExamHistory": testHistoryList,
      }),
    );
    // print(jsonDecode(response.body));
    print('update history ${response.statusCode}');
    return response;
  }

  Future<List<dynamic>> getRecentHistory(String uid) async {
    Map<String, String> header = {"Content-Type": "application/json"};

    http.Response response = await http.post(
      Uri.https('enq-server.herokuapp.com', '/v1/test/history'),
      headers: header,
      body: jsonEncode({'user_id': uid, 'isRecent': true}),
    );

    // print(jsonDecode(response.body));
    print('get recent history ${response.statusCode}');
    Map data = jsonDecode(response.body);
    List<dynamic> result = data['data'];
    print(result);
    return result;
  }
}