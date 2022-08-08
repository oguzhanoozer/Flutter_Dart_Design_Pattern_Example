import 'package:logger/logger.dart';

abstract class IDataSource {
  String getFileName();
  void writeData(Object data);
  void readData();
}

class FileDataSource extends IDataSource {
  late String _fileName;

  FileDataSource(String fileName) {
    _fileName = fileName;
  }

  String getFileName() {
    return _fileName;
  }

  void readData() {
    Logger().d("${_fileName} readed.");
  }

  void writeData(Object data) {
    Logger().d("$data was written to {_fileName}.");
  }
}

abstract class BaseDataSourceDecorator implements IDataSource {
  late IDataSource dataSource;
  BaseDataSourceDecorator(this.dataSource);
  @override
  String getFileName();
  @override
  void writeData(Object data);
  @override
  void readData();
}

class CompressionDecorator extends BaseDataSourceDecorator {
  CompressionDecorator(IDataSource dataSource) : super(dataSource);

  @override
  String getFileName() {
    return dataSource.getFileName();
  }

  @override
  void readData() {
    dataSource.readData();
  }

  @override
  void writeData(Object data) {
    Logger().d("Data compressed");
    Logger().d("Compressed data written to ${dataSource.getFileName()}");
  }

  void updateData() {
    Logger().d("Compressed data is update ${dataSource.getFileName()}");
  }
}

class A {
  int changeA() {
    return 10;
  }
}

class B extends A {
  int changeA() {
    return super.changeA() + 5;
  }
}

void main(List<String> args) {
  IDataSource dataSource = FileDataSource("data.sql");
  CompressionDecorator compressionDecorator = CompressionDecorator(dataSource);
  compressionDecorator.readData();
  compressionDecorator.writeData(Object());
  compressionDecorator.updateData();

  B b = B();
  print(b.changeA());
}
