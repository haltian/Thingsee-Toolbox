import 'package:flutter/cupertino.dart';

class DimUiModel extends ChangeNotifier {
  bool _dimmed = false;

  void setDimmed(bool value) {
    _dimmed = value;
    notifyListeners();
  }

  bool getDimmed() {
    return _dimmed;
  }
}
