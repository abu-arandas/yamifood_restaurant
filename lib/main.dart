import 'exports.dart';
import 'dart:math' as math;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const Welcome(),
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('asset/bg.jpg'),
              colorFilter: ColorFilter.mode(overlay, BlendMode.dstATop),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              logo,
              SizedBox(
                width: size.width,
                height: size.height * 0.2,
                child: GridView.builder(
                  itemCount: buttons.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    return TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => buttons[index].page)),
                      child: Transform(
                        transform: Matrix4.rotationZ(math.pi / 4),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width * 0.2,
                          height: size.width * 0.2,
                          decoration: BoxDecoration(
                            color: transparent,
                            border: Border.all(width: 1, color: primary),
                          ),
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationZ(-math.pi / 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    buttons[index].icon,
                                    color: white,
                                    size: 16,
                                  ),
                                  Text(
                                    buttons[index].text,
                                    style:
                                        TextStyle(color: white, fontSize: 16),
                                  )
                                ],
                              )),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
