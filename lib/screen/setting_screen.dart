import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/config/provider/schedule_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({ Key? key }) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.orange,),
        ),
        title: const Text("Setting", style: TextStyle(color: Colors.orange),)
      ),
      body: SafeArea(
        child: ListTile(
          title: const Text("Daily Reminder Notification"),
          trailing: Consumer<ScheduleProvider>(
            builder: (context, scheduled, _) {
              // Provider.of<ScheduleProvider>(context, listen: false).scheduled = _isScheduled;
              return FutureBuilder(
                future: Provider.of<ScheduleProvider>(context, listen: false).getValue("isScheduled"),
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  bool isScheduled = snapshot.data ?? false;
                  Provider.of<ScheduleProvider>(context, listen: false).scheduled = isScheduled;
                  return Switch.adaptive(
                    activeColor: Colors.orange,
                    value: scheduled.isScheduled,
                    onChanged: (value) async {
                      setState(() {
                        Provider.of<ScheduleProvider>(context, listen: false).setValue("isScheduled", value);
                        scheduled.scheduledRestaurant(value);
                      });
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Notifikasi diaktifkan")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Notifikasi dimatikan")));
                      }
                    },
                  );
                }
              );
            },
          ),
        ),
      ),
    );
  }
}