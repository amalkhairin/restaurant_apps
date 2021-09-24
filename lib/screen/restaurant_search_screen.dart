import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/config/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/constant/enum.dart';
import 'package:restaurant_app/constant/routes_name.dart';

import 'components/container/ra_restaurant_container.dart';
import 'components/text_input/ra_text_form_field.dart';

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({ Key? key}) : super(key: key);

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantSearchProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Search", style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
            child: RATextFormField(
              textInputAction: TextInputAction.search,
              controller: _searchController,
              hintText: "Mau makan dimana hari ini?",
              prefixIcon: const Icon(Icons.search, color: Colors.grey,),
              autofocus: true,
              onEditingComplete: (){
                provider.findRestaurant(querySearch: _searchController.text);
                setState(() {});
              },
            ),
          ),
        )
      ),

      body: SafeArea(
        child: _searchController.text.isNotEmpty
        ? Consumer<RestaurantSearchProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (state.state == ResultState.hasData) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
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
                      ),
                    );
                  },
                ),
              );
            } else if (state.state == ResultState.noData) {
              return Center(child: Text(state.message));
            } else if (state.state == ResultState.error) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text(""),);
            }
          }
        )
        : Container()
      ),
    );
  }
}