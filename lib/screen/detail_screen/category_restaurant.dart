import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/config/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/constant/enum.dart';

class CategoryRestaurant extends StatelessWidget {
  final String? restaurantId;
  const CategoryRestaurant({ Key? key, this.restaurantId }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, state,_) {
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.hasData) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.result.categories!.length,
            itemBuilder: (context, index) {
              var category = state.result.categories![index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(14),
                child: Center(child: Text(category.name!, style: const TextStyle(fontSize: 10),)),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3,
            ),
          );
        } else if (state.state == ResultState.error) {
          return Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("ERROR"),
              const SizedBox(width: 8,),
              ElevatedButton(
                onPressed: (){
                  Provider.of<RestaurantDetailProvider>(context, listen: false).fetchDetailOfRestaurant(restaurantId!);
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
    );
  }
}