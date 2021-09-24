import 'package:flutter/material.dart';
import 'package:restaurant_app/config/db/db_config.dart';
import 'package:restaurant_app/constant/enum.dart';
import 'package:restaurant_app/models/restaurant.dart';

class RestaurantFavoritesProvider extends ChangeNotifier {
  final DBConfig db;

  RestaurantFavoritesProvider({required this.db}){
    fetchAllFavoriteRestaurant();
  }

  late List<Restaurant> _restaurantsResult;
  String _message = "";
  late ResultState _state;

  String get message => _message;
  List<Restaurant> get result => _restaurantsResult;
  ResultState get state => _state;

  fetchAllFavoriteRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      List<Restaurant> restaurants = await db.getFavoritesRestaurant();
      if (restaurants.isNotEmpty) {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantsResult = restaurants;
      } else {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = "$e";
    }
  }

  Future<bool> isFavoriteRestaurant(String id) async {
    try {
      var restaurant = await db.getFavoriteRestaurantById(id);
      return restaurant.id == id;
    } catch (e) {
      _message = "$e";
      return false;
    }
  }

  addFavoriteRestaurant(Restaurant restaurant) async {
    try {
      await db.insert(restaurant);
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = "$e";
    }
  }

  removeFavoriteRestaurant(String id) async {
    try {
      await db.remove(id);
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = "$e";
    }
  }
}