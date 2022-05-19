import 'package:cardinal/models/agent_model.dart';
import 'package:cardinal/models/user_model.dart';
import 'package:cardinal/screens/auth_screen/auth_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool isOnline = false;
  UserModel? _user;
  UserModel? get user => _user;
  AgentModel? _agent;
  AgentModel? get agent => _agent;

  Future<AuthResultStatus> signIn(String email, String password) async {
    AuthResultStatus _status;

    UserCredential signUpUser;
    try {
      signUpUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (signUpUser.user != null) {
        _status = AuthResultStatus.successful;

        await getUser(signUpUser.user!.uid);
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    notifyListeners();
    return _status;
  }

  Future<AuthResultStatus> signUp(UserModel user) async {
    UserCredential signUpUser;
    AuthResultStatus _status;

    try {
      signUpUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!);
      if (signUpUser.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
      return _status;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(signUpUser.user?.uid)
        .set({
      'email': user.email,
      'uid': signUpUser.user?.uid,
      'name': user.fullName,
      'phone': user.phoneNumber,
      'password': user.password,
      'wishlist': [],
      'profilePic':
          'https://www.theupcoming.co.uk/wp-content/themes/topnews/images/tucuser-avatar-new.png',
      'isAdmin': false,
      'isAgent': false,
      'lastSeen': Timestamp.now(),
      'isOnline': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await getUser(signUpUser.user!.uid);

    notifyListeners();
    return _status;
  }

  Future<void> getUser(String userId) async {
    try {
      final userResults = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      _user = UserModel(
        email: userResults['email'],
        fullName: userResults['name'],
        phoneNumber: userResults['phone'],
        password: userResults['password'],
        profilePic: userResults['profilePic'],
        userId: userId,
        isOnline: userResults['isOnline'],
        lastSeen: userResults['lastSeen'],
        createdAt: userResults['createdAt'],
        isAgent: userResults['isAgent'],
        wishList: userResults['wishlist'],
      );

      _user!.isAgent! ? getAgent() : null;
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> getAgent() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      final agentResults =
          await FirebaseFirestore.instance.collection('agents').doc(uid).get();

      _agent = AgentModel.fromJson(agentResults);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> getOnlineStatus() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final databaseRef = FirebaseDatabase.instance.ref('users/$uid');
    if (isOnline) {
      databaseRef.update({
        'isOnline': true,
        'lastSeen': DateTime.now().microsecondsSinceEpoch,
      });
      isOnline = true;
    }

    databaseRef.onDisconnect().update({
      'isOnline': false,
      'lastSeen': DateTime.now().microsecondsSinceEpoch,
    }).then((_) => {
          isOnline = false,
        });

    notifyListeners();
  }

  Future<void> updateProfile(UserModel update) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': update.fullName,
      'email': update.email,
      'phone': update.phoneNumber,
      'updatedAt': Timestamp.now(),
    });
    notifyListeners();
  }
}
