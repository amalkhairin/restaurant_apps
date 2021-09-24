import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/config/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/constant/enum.dart';

class MenuRestaurant extends StatelessWidget {
  final String? restaurantId;
  final MenuType? menuType;
  const MenuRestaurant({ Key? key, this.restaurantId, this.menuType }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.hasData) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menuType == MenuType.foods? state.result.foods!.length : state.result.drinks!.length,
            itemBuilder: (context, index) {
              var menu = menuType == MenuType.foods? state.result.foods![index] : state.result.drinks![index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      width: 200,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Icon(Icons.lunch_dining, size: 42, color: Colors.orange[300]),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Text(menu.name!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.orange,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10),
                        )
                      ),
                      child: const Text("Add"),
                    ),
                  ),
                ],
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
            ),
          );
        } else if (state.state == ResultState.error) {
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ERR: ${state.message}"),
              const SizedBox(height: 8,),
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