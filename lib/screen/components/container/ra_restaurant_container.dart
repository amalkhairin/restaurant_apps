import 'package:flutter/material.dart';

class RARestaurantContainer extends StatelessWidget {
  final String? name;
  final String? address;
  final String? rating;
  final String? image;
  final Function()? onTap;
  const RARestaurantContainer({
    Key? key,
    required this.name,
    required this.address,
    required this.rating,
    required this.image,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            Expanded(
              child: Hero(
                tag: image!,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage("https://restaurant-api.dicoding.dev/images/medium/"+image!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14,),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name!, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.orange,),
                          Text(address!),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.orange,),
                      Text(rating!),
                    ],
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}