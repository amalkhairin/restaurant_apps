import 'package:flutter/material.dart';
import 'package:restaurant_app/config/api_config.dart';
import 'package:restaurant_app/constant/enum.dart';
import 'package:restaurant_app/models/restaurant.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final String id;
  RestaurantDetailProvider({required this.id}){
    fetchDetailOfRestaurant(id);
  }

  Restaurant? _restaurant;
  String _message = "";
  ResultState? _state;

  String get message => _message;
  Restaurant get result => _restaurant!;
  ResultState get state => _state!;

  Future<dynamic> fetchDetailOfRestaurant(String idRestaurant) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await RestaurantAPI().getDetailOfRestaurant(idRestaurant);
      _state = ResultState.hasData;
      notifyListeners();
      return _restaurant = restaurant;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = e.toString().substring(10);
    }
  }
}