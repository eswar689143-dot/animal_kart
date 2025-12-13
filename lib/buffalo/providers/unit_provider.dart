import 'package:animal_kart_demo2/buffalo/models/unit_selectin.dart';
import 'package:animal_kart_demo2/network/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final unitProvider = ChangeNotifierProvider<UnitController>(
  (ref) => UnitController(),
);

class UnitController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UnitSelection? _unit;
  UnitSelection? get unit => _unit;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  Future<UnitSelection?> createUnit({
    required Map<String, dynamic> payload,
  }) async {
    _setLoading(true);

    try {
      final response =
          await ApiServices.createUnitSelection(body: payload);

      if (response != null) {
        _unit = response;
      }

      return response;
    } catch (e) {
      debugPrint("CREATE UNIT ERROR: $e");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  
  void clearUnit() {
    _unit = null;
    notifyListeners();
  }
}
