import 'package:flutter/foundation.dart';

class IsLoadingProvider with ChangeNotifier {
  bool _isLoading = false;
  get isLoading {
    return _isLoading;
  }

  set isLoading(value) {
    _isLoading = value;
  }

  void setIsLoadingFalse() {
    isLoading = false;
    notifyListeners();
  }

  void setIsLoadingTrue() {
    isLoading = true;
    notifyListeners();
  }
}
