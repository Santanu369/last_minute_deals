import 'package:lmd_app/core/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:lmd_app/features/auth/data/services/auth_service.dart';
import 'package:lmd_app/core/storage/secure_storage_service.dart';
import 'package:lmd_app/core/storage/user_cache_service.dart';
import 'package:lmd_app/features/auth/data/models/user_model.dart';

import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_status.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  final AuthService _authService = AuthService();
  final SecureStorageService _storageService = SecureStorageService();
  final UserCacheService _userCacheService = UserCacheService();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  

  String _cleanError(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }

  Future<void> login({required String email, required String password}) async {
    try {
      emit(
        state.copyWith(
          status: AuthStatus.loading,
          message: null,
          errorCode: null,
        ),
      );

      final response = await _authService.login(
        email: email,
        password: password,
      );

      await _storageService.saveAccessToken(response.token);
      await _userCacheService.saveUser(response.user);

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          message: null,
          errorCode: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: _cleanError(e),
          errorCode: null,
        ),
      );
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      emit(
        state.copyWith(
          status: AuthStatus.loading,
          message: null,
          errorCode: null,
        ),
      );

      final response = await _authService.signup(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      emit(
        state.copyWith(
          status: AuthStatus.success,
          user: response.user,
          message: response.message,
          errorCode: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: _cleanError(e),
          errorCode: null,
        ),
      );
    }
  }

Future<void> googleLogin() async {
  try {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        message: null,
        errorCode: null,
      ),
    );

    // debugPrint('========== GOOGLE LOGIN START ==========');

    // Google Login is mobile only.
    if (kIsWeb) {
      throw Exception('Google Login is available only on Android/iOS.');
    }

    // --------------------------------------------------
    // STEP 1: Initialize Google Sign-In
    // --------------------------------------------------
    // debugPrint('1. Initializing Google Sign-In...');

