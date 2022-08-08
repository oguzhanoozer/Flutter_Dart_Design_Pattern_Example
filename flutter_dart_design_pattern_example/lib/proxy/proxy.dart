import 'package:logger/logger.dart';

abstract class IOrderableMask {
  void createOrder(String userId);
}

class MaskOrder extends IOrderableMask {
  void createOrder(String userID) {
    Logger().d("${userID} created to  own account");
  }
}

class AuthenticationMaskOrderProxy extends IOrderableMask {
  late IOrderableMask _maskOrder;

  AuthenticationMaskOrderProxy() {
    _maskOrder = MaskOrder();
  }

  @override
  void createOrder(String userId) {
    if (checkIdIsValid(userId)) {
      _maskOrder.createOrder(userId);
    }
  }

  bool checkIdIsValid(String userId) {
    return userId.length == 11 ? true : false;
  }
}

void main(List<String> args) {
  IOrderableMask maskOrder = AuthenticationMaskOrderProxy();
  maskOrder.createOrder("12345678910");
}
