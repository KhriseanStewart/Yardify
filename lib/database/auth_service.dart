import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> hasBiometrics() async {
    return await auth.canCheckBiometrics;
  }

  Future<bool> authenticiateWithBio() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Authenticate with Biometrics',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
