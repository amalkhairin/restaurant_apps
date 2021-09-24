import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/config/api_config.dart';
import 'package:restaurant_app/config/db/db_config.dart';
import 'package:restaurant_app/config/navigation.dart';
import 'package:restaurant_app/config/notification/background_services.dart';
import 'package:restaurant_app/config/notification/notification_config.dart';
import 'package:restaurant_app/config/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/config/provider/restaurant_favorite_provider.dart';
import 'package:restaurant_app/config/provider/restaurant_provider.dart';
import 'package:restaurant_app/config/provider/schedule_provider.dart';
import 'package:restaurant_app/constant/routes_name.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/screen/favorite_screen.dart';
import 'package:restaurant_app/screen/home_screen.dart';
import 'package:restaurant_app/screen/detail_screen/restaurant_detail_screen.dart';
import 'package:restaurant_app/screen/restaurant_search_screen.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/screen/setting_screen.dart';
import 'package:restaurant_app/screen/splash_screen.dart';

import 'config/provider/restaurant_search_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationConfig _notificationConfig = NotificationConfig();
  final BackgroundService _backgroundService = BackgroundService();

  _backgroundService.initializeIsolate();

  await AndroidAlarmManager.initialize();

  await _notificationConfig.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      initialRoute: splashScreenRoute,
      routes: {
        splashScreenRoute: (context) => const SplashScreen(),
        homeScreenRoute: (context) => ChangeNotifierProvider(
          create: (_) => RestaurantProvider(restaurantAPI: RestaurantAPI()),
          child: const HomeScreen()
        ),
        searchScreenRoute: (context) => ChangeNotifierProvider(
          create: (_) => RestaurantSearchProvider(restaurantAPI: RestaurantAPI()),
          child: const RestaurantSearchScreen()
        ),
        detailScreenRoute: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => RestaurantDetailProvider(
                id: (ModalRoute.of(context)?.settings.arguments as Restaurant).id
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => RestaurantFavoritesProvider(db: DBConfig())
            ),
          ],
          child: RestaurantDetailScreen(
            restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant,
          ),
        ),
        favoriteScreenRoute: (context) => ChangeNotifierProvider<RestaurantFavoritesProvider>(
          create: (_) => RestaurantFavoritesProvider(db: DBConfig()),
          child: const FavoriteScreen()
        ),
        settingScreenRoute: (context) => ChangeNotifierProvider(
          create: (_) => ScheduleProvider(),
          child: const SettingScreen(),
        ),
      },
      navigatorObservers: [HeroController()],
      navigatorKey: navigatorKey,
    );
  }
}