import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:litmedia/pages/model/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  // Convert Firebase's User to Your CustomUser Model
  CustomUser? _userFromFirebase(firebase_auth.User? user) {
    return user != null
        ? CustomUser(
            uid: user.uid,
            email: user.email ?? "No email provided",
            username: user.displayName ?? "Anonymous",
            photoURL: user.photoURL,
          )
        : null;
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      // Await Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If the user cancels the sign-in, return null
      if (googleUser == null) return null;

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Step 6: Check if it's a new user
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        print("New user signed up: ${userCredential.user?.email}");
        // Add user to Firestore or perform first-time setup
      } else {
        print("Existing user logged in: ${userCredential.user?.email}");
      }

      return userCredential;
    } catch (e) {
      print("Error in loginWithGoogle: $e");
      return null; // Return null explicitly in case of an error
    }
  }

  Future<UserCredential?> SignupWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final String email = googleUser.email;
      // ignore: deprecated_member_use
      final List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(
        email,
      );

      if (signInMethods.isNotEmpty) {
        print("Error: This email ($email) is already in use. Please log in. ");
        return null;
      }

      final UserCredential userCredential = await _auth.signInWithCredential(
        cred,
      );
      print("New user signed up with Google : ${userCredential.user?.email}");
      return userCredential;
    } catch (e) {
      print("Error in Google sign-up: $e");
      return null;
    }
  }

  // Stream of Your CustomUser Model
  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(
          (firebase_auth.User? user) => _userFromFirebase(user),
        );
  }

  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //************************************************************** */

  Future<CustomUser?> signUpWithEmailAndPassword(
    String username,
    String email,
    String password,
  ) async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('users');

      final querySnapshot =
          await usersRef.where('username', isEqualTo: username).get();

      if (querySnapshot.docs.isNotEmpty) {
        print("⚠️ Error: Username is already taken.");
        return null; // You can return a specific error message instead
      }

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await usersRef.doc(result.user!.uid).set({
        'username': username, // Store the username
        'email': email,
        'uid': result.user!.uid,
      });

      firebase_auth.User? user = result.user;
      if (user != null) {
        print("✅ Signed in successfully: ${user.email}");
        return _userFromFirebase(user);
      } else {
        print("⚠️ Sign-in failed, user is null");
        return null;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("This email is already in use.");
        // You can return a specific error message instead
      } else {
        throw Exception("Registration failed: ${e.message}");
      }
    }
  }

  //Sign In
  Future<CustomUser?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebase_auth.User? user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print("Sign In Error : $e");
      return null;
    }
  }

  //Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String?> checkAndRegisterUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      // Reference to Firestore
      final usersRef = FirebaseFirestore.instance.collection('users');

      // Query for existing username
      final querySnapshot =
          await usersRef.where('username', isEqualTo: username).get();

      if (querySnapshot.docs.isNotEmpty) {
        return 'This username is already taken';
      }

      // If username is unique, register the user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store user data in Firestore
      await usersRef.doc(userCredential.user!.uid).set({
        'name': username,
        'email': email,
        'uid': userCredential.user!.uid,
      });

      return null; // Success
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<bool> isUsernameUnique(String username) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return querySnapshot.docs.isEmpty; // If true, username is unique
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Request Facebook login
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        final AccessToken? accessToken = loginResult.accessToken;

        if (accessToken != null) {
          print("📌 Facebook Access Token: ${accessToken.tokenString}");

          // Create credential
          final OAuthCredential credential = FacebookAuthProvider.credential(
            accessToken.tokenString,
          );

          // Sign in with Firebase
          return await FirebaseAuth.instance.signInWithCredential(credential);
        } else {
          print("❌ Error: AccessToken is null");
        }
      } else {
        print("❌ Facebook Login Failed: ${loginResult.message}");
      }
    } catch (e) {
      print("❌ Exception during Facebook Sign-In: $e");
    }
    return null;
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    void Function(String verificationId) onCodeSent,
    void Function(String successMessage) onVerificationCompleted,
    void Function(String errorMessage) onVerificationFailed,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-sign in on some devices
        await _auth.signInWithCredential(credential);
        onVerificationCompleted("Verification successful!");
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        // Send the verification ID to the caller
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        onVerificationFailed(
          "Auto-retrieval timed out. Please enter the code manually.",
        );
        // Auto-retrieval timeout
      },
    );
  }

  Future<void> signInWithOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception("Error signing in: ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<CustomUser?> getUserDetails(String email) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final document = snapshot.docs.first;
        return CustomUser.fromSnapshot(document);
      } else {
        print("No user found with email: $email");
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  Future<CustomUser> allUser() async {
    final snapshot = await _db.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => CustomUser.fromSnapshot(e)).single;
    return userData;
  }
}
