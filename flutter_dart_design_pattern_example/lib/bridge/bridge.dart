import 'dart:convert';

import 'package:logger/logger.dart';

abstract class IMessageSender {
  void sendMessage();
}

class EmailMessageSender extends IMessageSender {
  @override
  void sendMessage() {
    Logger().d("EmailMessageSender: Sending email message...");
  }
}

class TextMessageSender extends IMessageSender {
  @override
  void sendMessage() {
    Logger().d("TextMessageSender: Sending email message...");
  }
}

abstract class Message {
  late IMessageSender messageSender;

  Message(this.messageSender);

  void send();
}

/*

class EmailMessage extends Message {
  EmailMessage(IMessageSender messageSender) : super(messageSender);

  @override
  void send() {
    messageSender.sendMessage();
  }
}

class TextMessage extends Message {
  TextMessage(IMessageSender messageSender) : super(messageSender);

  @override
  void send() {
    messageSender.sendMessage();
  }
}
*/

class MessageControl extends Message {
  MessageControl(IMessageSender messageSender) : super(messageSender);

  @override
  void send() {
    messageSender.sendMessage();
  }
}

void main(List<String> args) {
  IMessageSender textMessageSender = TextMessageSender();
  MessageControl messageControl = MessageControl(textMessageSender);
  messageControl.send();

  /*
  IMessageSender emailMessageSender = EmailMessageSender();
  Message textMessage = TextMessage(emailMessageSender);
  textMessage.send();

*/
}
