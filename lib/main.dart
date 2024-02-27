import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/data_notifier.dart';
import 'package:pokemon_sleep_guide/model/tab_notifier.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:pokemon_sleep_guide/ui/home.dart';
import 'package:pokemon_sleep_guide/utils/preference_utils.dart';
import 'package:provider/provider.dart';

void main() async {
  // Required for async calls in `main`
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPrefs instance.
  await PreferenceUtils.init();

  runApp(const MyApp());
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Builder(builder: (context) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 20),
          elevation: 10,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: webAppWidth,
            child: app,
          ),
        ),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Sleep Guide',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: _buildRunnableApp(
        isWeb: kIsWeb &&
            defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS,
        webAppWidth: 480.0,
        app: MultiProvider(
          providers: [
            ChangeNotifierProvider<UserSetting>(
                create: (context) => UserSetting()),
            ChangeNotifierProvider<TabNotifier>(
                create: (context) => TabNotifier()),
            ChangeNotifierProvider<DataNotifier>(create: (context) {
              final dataNotifier = DataNotifier();
              dataNotifier.init(context);
              return dataNotifier;
            }),
          ],
          child: const Home(),
        ),
      ),
    );
  }
}
