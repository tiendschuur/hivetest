import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    Timer.periodic(Duration(seconds: 60), (timer) {
      print('We are here because we are here');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Settings',
      home: Settings(),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
                ValueListenableBuilder(
                  valueListenable: Hive.box('settings').listenable(),
                  builder: (context, box, widget) {
                    return Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Send usage data'),
                              Switch(
                                value: box.get('darkMode', defaultValue: false),
                                onChanged: (val) {
                                  box.put('darkMode', val);
                                },
                              ),
                            ]
                          ),
                          Row(
                              children: [
                                // This part of the code doesn't work just yet,
                                // we need connectivity package for that
                                Text('Only update via WiFi'),
                                Switch(
                                  value: box.get('onlyWifiUpdate', defaultValue: false),
                                  onChanged: (val) {
                                    box.put('onlyWifiUpdate', val);
                                  },
                                ),
                              ]
                          ),
                          Row (
                              children: [
                                Text('Username'),
                                SizedBox(width: 100,
                                  child:
                                    TextFormField(
                                      initialValue: box.get('username', defaultValue: null),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(10),
                                          hintText: 'Enter a search term',
                                      ),
                                      onChanged: (val) {
                                        box.put('username', val);
                                      },
                                  ),
                                )
                              ]
                            )
                        ]
                      ),
                    );
                  },
                ),
              ]
            )
        )
    );
  }
}