await _googleSignIn.initialize(
  serverClientId:
      '32137384287-m8o6v4rsnkmh2m6t48p0lg73pa6skeir.apps.googleusercontent.com',
);

    // debugPrint('2. Google Sign-In initialized');

    // --------------------------------------------------
    // STEP 2: Open Google account selector
    // --------------------------------------------------
    // debugPrint('3. Opening Google account selector...');

    final googleUser = await _googleSignIn.authenticate();

    // debugPrint('4. Google account selected');
    // debugPrint('Google ID: ${googleUser.id}');
    // debugPrint('Google Email: ${googleUser.email}');
    // debugPrint('Google Name: ${googleUser.displayName}');
    // debugPrint('Google Photo: ${googleUser.photoUrl}');

    // --------------------------------------------------
    // STEP 3: Get ID token
    // --------------------------------------------------
    final authentication = googleUser.authentication;

    final idToken = authentication.idToken;

    debugPrint(
      '5. ID Token exists: ${idToken != null && idToken.isNotEmpty}',
    );

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Unable to obtain Google ID token.');
    }

    // --------------------------------------------------
    // STEP 4: Call your Node.js backend
    // --------------------------------------------------
    debugPrint('6. Calling backend Google API...');

  final response = await _authService.googleLogin(
  email: googleUser.email,
  name: googleUser.displayName ?? '',
  picture: googleUser.photoUrl,
  sub: googleUser.id,
  idToken: idToken,
  fcmToken: null,
  deviceType: defaultTargetPlatform == TargetPlatform.android
      ? 'android'
      : 'ios',
  deviceId: null,
);

    debugPrint('7. Backend Google login successful');

    if (response.token.isEmpty) {
      throw Exception('Backend did not return an access token.');
    }

    // --------------------------------------------------
    // STEP 5: Save token
    // --------------------------------------------------
    await _storageService.saveAccessToken(response.token);


    // --------------------------------------------------
    // STEP 6: Save user
    // --------------------------------------------------
    await _userCacheService.saveUser(response.user);

    debugPrint('9. User saved');

    // --------------------------------------------------
    // STEP 7: Update AuthCubit state
    // --------------------------------------------------
    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: response.user,
        message: null,
        errorCode: null,
      ),
    );

    debugPrint('10. AuthStatus.authenticated emitted');
    debugPrint('========== GOOGLE LOGIN SUCCESS ==========');
  } on GoogleSignInException catch (e, stackTrace) {
    debugPrint('========== GOOGLE SIGN-IN FAILED ==========');
    debugPrint('Code: ${e.code}');
    debugPrint('Description: ${e.description}');
    debugPrint('Details: ${e.details}');
    debugPrint('StackTrace: $stackTrace');
    debugPrint('==========================================');

    if (e.code == GoogleSignInExceptionCode.canceled) {
      // User intentionally closed account selector.
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          message: null,
          errorCode: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.error,
        message: e.description ?? 'Google sign-in failed.',
        errorCode: e.code.name,
      ),
    );
  } catch (e, stackTrace) {
    // debugPrint('========== GOOGLE LOGIN FAILED ==========');
    // debugPrint('Error: $e');
    // debugPrint('StackTrace: $stackTrace');
    // debugPrint('=========================================');

    emit(
      state.copyWith(
        status: AuthStatus.error,
        message: _cleanError(e),
        errorCode: null,
      ),
    );
  }
}

  Future<void> restoreSession() async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        message: null,
        errorCode: null,
      ),
    );

    try {
      final token = await _storageService.getAccessToken();

      // No token -> logged out
      if (token == null) {
        await logout();
        return;
      }

      // Token expired -> logged out
      if (JwtDecoder.isExpired(token)) {
        debugPrint('JWT expired');
        await logout();
        return;
      }

      final expirationDate = JwtDecoder.getExpirationDate(token);

      debugPrint(
        'Remaining: ${expirationDate.difference(DateTime.now()).inDays} days',
      );

      // Load cached user
      final user = await _userCacheService.getUser();

      if (user == null) {
        debugPrint('No cached user');
        await logout();
        return;
      }

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          message: null,
          errorCode: null,
        ),
      );
    } catch (e) {
      await logout();
    }
  }

  // Future<void> restoreSession() async {
  //   emit(
  //     state.copyWith(
  //       status: AuthStatus.loading,
  //       message: null,
  //       errorCode: null,
  //     ),
  //   );

  //   try {
  //     final token = await _storageService.getAccessToken();

  //     if (token == null) {
  //       await logout();
  //       return;
  //     }

  //     final user = await _authService.getMe(accessToken: token);

  //     if (user == null) {
  //       await logout();
  //       return;
  //     }

  //     await _userCacheService.saveUser(user);

  //     emit(
  //       state.copyWith(
  //         status: AuthStatus.authenticated,
  //         user: user,
  //         message: null,
  //         errorCode: null,
  //       ),
  //     );
  //   } catch (e) {
  //     debugPrint("Restore Session Error: $e");
  //     await logout();
  //   }
  // }

  Future<void> loadProfile() async {
    try {
      final token = await _storageService.getAccessToken();

      if (token == null) return;

      final user = await _authService.getMe(accessToken: token);

      if (user == null) return;

      await _userCacheService.saveUser(user);

      emit(state.copyWith(user: user));
    } catch (e) {
      debugPrint('Load Profile Error: $e');
    }
  }

  Future<void> verifyRegisterOtp({
    required String userId,
    required String otp,
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, message: null, errorCode: null));

      await _authService.verifyOtp(userId: userId, otp: otp);

      // Automatically log in the user after activating their account
      final response = await _authService.login(
        email: email,
        password: password,
      );

      await _storageService.saveAccessToken(response.token);
      await _userCacheService.saveUser(response.user);

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          message: 'Account activated and logged in successfully!',
          errorCode: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: _cleanError(e),
          errorCode: null,
        ),
      );
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      emit(
        state.copyWith(
          status: AuthStatus.loading,
          message: null,
          errorCode: null,
        ),
      );

      await _authService.forgotPassword(email: email);

      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          message: null,
          errorCode: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: _cleanError(e),
          errorCode: null,
        ),
      );
    }
  }

  Future<bool> updateDob(String dob) async {
    try {
      final token = await _storageService.getAccessToken();
      if (token == null) return false;

      final updatedUser = await _authService.updateProfile(
        accessToken: token,
        data: {'dob': dob, 'dateOfBirth': dob},
      );

      if (updatedUser != null) {
        final currentUser = state.user;
        final mergedUser = UserModel(
          id: updatedUser.id.isNotEmpty ? updatedUser.id : (currentUser?.id ?? ''),
          firstName: updatedUser.firstName.isNotEmpty ? updatedUser.firstName : (currentUser?.firstName ?? ''),
          lastName: updatedUser.lastName.isNotEmpty ? updatedUser.lastName : (currentUser?.lastName ?? ''),
          userName: updatedUser.userName.isNotEmpty ? updatedUser.userName : (currentUser?.userName ?? ''),
          email: updatedUser.email.isNotEmpty ? updatedUser.email : (currentUser?.email ?? ''),
          profileImage: (updatedUser.profileImage != null && updatedUser.profileImage!.isNotEmpty) ? updatedUser.profileImage : currentUser?.profileImage,
          role: updatedUser.role.isNotEmpty ? updatedUser.role : (currentUser?.role ?? ''),
          provider: updatedUser.provider.isNotEmpty ? updatedUser.provider : (currentUser?.provider ?? ''),
          isEmailVerified: updatedUser.isEmailVerified,
          isPhoneVerified: updatedUser.isPhoneVerified,
          isActive: updatedUser.isActive,
          dob: (updatedUser.dob != null && updatedUser.dob!.isNotEmpty) ? updatedUser.dob : currentUser?.dob,
          location: (updatedUser.location != null && updatedUser.location!.isNotEmpty) ? updatedUser.location : currentUser?.location,
          postalCode: (updatedUser.postalCode != null && updatedUser.postalCode!.isNotEmpty) ? updatedUser.postalCode : currentUser?.postalCode,
          gender: (updatedUser.gender != null && updatedUser.gender!.isNotEmpty) ? updatedUser.gender : currentUser?.gender,
          phone: (updatedUser.phone != null && updatedUser.phone!.isNotEmpty) ? updatedUser.phone : currentUser?.phone,
        );
        await _userCacheService.saveUser(mergedUser);
        emit(state.copyWith(user: mergedUser));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Update DOB Error: $e');
      return false;
    }
  }

  Future<String?> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final token = await _storageService.getAccessToken();
      if (token == null) return 'Session expired. Please log in again.';

      final updatedUser = await _authService.updateProfile(
        accessToken: token,
        data: profileData,
      );

      if (updatedUser != null) {
        final currentUser = state.user;
        final mergedUser = UserModel(
          id: updatedUser.id.isNotEmpty ? updatedUser.id : (currentUser?.id ?? ''),
          firstName: updatedUser.firstName.isNotEmpty ? updatedUser.firstName : (currentUser?.firstName ?? ''),
          lastName: updatedUser.lastName.isNotEmpty ? updatedUser.lastName : (currentUser?.lastName ?? ''),
          userName: updatedUser.userName.isNotEmpty ? updatedUser.userName : (currentUser?.userName ?? ''),
          email: updatedUser.email.isNotEmpty ? updatedUser.email : (currentUser?.email ?? ''),
          profileImage: (updatedUser.profileImage != null && updatedUser.profileImage!.isNotEmpty) ? updatedUser.profileImage : currentUser?.profileImage,
          role: updatedUser.role.isNotEmpty ? updatedUser.role : (currentUser?.role ?? ''),
          provider: updatedUser.provider.isNotEmpty ? updatedUser.provider : (currentUser?.provider ?? ''),
          isEmailVerified: updatedUser.isEmailVerified,
          isPhoneVerified: updatedUser.isPhoneVerified,
          isActive: updatedUser.isActive,
          dob: (updatedUser.dob != null && updatedUser.dob!.isNotEmpty) ? updatedUser.dob : currentUser?.dob,
          location: (updatedUser.location != null && updatedUser.location!.isNotEmpty) ? updatedUser.location : currentUser?.location,
          postalCode: (updatedUser.postalCode != null && updatedUser.postalCode!.isNotEmpty) ? updatedUser.postalCode : currentUser?.postalCode,
          gender: (updatedUser.gender != null && updatedUser.gender!.isNotEmpty) ? updatedUser.gender : currentUser?.gender,
          phone: (updatedUser.phone != null && updatedUser.phone!.isNotEmpty) ? updatedUser.phone : currentUser?.phone,
        );
        await _userCacheService.saveUser(mergedUser);
        emit(state.copyWith(user: mergedUser));
        return null;
      }
      return 'Failed to update profile.';
    } catch (e) {
      debugPrint('Update Profile Error: $e');
      return _cleanError(e);
    }
  }

  Future<void> logout() async {
    try {
      // Optional:
      // await _authService.logout();
    } catch (_) {}

    // Before the token is cleared: the endpoint needs auth.
    await NotificationService.instance.unregister();

    await _storageService.clearAccessToken();
    await _userCacheService.clear();

    emit(const AuthState(status: AuthStatus.unauthenticated, user: null));
  }
}
