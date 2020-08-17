import 'dart:async';
import 'dart:io';

import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ExampleViewModel extends ViewModel {

  final Subject<int> _counterSubject = BehaviorSubject.seeded(0);

  int value = 0;

  ExampleViewModel(BuildContext ctx) : super(ctx);

  @override
  void onInit() {
    super.onInit();
    _counterSubject.disposeWith(disposeBag);
  }

  get counterStream => _counterSubject.stream;

  void onAddPressed() {
    launchHandled(() async {
      await Future.delayed(Duration(seconds: 1));
      value++;
      if (value % 5 == 0) {
        throw AppException(message: 'values % 5 == 0');
      }
      _counterSubject.add(value);
    }, notifyProgress: true);
  }

  void onFirstBuild() {
    Future(() {
      notifyHaveBlockingProgress(true);
      notifyHaveBlockingProgress(true);
      notifyHaveBlockingProgress(true);
      notifyHaveBlockingProgress(true);
      Timer(Duration(seconds: 30), () {
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
        notifyHaveBlockingProgress(false);
      });
    });
  }
}