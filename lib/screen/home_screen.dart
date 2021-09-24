import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/config/provider/restaurant_provider.dart';
import 'package:restaurant_app/constant/enum.dart';
import 'package:restaurant_app/constant/routes_name.dart';

import 'components/container/ra_restaurant_container.dart';
import 'components/text_input/ra_text_form_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Restaurant App", style: TextStyle(fontSize: 28, color: Colors.black),),
                Text("Recommendation restaurant for you!", style: TextStyle(fontSize: 14, color: Colors.grey[600]),),
              ],
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(favoriteScreenRoute);
            },
            icon: const Icon(Icons.favorite, size: 24, color: Colors.orange,),
          ),
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(settingScreenRoute);
            },
            icon: const Icon(Icons.settings, size: 24, color: Colors.orange,),
          )
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(92),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
            child: RATextFormField(
              hintText: "Mau makan dimana hari ini?",
              readOnly: true,
              prefixIcon: const Icon(Icons.search, color: Colors.grey,),
              onTap: (){
                Navigator.of(context).pushNamed(searchScreenRoute);
              },
            )
          ),
        ),
      ),

      body: SafeArea(
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Consumer<RestaurantProvider>(
            builder: (context, state, _) {
              if (state.state == ResultState.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.state == ResultState.hasData ) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.result.restaurants!.length,
                          itemBuilder: (context, index){
                            var restaurant = state.result.restaurants![index];
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
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state.state == ResultState.noData) {
                return Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ERR: ${state.message}", textAlign: TextAlign.center,),
                    ElevatedButton(
                      onPressed: (){
                        Provider.of<RestaurantProvider>(context, listen: false).fetchAllRestaurant();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                      ),
                      child: const Text("Retry"),
                    ),
                  ],
                ));
              } else if (state.state == ResultState.error) {
                return Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ERR: ${state.message}", textAlign: TextAlign.center,),
                    ElevatedButton(
                      onPressed: (){
                        Provider.of<RestaurantProvider>(context, listen: false).fetchAllRestaurant();
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