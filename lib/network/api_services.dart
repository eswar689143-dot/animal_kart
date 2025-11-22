import 'dart:convert';
import 'dart:io';

import 'package:animal_kart_demo2/auth/models/device_details.dart';
import 'package:animal_kart_demo2/models/buffalo.dart';
import 'package:animal_kart_demo2/utils/app_constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<DeviceDetails> fetchDeviceDetails() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return DeviceDetails(id: info.id, model: info.model);
    }

    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return DeviceDetails(
        id: info.identifierForVendor.toString(),
        model: info.utsname.machine,
      );
    }

    return const DeviceDetails(id: '', model: '');
  }
static Future<Buffalo> fetchBuffaloById(String id) async {
    final url =
        '${AppConstants.apiUrl}/products/$id';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return Buffalo.fromJson(data);
    } else {
      throw Exception("Failed to load buffalo details");
    }
  }

static Future<List<Buffalo>> fetchBuffaloList() async {
  final url = '${AppConstants.apiUrl}/products';

  final res = await http.get(Uri.parse(url));

  if (res.statusCode == 200) {
    final data = json.decode(res.body);

    return (data as List).map((json) => Buffalo.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load buffalo list");
  }
}

}
