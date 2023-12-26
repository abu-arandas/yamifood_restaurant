import '/exports.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async => await Firebase.initializeApp();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: App.name,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: primary,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cardTheme: CardTheme(
            elevation: 10,
            margin: EdgeInsets.all(dPadding),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
            shadowColor: secondary,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            shape: CircleBorder(),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.hovered) || states.contains(MaterialState.dragged) || states.contains(MaterialState.pressed)
                    ? white
                    : primary,
              ),
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.hovered) || states.contains(MaterialState.dragged) || states.contains(MaterialState.pressed)
                    ? primary
                    : white,
              ),
            ),
          ),
        ),
        initialBinding: Bind(),
        home: OrientationBuilder(builder: (context, orientation) => const Home()),
      );
}

/*
flutter build web --web-renderer html
firebase deploy
*/