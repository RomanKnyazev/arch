import 'dart:async';

import 'package:arch/src/utils/dispose_bag.dart';
import 'package:arch/src/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class ViewModel {
  final DisposeBag disposeBag = DisposeBag();

  final BehaviorSubject<bool> _activityIndicatorSubject =
      BehaviorSubject.seeded(false);

  final PublishSubject<String> _errorMessagesSubject = PublishSubject();

  final Subject<bool> _needToShowBlockingLoadingSubject =
      BehaviorSubject.seeded(false);

  @protected
  final NavigatorState navigator;

  ViewModel(BuildContext ctx) : navigator = Navigator.of(ctx);

  Stream<bool> get activityIndicatorStream => _activityIndicatorSubject.stream;

  Stream<bool> get needToShowBlockingLoadingStream =>
      _needToShowBlockingLoadingSubject.stream;

  Stream<String> get errorMessagesStream => _errorMessagesSubject.stream;

  @mustCallSuper
  void onInit() {
    _activityIndicatorSubject.disposeWith(disposeBag);
    _errorMessagesSubject.disposeWith(disposeBag);
    _needToShowBlockingLoadingSubject.disposeWith(disposeBag);
  }

  @mustCallSuper
  void dispose() {
    disposeBag.dispose();
  }

  @protected
  void notifyHaveProgress(bool haveProgress) {
    _activityIndicatorSubject.add(haveProgress);
  }

  @protected
  void notifyHaveBlockingProgress(bool haveProgress) {
    _needToShowBlockingLoadingSubject.add(haveProgress);
  }

  @protected
  void notifyErrorMessage(String message) {
    _errorMessagesSubject.add(message);
  }

  @protected
  void handleThrows(Object thrownObject) {
    if (thrownObject is Error) {
      _errorMessagesSubject.add(thrownObject.toString());
    } else if (thrownObject is Exception) {
      if (thrownObject is AppException) {
        handleAppException(thrownObject);
      } else {
        _errorMessagesSubject.add(thrownObject.toString());
      }
    } else {
      throw thrownObject;
    }
  }

  @protected
  void handleAppException(AppException exception) {
    _errorMessagesSubject.add(exception.message);
  }

  @protected
  Future<void> launchHandled<T>(
    FutureOr<T> perform(), {
    bool notifyProgress = false,
  }) {
    return Future(() async {
      if (notifyProgress) {
        notifyHaveProgress(true);
      }
      try {
        await perform();
      } catch (o) {
        handleThrows(o);
      } finally {
        if (notifyProgress) {
          notifyHaveProgress(false);
        }
      }
    });
  }
}
