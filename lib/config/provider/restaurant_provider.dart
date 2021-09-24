import 'package:flutter/material.dart';
import 'package:restaurant_app/config/api_config.dart';
import 'package:restaurant_app/constant/enum.dart';
import 'package:restaurant_app/models/restaurant.dart';

class RestaurantProvider extends ChangeNotifier {

  RestaurantAPI? restaurantAPI;
  
  RestaurantProvider({required this.restaurantAPI}){
    fetchAllRestaurant();
  }

  RestaurantsResult? _restaurantsResult;
  String _message = "";
  ResultState? _state;

  String get message => _message;
  RestaurantsResult get result => _restaurantsResult!;
  ResultState get state => _state!;

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await restaurantAPI!.getListOfRestaurant();
      if (restaurant.restaurants!.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantsResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = e.toString().substring(10);
    }
  }
}