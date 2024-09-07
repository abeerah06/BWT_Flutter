import 'package:carpoolbuddy/models/car_details.dart';
import 'package:carpoolbuddy/models/user.dart' as app_user;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//get curren user
  firebase_auth.User? getcurrentUser() {
    return _auth.currentUser;
  }

  // Sign up a new user
  Future<void> signUp(String name, String email, String password) async {
    try {
      firebase_auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the user's display name
      await userCredential.user!.updateDisplayName(name);

      // Store additional user info in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'profileImageUrl': '',
        'phone_number': '',
        'carDetails': null, 
      });
    } catch (e) {
      print("Error during sign up: $e");
      rethrow;
    }
  }

  // Sign in an existing user
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Error during sign in: $e");
      rethrow;
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error during sign out: $e");
      rethrow;
    }
  }

// Send a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error sending password reset email: $e");
      rethrow;
    }
  }

  // Stream of the current user's authentication state
  Stream<app_user.User?> get user {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser != null) {
        try {
          // Fetch additional user data from Firestore
          final doc =
              await _firestore.collection('users').doc(firebaseUser.uid).get();
          final data = doc.data();

          return app_user.User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? data?['name'] ?? '',
            email: firebaseUser.email ?? '',
            profileImageUrl: data?['profileImageUrl'] ?? '',
            carDetails: data?['carDetails'] != null
                ? CarDetails.fromMap(data!['carDetails'])
                : null, // Parse carDetails if it exists
          );
        } catch (e) {
          print("Error fetching user data: $e");
          return null;
        }
      } else {
        return null;
      }
    });
  }

  // Fetch the current user
  Future<app_user.User?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        // Fetch additional user data from Firestore
        final doc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();
        final data = doc.data();

        return app_user.User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? data?['name'] ?? '',
          email: firebaseUser.email ?? '',
          profileImageUrl: data?['profileImageUrl'] ?? '',
          carDetails: data?['carDetails'] != null
              ? CarDetails.fromMap(data!['carDetails'])
              : null, // Parse carDetails if it exists
        );
      } catch (e) {
        print("Error fetching current user: $e");
        return null;
      }
    }
    return null;
  }

  // Update user profile information
  Future<void> updateUserProfile({
    required String name,
    required String email,
    String? profileImageUrl,
  }) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        // Update profile details in Firebase Auth
        await firebaseUser.updateProfile(displayName: name);
        await firebaseUser.updateEmail(email);

        // Update Firestore document
        await _firestore.collection('users').doc(firebaseUser.uid).update({
          'name': name,
          'email': email,
          if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        });
      } catch (e) {
        print("Error updating user profile: $e");
        rethrow;
      }
    }
  }

  // Update user car details
  Future<void> updateCarDetails(CarDetails carDetails) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        // Update the user's car details in Firestore
        await _firestore.collection('users').doc(firebaseUser.uid).update({
          'carDetails': carDetails.toMap(), // Convert CarDetails to a map
        });
      } catch (e) {
        print("Error updating car details: $e");
        rethrow;
      }
    }
  }

  // Delete user car details
  Future<void> deleteCarDetails() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        // Set carDetails to null
        await _firestore.collection('users').doc(firebaseUser.uid).update({
          'carDetails': null,
        });
      } catch (e) {
        print("Error deleting car details: $e");
        rethrow;
      }
    }
  }
}
