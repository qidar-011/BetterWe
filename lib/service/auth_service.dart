import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../extensions/constants.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../network/rest_api.dart';
import '../screens/verify_otp_screen.dart';
import '../utils/app_common.dart';
import '../utils/app_constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User> signInWithGoogle() async {
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user!;

    assert(!user.isAnonymous);
    //assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser!;
    assert(user.uid == currentUser.uid);

    signOutGoogle();

    String firstName = '';
    String lastName = '';

    if (currentUser.displayName.validate().split(' ').length >= 1) firstName = currentUser.displayName.splitBefore(' ');
    if (currentUser.displayName.validate().split(' ').length >= 2) lastName = currentUser.displayName.splitAfter(' ');

    await userStore.setUserImage(currentUser.photoURL.validate());

    Map req = {
      "email": currentUser.email,
      "username": currentUser.email,
      "first_name": firstName,
      "last_name": lastName,
      "login_type": LoginTypeGoogle,
      "user_type": LoginUser,
      'status': statusActive,
      'player_id': getStringAsync(PLAYER_ID).validate(),
      "accessToken": googleSignInAuthentication.accessToken,
      if (!currentUser.phoneNumber.isEmptyOrNull) "phone_number": currentUser.phoneNumber.validate(),
    };

    return await socialLogInApi(req).then((value) async {
      await userStore.setToken(value.data!.apiToken.validate());
      await userStore.setUserID(value.data!.id.validate());
      await userStore.setFirstName(value.data!.firstName.validate());
      await userStore.setLastName(value.data!.lastName.validate());
      await userStore.setGender(value.data!.gender.validate());
      await userStore.setLogin(true);

      return currentUser;
    }).catchError((e) {
      log("e->" + e);
      throw e;
    });
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
}

Future<void> loginWithOTP(BuildContext context, String phoneNumber, String mobileNo) async {
  appStore.setLoading(true);
  return await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {},
    verificationFailed: (FirebaseAuthException e) {
      appStore.setLoading(false);
      if (e.code == 'invalid-phone-number') {
        toast('The provided phone number is not valid.');
        throw 'The provided phone number is not valid.';
      } else {
        toast(e.toString());
        throw e.toString();
      }
    },
    timeout: Duration(minutes: 1),
    codeSent: (String verificationId, int? resendToken) async {
      finish(context);
      VerifyOTPScreen(
        verificationId: verificationId,
        isCodeSent: true,
        phoneNumber: phoneNumber,
        mobileNo: mobileNo,
      ).launch(context);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      //
    },
  );
}

Future<void> appleLogIn() async {
  if (await TheAppleSignIn.isAvailable()) {
    AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final authResult = await _auth.signInWithCredential(credential);
        final user = authResult.user!;

        if (result.credential!.email != null) {
          await saveAppleDataWithoutEmail(result, String.fromCharCodes(appleIdCredential.authorizationCode!));
        }
        break;
      case AuthorizationStatus.error:
        throw ("Sign in failed: ${result.error!.localizedDescription}");
      case AuthorizationStatus.cancelled:
        throw ('User cancelled');
    }
  } else {
    throw ('Apple SignIn is not available for your device');
  }
}

Future<void> saveAppleDataWithoutEmail(AuthorizationResult result, String? accessToken) async {
  var req = {
    'email': result.credential!.email.validate(),
    'firstName': result.credential!.fullName!.givenName.validate(),
    'lastName': result.credential!.fullName!.familyName.validate(),
    "username": result.credential!.email.validate(),
    "user_type": LoginUser,
    // 'photoURL': '',
    'accessToken': accessToken,
    'login_type': LoginTypeApple,
    'status': statusActive,
    'player_id': getStringAsync(PLAYER_ID).validate(),
  };

  return await socialLogInApi(req).then((value) async {
    await userStore.setToken(value.data!.apiToken.validate());
    await userStore.setUserID(value.data!.id.validate());
    await userStore.setFirstName(value.data!.firstName.validate());
    await userStore.setLastName(value.data!.lastName.validate());
    await userStore.setGender(value.data!.gender.validate());
    await userStore.setLogin(true);
  }).catchError((e) {
    log("e->" + e);
    throw e;
  });
}

Future deleteUserFirebase() async {
  if (FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.currentUser!.delete();
    await FirebaseAuth.instance.signOut();
  }
}

Future<void> logout(BuildContext context, {Function? onLogout}) async {
  await removeKey(IS_LOGIN);
  await removeKey(USER_ID);
  await removeKey(FIRSTNAME);
  await removeKey(LASTNAME);
  await removeKey(USER_PROFILE_IMG);
  await removeKey(DISPLAY_NAME);
  await removeKey(PHONE_NUMBER);
  await removeKey(GENDER);
  await removeKey(AGE);
  await removeKey(HEIGHT);
  await removeKey(HEIGHT_UNIT);
  await removeKey(IS_OTP);
  await removeKey(IS_SOCIAL);
  await removeKey(WEIGHT);
  await removeKey(WEIGHT_UNIT);
  userStore.clearUserData();
  if (getBoolAsync(IS_SOCIAL) || !getBoolAsync(IS_REMEMBER) || getBoolAsync(IS_OTP) == true) {
    await removeKey(PASSWORD);
    await removeKey(EMAIL);
  }
  userStore.setLogin(false);
  onLogout?.call();
}
