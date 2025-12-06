import 'dart:convert';
import 'dart:io';

import 'package:animal_kart_demo2/auth/models/addbuffalo_model.dart';
import 'package:animal_kart_demo2/auth/models/device_details.dart';
import 'package:animal_kart_demo2/auth/models/removeCart_model.dart';
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
    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////
    

//     static Future<AddToCartModel> addToCart({
//     required String userMobile,
//     required String productId,
//     required String productType,
//     required int quantity,
//   }) async {
//     final url = '${AppConstants.apiUrl}/cart/add';

//     final res = await http.post(
//       Uri.parse(url),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({
//         "user_mobile": userMobile,
//         "product_id": productId,
//         "product_type": productType,
//         "quantity": quantity,
//       }),
//     );

//     if (res.statusCode == 200 || res.statusCode == 201) {
//       final jsonBody = json.decode(res.body);
//       return AddToCartModel.fromJson(jsonBody);
//     } else {
//       final jsonBody = json.decode(res.body);
//       return AddToCartModel(
//         statusCode: res.statusCode,
//         status: "error",
//         message: jsonBody['message'] ?? "Failed to add to cart",
//         item: null,
//       );
//     }
//   }
//   ///////////////////////
//   ///////////////////////
  
//     static Future<CartResponseModel?> fetchCart(String userMobile) async {
//       final url = '${AppConstants.apiUrl}/cart/{{test_mobile}}';

//       try {
//         final res = await http.get(Uri.parse(url));

//         if (res.statusCode == 200) {
//           final jsonBody = json.decode(res.body);
//           return CartResponseModel.fromJson(jsonBody);
//         } else {
//           print('Failed to fetch cart: ${res.statusCode}');
//           return null;
//         }
//       } catch (e) {
//         print('Error fetching cart: $e');
//         return null;
//       }
//     }

}
