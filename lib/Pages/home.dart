
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/Paint/CustomPaintHome.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:smart_parking/Widget/recents.dart';
import 'dart:io';
import '../helper/Firebase Listener.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initForegroundTaskAndStartService();

  }


  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }


    // Android 12 or higher, there are restrictions on starting a foreground service.
    //
    // To restart the service on device reboot or unexpected problem, you need to allow below permission.
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
    final NotificationPermission notificationPermissionStatus =
    await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void initForegroundTaskAndStartService() async {
    await _requestPermissionForAndroid();

    // Ensure FlutterForegroundTask is initialized before starting the service
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 500,
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
        buttons: [
          const NotificationButton(
            id: 'sendButton',
            text: 'Send',
            textColor: Colors.orange,
          ),
          const NotificationButton(
            id: 'testButton',
            text: 'Test',
            textColor: Colors.grey,
          ),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
    if (kDebugMode) {
      print("Starting Foreground Service");
    }
    FlutterForegroundTask.startService(
      notificationTitle: 'Smart Park Payment Listener',
      notificationText: 'Monitoring parking sessions for payments',
      callback: startForegroundTaskCallback,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          TopBar_home(),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.menu,
                      color: Colors.white.withOpacity(0.9),
                      size: 26,
                    ),
                  ),
                  title: const Center(
                    child: Text(
                      'Smart Park',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quickstand'
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white.withOpacity(0.9),
                        size: 24,
                      ),
                    )
                  ],
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28,top: 40,right: 28,bottom: 10),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      title: TextField(
                        enabled: false,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Where do you go?',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                            letterSpacing: 0.2
                          )
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: (){

                        },
                        child: Icon(
                            Icons.search,
                          size: 27,
                          color: Colors.orange[400],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Recents(),
            ],
          )
        ],
      ),
    );
  }
}
