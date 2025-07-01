import 'dart:convert';

import 'package:avtar_demo/entity/avtar_model.dart';
import 'package:http/http.dart' as http;

class ApiRepository {
  static const String baseUrl = 'https://randomuser.me';

  Future<AvtarModel> fetchAvtar({
    int page = 1,
    int results = 20,
    String? gender,
    String? nationality,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'results': results.toString(),
      };

      if (gender != null && gender.isNotEmpty) {
        queryParams['gender'] = gender.toLowerCase();
      }

      if (nationality != null && nationality.isNotEmpty) {
        queryParams['nat'] = nationality;
      }

      final uri = Uri.parse(
        '$baseUrl/api/',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return AvtarModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load avatar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load avatar: $e');
    }
  }
}
