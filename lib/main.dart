import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:reqres_demo/ApiProvider.dart';
import 'package:reqres_demo/loginScreen.dart';
import 'package:reqres_demo/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  runApp(const MyApp());
}

Future<dynamic> getCredentials() async {
  final data = getJSONAsync("credentials");
  return data;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ApiProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: FutureBuilder(
              future: getCredentials(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data.length == 0
                      ? const LoginScreen()
                      : HomeScreen(data: snapshot.data);
                }
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }),
        ));
  }
}
