import 'package:logger/logger.dart';

enum ExtensionOfImage { JPEG, JPG }

class Image {
  final String image;
  final ExtensionOfImage extension;

  Image(this.image, this.extension);
}

abstract class BaseHandler {
  late BaseHandler _nextHandler;
  void setNextHandler(BaseHandler nextHandler) {
    _nextHandler = nextHandler;
  }

  void handlerRequest(Image image);
}

class JPEGHandler extends BaseHandler {
  @override
  void handlerRequest(Image image) {
    if (image.extension == ExtensionOfImage.JPEG) {
      Logger().d(ExtensionOfImage.JPEG.name + " is printed");
    } else {
      _nextHandler.handlerRequest(image);
    }
  }
}

class JPGHandler extends BaseHandler {
  @override
  void handlerRequest(Image image) {
    if (image.extension == ExtensionOfImage.JPG) {
      Logger().d(ExtensionOfImage.JPG.name + " is printed");
    } else {
      _nextHandler.handlerRequest(image);
    }
  }
}

class CustomHandler extends BaseHandler {
  @override
  void handlerRequest(Image image) {
    if (image.extension != ExtensionOfImage.JPEG && image.extension != ExtensionOfImage.JPG) {
      Logger().d("Other Extension not found");
    }
  }
}

void main(List<String> args) {
  Image image = Image("my_photo", ExtensionOfImage.JPG);
  JPEGHandler jpegHandler = JPEGHandler();
  JPGHandler jpgHandler = JPGHandler();
  CustomHandler customHandler = CustomHandler();

  jpegHandler.setNextHandler(jpgHandler);
  jpgHandler.setNextHandler(customHandler);
  jpegHandler.handlerRequest(image);
}
