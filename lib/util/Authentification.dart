import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi/UI/langage_choice.dart';
import 'package:taxi/util/translations.dart';


abstract class AuthImplementation{
  Future<String> SignIn(String email, String password, context, _scaffoldKey);
  Future<String> SignUp(String email, String password, String telephone, String name, String type, context, _scaffoldKey);
  Future<String> getCurrentUser();
  Future<String> resetmail(String email, context, _scaffoldKey);
  Future<void> singOut();
}

class Auth implements AuthImplementation{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> SignIn(String email, String password, context, _scaffoldKey) async{
    try{
      FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
      showInSnackBar(Translations.of(context).text('login_done'), _scaffoldKey, context);
      return user.uid;
    } on PlatformException catch (exception) {
      if(exception.code =="ERROR_WRONG_PASSWORD"){
        showInSnackBar(Translations.of(context).text('wrong_password'), _scaffoldKey, context);
      }
      else if(exception.code =="ERROR_USER_NOT_FOUND"){
        showInSnackBar(Translations.of(context).text('no_account'), _scaffoldKey, context);
      }
      else if (exception.code =="ERROR_USER_DISABLED"){
        showInSnackBar(Translations.of(context).text('account_disable'), _scaffoldKey, context);
      } else if (exception.code =="ERROR_INVALID_EMAIL"){
        showInSnackBar(Translations.of(context).text('mail_invalid'), _scaffoldKey, context);
      } else if (exception.code =="ERROR_TOO_MANY_REQUESTS"){
        showInSnackBar(Translations.of(context).text('many_requests'), _scaffoldKey, context);
      }
      else {
        showInSnackBar(exception.code, _scaffoldKey, context);
      }
    } 
  }

  Future<String> SignUp(String email, String password, String telephone, String name, String type, context, _scaffoldKey) async{
    try{

      FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;

      var data={
        "key": user.uid.toString(),
        "email": email,
        "password": password,
        "telephone": telephone,
        "name": name,
        "type": type};

        final Firestore _firestore = Firestore.instance;
        await
        _firestore.collection('Users').document(user.uid.toString()).setData(data);
        showInSnackBar(Translations.of(context).text('inscription_done'), _scaffoldKey, context);

         return user.uid;
        
      } on PlatformException catch (exception) {
        if (exception.code == "ERROR_EMAIL_ALREADY_IN_USE") {
          showInSnackBar(Translations.of(context).text('mail_use'), _scaffoldKey, context);
        } else {
          showInSnackBar(exception.message, _scaffoldKey, context);
        }
    }

  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> singOut() async{
    _firebaseAuth.signOut();
  }

  Future<String> resetmail(String email, context, _scaffoldKey) async{

    try{

      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showInSnackBar(Translations.of(context).text('reset_send'), _scaffoldKey, context);

     
      } on PlatformException catch (exception) {
        if (exception.code == "ERROR_INVALID_EMAIL") {
          showInSnackBar(Translations.of(context).text('mail_invalid'), _scaffoldKey, context);
        } else {
          showInSnackBar(exception.message, _scaffoldKey, context);
        }
    }
 }

}