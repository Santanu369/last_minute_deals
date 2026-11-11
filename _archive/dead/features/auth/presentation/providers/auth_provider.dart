// import 'package:flutter/material.dart';

// import '../models/user_model.dart';
// import '../services/auth_service.dart';
// import '../services/secure_storage_service.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthProvider extends ChangeNotifier {
//   final AuthService _authService = AuthService();

//   final SecureStorageService _storageService = SecureStorageService();

//   final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
//   UserModel? _user;

//   bool _isLoading = false;

//   String? _error;

//   UserModel? get user => _user;

//   bool get isLoading => _isLoading;

//   String? get error => _error;

//   bool get isAuthenticated => _user != null;

//   Future<bool> googleLogin() async {
//     try {
//       _isLoading = true;

//       _error = null;

//       notifyListeners();

//       await _googleSignIn.initialize();

//       final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

//       final GoogleSignInAuthentication googleAuth = googleUser.authentication;

//       final String? idToken = googleAuth.idToken;

//       if (idToken == null) {
//         _error = 'Failed to get Google ID token';

//         return false;
//       }

//       final response = await _authService.googleLogin(idToken: idToken);

//       await _storageService.saveTokens(
//         accessToken: response.accessToken,
//         refreshToken: response.refreshToken,
//       );

//       _user = response.user;

//       return true;
//     } catch (e) {
//       _error = e.toString();

//       return false;
//     } finally {
//       _isLoading = false;

//       notifyListeners();
//     }
//   }

//   Future<bool> login({required String email, required String password}) async {
//     try {
//       _isLoading = true;

//       _error = null;

//       notifyListeners();

//       final response = await _authService.login(
//         email: email,
//         password: password,
//       );

//       await _storageService.saveTokens(
//         accessToken: response.accessToken,
//         refreshToken: response.refreshToken,
//       );

//       _user = response.user;

//       return true;
//     } catch (e) {
//       _error = e.toString();

//       return false;
//     } finally {
//       _isLoading = false;

//       notifyListeners();
//     }
//   }

//   Future<bool> signup({
//     required String email,
//     required String password,
//     required String firstName,
//     required String lastName,
//   }) async {
//     try {
//       _isLoading = true;

//       _error = null;

//       notifyListeners();

//       final response = await _authService.signup(
//         email: email,
//         password: password,
//         firstName: firstName,
//         lastName: lastName,
//       );

//       await _storageService.saveTokens(
//         accessToken: response.accessToken,
//         refreshToken: response.refreshToken,
//       );

//       _user = response.user;

//       return true;
//     } catch (e) {
//       _error = e.toString();

//       return false;
//     } finally {
//       _isLoading = false;

//       notifyListeners();
//     }
//   }

//   Future<void> logout() async {
//     _user = null;

//     await _storageService.clearTokens();

//     notifyListeners();
//   }

//   Future<void> restoreSession() async {
//     try {
//       _isLoading = true;

//       notifyListeners();

//       final accessToken = await _storageService.getAccessToken();

//       if (accessToken == null) {
//         return;
//       }

//       final currentUser = await _authService.getMe(accessToken: accessToken);

//       if (currentUser != null) {
//         _user = currentUser;
//       }
//     } catch (e) {
//       try {
//         final refreshToken = await _storageService.getRefreshToken();

//         if (refreshToken == null) {
//           await logout();

//           return;
//         }

//         final authResponse = await _authService.refreshToken(
//           refreshToken: refreshToken,
//         );

//         if (authResponse == null) {
//           await logout();

//           return;
//         }

//         await _storageService.saveTokens(
//           accessToken: authResponse.accessToken,
//           refreshToken: authResponse.refreshToken,
//         );

//         _user = authResponse.user;
//       } catch (e) {
//         await logout();
//       }
//     } finally {
//       _isLoading = false;

//       notifyListeners();
//     }
//   }
// }
