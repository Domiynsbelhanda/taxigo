import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:taxi/util/application.dart';
import 'package:taxi/util/translations.dart';

Widget langue(context){
  String value = 'en';
  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'en', title:Translations.of(context).text('en_langage')),
    S2Choice<String>(value: 'fr', title:Translations.of(context).text('fr_langage')),
    S2Choice<String>(value: 'ar', title:Translations.of(context).text('ar_langage'))
  ];
  return SmartSelect<String>.single(
    title: Translations.of(context).text('langage'),
    value: value,
    choiceItems: options,
    onChange: (state){
      applic.onLocaleChanged(new Locale(state.value,''));
    },
  );
}

void showInSnackBar(String value, _scaffoldKey, context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }