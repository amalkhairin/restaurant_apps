import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/config/provider/restaurant_favorite_provider.dart';
import 'package:restaurant_app/constant/enum.dart';
import 'package:restaurant_app/constant/routes_name.dart';

import 'components/container/ra_restaurant_container.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.orange,),
        ),
        title: const Text("Favorite", style: TextStyle(color: Colors.orange),)
      ),
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Consumer<RestaurantFavoritesProvider>(
            builder: (context, state, _) {
              if (state.state == ResultState.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.state == ResultState.hasData) {
                return ListView.builder(
                  itemCount: state.result.length,
                  itemBuilder: (context, index){
                    var restaurant = state.result[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                      child: RARestaurantContainer(
                        name: restaurant.name,
                        address: restaurant.city,
                        rating: "${restaurant.rating}",
                        image: restaurant.pictureId,
                        onTap: (){
                          Navigator.of(context).pushNamed(detailScreenRoute, arguments: restaurant);
                        },
                      )
                    );
                  },
                );
              } else if (state.state == ResultState.noData) {
                return Center(child: Text(state.message, textAlign: TextAlign.center,));
              } else if (state.state == ResultState.error) {
                return Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ERR: ${state.message}", textAlign: TextAlign.center,),
                    ElevatedButton(
                      onPressed: (){
                        Provider.of<RestaurantFavoritesProvider>(context, listen: false).fetchAllFavoriteRestaurant();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                      ),
                      child: const Text("Retry"),
                    ),
                  ],
                ));
              } else {
                return const Center(child: Text(""),);
              }
            }
          ),
        ),
      ),
    );
  }
}