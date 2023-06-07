import '/exports.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.hasData) {
          return StreamBuilder<UserModel>(
            stream: UserServices.instance.user(authSnapshot.data!.email),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasData && userSnapshot.data!.role == 'Admin') {
                return const AdminHome();
              } else if (userSnapshot.hasData && userSnapshot.data!.role == 'Driver') {
                return const DriverHome();
              } else {
                return const CustomerHome();
              }
            },
          );
        } else {
          return const CustomerHome();
        }
      },
    );
  }
}
