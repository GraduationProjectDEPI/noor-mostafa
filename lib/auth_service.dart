import 'main.dart';

class AuthService {
  Future<bool> register(String mail, String password) async {
    try {
      await cloud.auth.signUp(password: password, email: mail);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String mail, String password) async {
    try {
      await cloud.auth.signInWithPassword(password: password, email: mail);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await cloud.auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isLoggedIn() => cloud.auth.currentSession != null;
}
