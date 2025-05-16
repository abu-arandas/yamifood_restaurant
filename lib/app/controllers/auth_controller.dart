import '../../exports.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rxn<User> _firebaseUser = Rxn<User>();
  final Rxn<UserModel> _userModel = Rxn<UserModel>();

  User? get firebaseUser => _firebaseUser.value;
  UserModel? get user => _userModel.value;
  bool get isLoggedIn => _firebaseUser.value != null;

  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _bindFirebaseUser();
  }

  void _bindFirebaseUser() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _setUserModel);
  }

  void _setUserModel(User? user) async {
    if (user != null) {
      isLoading.value = true;
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          _userModel.value = UserModel.fromJson({
            'id': user.uid,
            ...doc.data()!,
          });
        } else {
          // Create new user in Firestore if doesn't exist
          final newUser = UserModel(
            id: user.uid,
            name: user.displayName ?? 'User',
            email: user.email!,
            photoUrl: user.photoURL,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
          _userModel.value = newUser;
        }
      } catch (e) {
        error.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    } else {
      _userModel.value = null;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    isLoading.value = true;
    error.value = '';
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerWithEmailAndPassword(String name, String email, String password) async {
    isLoading.value = true;
    error.value = '';
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName(name);

      final newUser = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toJson());
      _userModel.value = newUser;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? photoUrl,
    String? phoneNumber,
    String? address,
  }) async {
    if (_userModel.value == null) return;

    isLoading.value = true;
    error.value = '';
    try {
      final updatedUser = _userModel.value!.copyWith(
        name: name,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        address: address,
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(updatedUser.id).update(updatedUser.toJson());
      _userModel.value = updatedUser;

      if (name != null) {
        await _auth.currentUser?.updateDisplayName(name);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    error.value = '';
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
