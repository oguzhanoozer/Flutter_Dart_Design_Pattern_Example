import 'package:logger/logger.dart';

abstract class IJsonSerializer {
  String serializeObject(Object object);
}

class CustomSerializer {
  String serialize(Object object) {
    return "Serialize with Customer";
  }
}

class CustomSerializerAdapter implements IJsonSerializer {
  @override
  String serializeObject(Object object) {
    CustomSerializer customSerializer = CustomSerializer();
    return customSerializer.serialize(object);
  }
}

class CustomOperation {
  final IJsonSerializer jsonSerializer;
  CustomOperation(this.jsonSerializer);

  String serializedObject(Object object) {
    return jsonSerializer.serializeObject(object);
  }
}

void main(List<String> args) {
  CustomOperation customOperation = CustomOperation(CustomSerializerAdapter());
  String serializedString = customOperation.serializedObject(Object());
  Logger().d(serializedString);
}
