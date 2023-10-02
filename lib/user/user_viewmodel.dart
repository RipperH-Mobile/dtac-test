import 'dart:convert';
import 'dart:developer';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import '../feed_data.dart';
import 'user_response.dart';

class UserViewModel {

  UserViewModel();

  Rxn<FeedData<UserDetail>> userData = Rxn<FeedData<UserDetail>>();

  Future<UserDetail> fetchUSER() async {
    final response = await http
        .get(Uri.parse('https://randomuser.me/api?results=10 '));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log("message ${response.body}");
      log("message ${jsonDecode(response.body)}");

      return UserDetail.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
