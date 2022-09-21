import 'dart:core';
import 'package:flutter/material.dart';

extension ObjectExtensions on Object {
  sleep(int seconds) {
    (() async => await Future.delayed(Duration(seconds : seconds)))();
  }
}

extension ContextExtensions on BuildContext {

  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  Size get sizeScreen => mediaQueryData.size;

  double get width => sizeScreen.width;

  double get height => sizeScreen.height-kToolbarHeight;

  double get width12 => widthFactor(12);

  double get height12 => heightFactor(12);

  double get heightToolbar => kToolbarHeight;

  double widthFactor(double factor) => width / factor;

  double heightFactor(double factor) => height / factor;

  bool get isSmallScreen => width < 800;

  bool get isMediumScreen => width >= 800 && width <= 1200;

  bool get isLargeScreen => width > 1200;

  double get screenAspectRatio => mediaQueryData.orientation == Orientation.portrait ? width/height : height/width;

  double get paddingTop => heightToolbar/2;

  double get paddingHorizontal => isSmallScreen ? width12 : isMediumScreen ? width12 * 2 : width12 * 3;

  double get devicePixelRatio => mediaQueryData.devicePixelRatio;

  double get textScaleFactor => mediaQueryData.textScaleFactor;

  Color get primaryColor => Theme.of(this).primaryColor;

  SizedBox sizedBoxH(double factor) => SizedBox(width: widthFactor(factor));

  SizedBox sizedBoxV(double factor) => SizedBox(height: heightFactor(factor));

  showSnackBarMessage(String message, {bool isError = false})  {
    Color? color = isError ? const Color(0xffff0000) : primaryColor;
    sleep(2);
    ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(content: Text(message, style: TextStyle(color: color, fontSize: 16)))
    );
  }

  dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}