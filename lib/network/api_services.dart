import 'dart:convert';
import 'dart:io';

import 'package:animal_kart_demo2/auth/models/device_details.dart';
import 'package:animal_kart_demo2/auth/models/user_model.dart';
import 'package:animal_kart_demo2/auth/models/whatsapp_otp_response.dart';
import 'package:animal_kart_demo2/buffalo/models/buffalo.dart';
import 'package:animal_kart_demo2/buffalo/models/unit_selectin.dart';
import 'package:animal_kart_demo2/orders/models/order_model.dart';
import 'package:animal_kart_demo2/utils/app_constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/rendering.dart';
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
    final url = '${AppConstants.apiUrl}/products/$id';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final jsonBody = json.decode(res.body);
      final product = jsonBody["product"];
      return Buffalo.fromJson(product);
    } else {
      throw Exception("Failed to load buffalo details");
    }
  }

  static Future<List<Buffalo>> fetchBuffaloList() async {
    final url = '${AppConstants.apiUrl}/products';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final jsonBody = json.decode(res.body);
      final List products = jsonBody["products"];

      return products.map((e) => Buffalo.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load buffalo list");
    }
  }


  static Future<WhatsappOtpResponse?> sendWhatsappOtp(String phone) async {
  try {
    final response = await http.post(
      Uri.parse(
        "${AppConstants.apiUrl}/otp/send-whatsapp",
      ),
      headers: {
        HttpHeaders.contentTypeHeader: AppConstants.applicationJson,
      },
      body: jsonEncode({"mobile": phone,  "appName":"animalkart"}),
);

    final data = jsonDecode(response.body);
    return WhatsappOtpResponse.fromJson(data);
  } catch (e) {
    return null;
  }
}

static Future<UserModel?> updateUserProfile({
  required String mobile,
  required Map<String, dynamic> body,
}) async {
  try {
    final url =
        "${AppConstants.apiUrl}/users/$mobile";

    final response = await http.put(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: AppConstants.applicationJson,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["status"] == "success" && data["user"] != null) {
        return UserModel.fromJson(data["user"]);
      }
    }
    return null;
  } catch (e) {
    return null;
  }
}

static Future<UnitSelection?> createUnitSelection({
  required Map<String, dynamic> body,
}) async {
  try {
    final url = "${AppConstants.apiUrl}/purchases/units/buy";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: AppConstants.applicationJson,
      },
      body: jsonEncode(body),
    );

    debugPrint("STATUS CODE: ${response.statusCode}");
    debugPrint("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["status"] == "success" && data["unit"] != null) {
        return UnitSelection.fromJson(data["unit"]);
      }
    }
    return null;
  } catch (e, stack) {
    debugPrint("CREATE UNIT API ERROR: $e");
    debugPrint(stack.toString());
    return null;
  }
}

static Future<List<OrderUnit>> fetchOrders(String userId) async {
  try {
    final url = "${AppConstants.apiUrl}/purchases/units/$userId";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: AppConstants.applicationJson,
      },
    );

    debugPrint("ORDERS STATUS: ${response.statusCode}");
    debugPrint("ORDERS BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["status"] == "success" && data["units"] != null) {
        return (data["units"] as List)
            .map((e) => OrderUnit.fromJson(e))
            .toList();
      }
    }
    return [];
  } catch (e) {
    debugPrint("FETCH ORDERS ERROR: $e");
    return [];
  }
}




  

  



}