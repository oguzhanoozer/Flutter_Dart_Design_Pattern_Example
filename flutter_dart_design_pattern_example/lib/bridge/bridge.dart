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
  IMessageSender emailMessageSender = EmailMessageSender();
  Message textMessage = TextMessage(emailMessageSender);
  textMessage.send();

  var str = jsonEncode(Order());
  Logger().d(str);
}

abstract class EntityBase {
  late String id;

  EntityBase() {
    id = "sdasdsaddsa";
  }

  EntityBase.fromJson(Map<String, dynamic> json) : id = json['id'] as String;
}

class Order extends EntityBase {
  late List<String> dishes;
  late double total;

  Order() {
    dishes = List.generate(1, (_) => "oguz");
    total = 10;
  }

  Order.fromJson(Map<String, dynamic> json)
      : dishes = List.from(json['dishes'] as List),
        total = json['total'] as double,
        super.fromJson(json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'dishes': dishes,
        'total': total,
      };
}
