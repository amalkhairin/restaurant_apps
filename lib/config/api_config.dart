import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';

import 'package:restaurant_app/models/restaurant.dart';

class RestaurantAPI {
  static String apiUrl = "restaurant-api.dicoding.dev";

  Future<RestaurantsResult> getListOfRestaurant() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      Uri url = Uri.https(apiUrl, "/list");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonRes = json.decode(response.body);
        return RestaurantsResult.fromJson(jsonRes);
      } else {
        throw Exception("Failed to load data");
      }
    } else {
      throw Exception("No Internet Connection");
    }
  }

  Future<Restaurant> getDetailOfRestaurant(String id) async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      Uri url = Uri.https(apiUrl, "/detail/$id");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonRes = json.decode(response.body);
        return Restaurant.fromJson(jsonRes['restaurant']);
      } else {
        throw Exception("Failed to load data");
      }
    } else {
      throw Exception("No Internet Connection");
    }
  }

  Future<RestaurantsResult> searchRestaurant(String query) async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      final queryParams = {
        "q": query,
      };
      Uri url = Uri.https(apiUrl, "/search", queryParams);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonRes = json.decode(response.body);
        return RestaurantsResult.fromJson(jsonRes);
      } else {
        throw Exception("Failed to load data");
      }
    } else {
      throw Exception("No Internet Connection");
    }
  }
}