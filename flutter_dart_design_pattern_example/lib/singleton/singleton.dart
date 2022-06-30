import 'package:logger/logger.dart';

class SingletonEager {
  static SingletonEager _singletonInstance = SingletonEager._init();

  SingletonEager._init() {
    Logger().i("Singleton created");
  }

  static SingletonEager get singletonInstance => _singletonInstance;
}

class SingletonLazyLoading {
  static SingletonLazyLoading? _singletonInstance;

  SingletonLazyLoading._init() {
    Logger().i("SingletonLazyLoading created");
  }

  static SingletonLazyLoading singletonInstance() {
    Logger().i("Static Constructor");
    _singletonInstance ??= SingletonLazyLoading._init();
    return _singletonInstance!;
  }
}

class SingletonFactory {
  static final SingletonFactory _singletonInstance = SingletonFactory._init();

  SingletonFactory._init() {
    Logger().i("Factory Singleton created");
  }

  factory SingletonFactory() {
    Logger().i("Factory Constructor");
    return _singletonInstance;
  }
}

void main() {
  //SingletonFactory factoryConstructor = SingletonFactory();
  ///Singleton.singletonInstance();
  SingletonEager.singletonInstance;
}
