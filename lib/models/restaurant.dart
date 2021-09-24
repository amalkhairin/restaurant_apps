class RestaurantsResult {

  RestaurantsResult({
    this.restaurants,
  });

  List<Restaurant>? restaurants;

  factory RestaurantsResult.fromJson(Map<String, dynamic> json) => RestaurantsResult(
    restaurants: List<Restaurant>.from((json['restaurants'] as List)
      .map((x) => Restaurant.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "restaurant": List<dynamic>.from(restaurants!.map((e) => e.toJson()))
  };
}

class Restaurant {
  late String id;
  late String name;
  late String description;
  late String pictureId;
  late String city;
  late String? address;
  late List<Category>? categories;
  late double rating;
  late List<Review>? customerReviews;
  late List<Menu>? foods;
  late List<Menu>? drinks;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    this.address,
    this.categories,
    required this.rating,
    this.customerReviews,
    this.foods,
    this.drinks,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    pictureId: json['pictureId'],
    city: json['city'],
    address: json['address'],
    rating: double.parse(json['rating'].toString()),
    customerReviews: json['customerReviews'] == null? [] : List<Review>.from((json['customerReviews'] as List)
      .map((x) => Review.fromJson(x))),
    foods: json['menus'] == null? [] : List<Menu>.from((json['menus']['foods'] as List)
      .map((x) => Menu(name: x['name']))),
    drinks: json['menus'] == null? [] : List<Menu>.from((json['menus']['drinks'] as List)
      .map((x) => Menu(name: x['name']))),
    categories: json['categories'] == null? [] : List<Category>.from((json['categories'] as List)
      .map((x) => Category(name: x['name']))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "address": address,
    "rating": rating,
    "customerReviews": customerReviews!.isEmpty? [] : List<dynamic>.from(customerReviews!.map((e) => e.toJson())),
    "menus": {
      "foods": foods!.isEmpty? [] : List<dynamic>.from(foods!.map((e) => e.name)),
      "drinks": drinks!.isEmpty? [] : List<dynamic>.from(drinks!.map((e) => e.name)),
    },
    "categories": categories!.isEmpty? [] : List<dynamic>.from(categories!.map((e) => e.name)),
  };
}

class Category {
  String? name;
  Category({this.name});
}

class Menu {
  String? name;
  Menu({this.name});
}

class Review {
  Review({
    this.name,
    this.review,
    this.date
  });

  String? name;
  String? review;
  String? date;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    name: json['name'],
    review: json['review'],
    date: json['date'],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "review": review,
    "date": date,
  };
}

