
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/config/api_config.dart';
import 'package:restaurant_app/config/provider/restaurant_provider.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:mockito/annotations.dart';

import 'provider_test.mocks.dart';
import 'response_assets.dart';

@GenerateMocks([RestaurantAPI])

void main() {
  RestaurantProvider? restaurantProvider;
  RestaurantAPI? restaurantApi;

  setUp(() {
    restaurantApi = MockRestaurantAPI();
    when(restaurantApi!.getListOfRestaurant()).thenAnswer(
        (_) async => RestaurantsResult.fromJson(restaurantResponse));
    restaurantProvider = RestaurantProvider(restaurantAPI: restaurantApi!);
  });
  group("Restaurant Provider Test", (){
    test("Verifikasi proses parsing json", () async {
      when(restaurantApi!.getListOfRestaurant()).thenAnswer(
          (_) async => RestaurantsResult.fromJson(restaurantResponse));
      var resTest = restaurantProvider!.result.restaurants![0];
      var jsonRes = Restaurant.fromJson(restaurantTest);
      expect(resTest.id == jsonRes.id, true);
      expect(resTest.name == jsonRes.name, true);
      expect(resTest.description == jsonRes.description, true);
      expect(resTest.pictureId == jsonRes.pictureId, true);
      expect(resTest.city == jsonRes.city, true);
      expect(resTest.rating == jsonRes.rating, true);
    });
  });
}