import '/exports.dart';

class UserServices extends GetxController {
  static UserServices instance = Get.find();

  /* ====== Streams ====== */
  Stream<List<UserModel>> users() {
    return usersCollection
        .snapshots()
        .map((query) => query.docs.map((item) => UserModel.fromJson(item)).toList());
  }

  Stream<UserModel> user(id) {
    return usersCollection.doc(id).snapshots().map((query) => UserModel.fromJson(query));
  }

  Stream<List<UserModel>> drivers() {
    return usersCollection
        .where('role', isEqualTo: 'Driver')
        .where('address', isNotEqualTo: null)
        .snapshots()
        .map((query) => query.docs.map((item) => UserModel.fromJson(item)).toList());
  }

  /* ====== Sign In ====== */
  signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      succesSnackBar('Welcome Back');

      page(const Home());
    } on FirebaseAuthException catch (error) {
      errorSnackBar(error.code);
    }
  }

  /* ====== Sign Up ====== */
  signUp(UserModel user) async {
    try {
      await auth.createUserWithEmailAndPassword(email: user.email, password: user.password!);

      await usersCollection.doc(user.email).set(user.toJson());

      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return BootstrapModal(
            dismissble: true,
            title: 'Do you want to add your location?',
            content: const SizedBox(),
            actions: [
              BootstrapButton(
                onPressed: () => AddressServices.instance.updateAddress(null),
                child: const Text('Yes'),
              ),
              BootstrapButton(
                type: BootstrapButtonType.danger,
                onPressed: () {
                  succesSnackBar('Welcome to ${App.name}');

                  page(const Home());
                },
                child: const Text('No'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      errorSnackBar(error.code);
    }
  }

  /* ====== Update ====== */
  updateUser({required String email, required Map<String, dynamic> data}) async {
    try {
      await usersCollection.doc(email).update(data);

      succesSnackBar('Updated');

      page(const Home());
    } on FirebaseException catch (error) {
      errorSnackBar(error.code);
    }
  }

  /* ====== Sign Out ====== */
  signOut() async {
    try {
      await auth.signOut();

      succesSnackBar('Good Bye');

      page(const Home());
    } on FirebaseAuthException catch (error) {
      errorSnackBar(error.code);
    }
  }
}
