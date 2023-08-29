import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo/src/screen/home_screen.dart';
import 'package:todo/src/util/config.dart';
import 'package:todo/src/util/message.dart';

void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(anonKey: Config.supabasePublicKey, url: Config.supbaseUrl);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: MessagesString.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: MessagesString.appName),
    );
  }
}