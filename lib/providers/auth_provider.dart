import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:local_auth/local_auth.dart';  // Removed to reduce APK size
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final LocalAuthentication _localAuth = LocalAuthentication();  // Removed to reduce APK size
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  User? _firebaseUser;
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isBiometricEnabled = false;
  bool _isPinEnabled = false;
  bool _isGuestMode = false;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isPinEnabled => _isPinEnabled;
  bool get isGuestMode => _isGuestMode;

  AuthProvider() {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
    _loadSecuritySettings();
  }

  // Guest mode methods
  void enableGuestMode() {
    _isGuestMode = true;
    _user = UserModel(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      email: 'guest@example.com',
      displayName: 'Guest User',
      isEmailVerified: false,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
    notifyListeners();
  }

  void disableGuestMode() {
    _isGuestMode = false;
    _user = null;
    notifyListeners();
  }

  Future<void> clearGuestData() async {
    if (!_isGuestMode) return;

    try {
      // Clear any stored guest data
      await _secureStorage.delete(key: 'guest_data');

      // Reset guest user data
      _user = UserModel(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        email: 'guest@example.com',
        displayName: 'Guest User',
        isEmailVerified: false,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear guest data: $e';
      notifyListeners();
    }
  }

  bool get canAccessApp => isAuthenticated || isGuestMode;

  Future<void> _loadSecuritySettings() async {
    _isBiometricEnabled =
        await _secureStorage.read(key: 'biometric_enabled') == 'true';
    _isPinEnabled = await _secureStorage.read(key: 'pin_enabled') == 'true';
    notifyListeners();
  }

  void _onAuthStateChanged(User? firebaseUser) async {
    _firebaseUser = firebaseUser;
    if (firebaseUser != null) {
      await _loadUserData();
    } else {
      _user = null;
    }
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    if (_firebaseUser == null) return;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_firebaseUser!.uid)
          .get();

      if (doc.exists) {
        _user = UserModel.fromMap(doc.data()!);
      } else {
        // Create new user document
        _user = UserModel(
          id: _firebaseUser!.uid,
          email: _firebaseUser!.email ?? '',
          displayName: _firebaseUser!.displayName,
          photoURL: _firebaseUser!.photoURL,
          isEmailVerified: _firebaseUser!.emailVerified,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        await _saveUserData();
      }
    } catch (e) {
      _errorMessage = 'Failed to load user data: $e';
    }
  }

  Future<void> _saveUserData() async {
    if (_user == null) return;

    try {
      await _firestore.collection('users').doc(_user!.id).set(_user!.toMap());
    } catch (e) {
      _errorMessage = 'Failed to save user data: $e';
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _updateLastLogin();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      _setLoading(true);
      _clearError();

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        await credential.user!.sendEmailVerification();

        _user = UserModel(
          id: credential.user!.uid,
          email: email,
          displayName: displayName,
          isEmailVerified: false,
          createdAt: DateTime.now(),
        );
        await _saveUserData();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        await _updateLastLogin();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Google sign-in failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithApple() async {
    try {
      _setLoading(true);
      _clearError();

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        oauthCredential,
      );
      if (userCredential.user != null) {
        await _updateLastLogin();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Apple sign-in failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      _user = null;
      _clearError();
    } catch (e) {
      _setError('Sign out failed: $e');
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e));
      return false;
    } catch (e) {
      _setError('Password reset failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> enableBiometric() async {
    // Biometric authentication disabled to reduce APK size
    _setError('Biometric authentication is not available in this build');
    return false;

    /* Commented out to reduce APK size
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        _setError('Biometric authentication is not available');
        return false;
      }

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Enable biometric authentication for KAS Finance',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        await _secureStorage.write(key: 'biometric_enabled', value: 'true');
        _isBiometricEnabled = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to enable biometric: $e');
      return false;
    }
    */
  }

  Future<bool> authenticateWithBiometric() async {
    // Biometric authentication disabled to reduce APK size
    return false;

    /* Commented out to reduce APK size
    try {
      if (!_isBiometricEnabled) return false;

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access KAS Finance',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return isAuthenticated;
    } catch (e) {
      _setError('Biometric authentication failed: $e');
      return false;
    }
    */
  }

  Future<bool> setPIN(String pin) async {
    try {
      await _secureStorage.write(key: 'user_pin', value: pin);
      await _secureStorage.write(key: 'pin_enabled', value: 'true');
      _isPinEnabled = true;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to set PIN: $e');
      return false;
    }
  }

  Future<bool> verifyPIN(String pin) async {
    try {
      final storedPin = await _secureStorage.read(key: 'user_pin');
      return storedPin == pin;
    } catch (e) {
      _setError('Failed to verify PIN: $e');
      return false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      _setLoading(true);
      if (_firebaseUser != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(_firebaseUser!.uid).delete();

        // Delete Firebase Auth account
        await _firebaseUser!.delete();

        // Clear local data
        await _secureStorage.deleteAll();

        _user = null;
        _firebaseUser = null;
      }
    } catch (e) {
      _setError('Failed to delete account: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _updateLastLogin() async {
    if (_user != null) {
      _user = _user!.copyWith(lastLoginAt: DateTime.now());
      await _saveUserData();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
