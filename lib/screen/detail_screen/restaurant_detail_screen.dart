import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/config/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/config/provider/restaurant_favorite_provider.dart';
import 'package:restaurant_app/constant/enum.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/screen/detail_screen/category_restaurant.dart';
import 'package:restaurant_app/screen/detail_screen/menu_restaurant.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant? restaurant;
  const RestaurantDetailScreen({Key? key, this.restaurant}) : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.orange,
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [

                    SizedBox(
                      height: 200,
                      width: screenSize.width,
                      child: Hero(
                        tag: widget.restaurant!.pictureId,
                        child: Image.network("https://restaurant-api.dicoding.dev/images/medium/"+widget.restaurant!.pictureId, fit: BoxFit.cover,)
                      )
                    ),

                    Positioned(
                      top: 0,
                      child: Container(
                        height: 98,
                        width: screenSize.width,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 64,
                        width: screenSize.width,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                
                title: Text(widget.restaurant!.name),
                titlePadding: const EdgeInsets.only(left: 42, bottom: 16),
              ),
            )
          ];
        },

        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 64,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Consumer<RestaurantDetailProvider>(
                        builder: (context, state,_) {
                          if (state.state == ResultState.loading) {
                            return const Center(child: Text("..."));
                          } else if (state.state == ResultState.hasData) {
                            return InkWell(
                              onTap: (){
                                showModalBottomSheet(
                                  constraints: BoxConstraints(maxHeight: 100, minWidth: screenSize.width),
                                  context: context, 
                                  builder: (context){
                                    return Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                          Text(state.result.address!+", "+state.result.city),
                                        ],
                                      ),
                                    );
                                  }
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.red, size: 16,),
                                      Text(widget.restaurant!.city, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const Text("Tap for Details", style: TextStyle(fontSize: 10))
                                ],
                              ),
                            );
                          } else if (state.state == ResultState.error) {
                            return Center(child: Row(
                              children: [
                                const Text("ERROR"),
                                const SizedBox(width: 8,),
                                ElevatedButton(
                                  onPressed: (){
                                    Provider.of<RestaurantDetailProvider>(context, listen: false).fetchDetailOfRestaurant(widget.restaurant!.id);
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

                      VerticalDivider(color: Colors.grey[400]),

                      Consumer<RestaurantDetailProvider>(
                        builder: (context, state,_) {
                          if (state.state == ResultState.loading) {
                            return const Center(child: Text("..."));
                          } else if (state.state == ResultState.hasData) {
                            return InkWell(
                              onTap: (){
                                showModalBottomSheet(
                                  constraints: BoxConstraints(maxHeight: screenSize.height/2, minWidth: screenSize.width),
                                  context: context, 
                                  builder: (context){
                                    return Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Reviews", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 14,),
                                          Expanded(
                                            child: ListView.builder(
                                              physics: const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: state.result.customerReviews!.length,
                                              itemBuilder: (context, index) {
                                                var review = state.result.customerReviews![index];
                                                return Padding(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  child: Container(
                                                    height: 100,
                                                    width: screenSize.width,
                                                    padding: const EdgeInsets.all(14),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(color: Colors.orange[100]!),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Icon(Icons.person),
                                                                Text(review.name!),
                                                              ],
                                                            ),
                                                            Text(review.date!)
                                                          ],
                                                        ),
                                                        Flexible(child: Text("\"${review.review!}\"")),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.red, size: 16,),
                                      Text("${widget.restaurant!.rating}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const Text("Tap for Details", style: TextStyle(fontSize: 10))
                                ],
                              ),
                            );
                          } else if (state.state == ResultState.error) {
                            return Center(child: Row(
                              children: [
                                const Text("ERROR"),
                                const SizedBox(width: 8,),
                                ElevatedButton(
                                  onPressed: (){
                                    Provider.of<RestaurantDetailProvider>(context, listen: false).fetchDetailOfRestaurant(widget.restaurant!.id);
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

                      VerticalDivider(color: Colors.grey[400]),

                      Consumer<RestaurantFavoritesProvider>(
                        builder: (context, state, _) {
                          return FutureBuilder(
                            future: state.isFavoriteRestaurant(widget.restaurant!.id),
                            builder: (context, AsyncSnapshot<bool> snapshot) {
                              bool isFavorite = snapshot.data ?? false;
                              return IconButton(
                                onPressed:(){
                                  if (mounted) {
                                    setState(() {
                                      if (isFavorite) {
                                        Provider.of<RestaurantFavoritesProvider>(context, listen: false).removeFavoriteRestaurant(widget.restaurant!.id);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Dihapus dari favorit")));
                                      } else {
                                        Provider.of<RestaurantFavoritesProvider>(context, listen: false).addFavoriteRestaurant(widget.restaurant!);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ditambahkan ke favorit")));
                                      }
                                    });
                                  }
                                },
                                icon:Icon(
                                  isFavorite? Icons.favorite : Icons.favorite_border,
                                  color: Colors.orange,
                                ),
                              );
                            }
                          );
                        }
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24,),
                const Text("Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                CategoryRestaurant(restaurantId: widget.restaurant!.id,),

                const SizedBox(height: 24,),
                const Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                const SizedBox(height: 8,),
                Text(widget.restaurant!.description),

                const SizedBox(height: 24,),
                const Text("Menus", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                const SizedBox(height: 8,),
                const Text("Foods", style: TextStyle(fontSize: 16)),
                MenuRestaurant(
                  restaurantId: widget.restaurant!.id,
                  menuType: MenuType.foods,
                ),

                const SizedBox(height: 24,),
                const Text("Drinks", style: TextStyle(fontSize: 16)),
                MenuRestaurant(
                  restaurantId: widget.restaurant!.id,
                  menuType: MenuType.drinks,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}