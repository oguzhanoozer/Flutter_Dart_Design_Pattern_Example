import 'package:logger/logger.dart';

abstract class User {
  final int id;
  final String name;
  final IChatRoomMediator _chatRoomMediator;

  User(this.id, this.name, this._chatRoomMediator);

  void receivedMessage(String message) {
    Logger().d("${name} received new message. Message: ${message}");
  }

  void sendMesssage(String message, int userId) {
    Logger().d("${name} send new message to: ${userId} id user.");
    _chatRoomMediator.sendMessage(message, userId);
  }
}

class ChatUser extends User {
  ChatUser(int id, String name, IChatRoomMediator chatRoomMediator) : super(id, name, chatRoomMediator);
}

abstract class IChatRoomMediator {
  void sendMessage(String message, int userId);
  void addUserInRoom(User user);
}

class ChatRoomMediator extends IChatRoomMediator {
  late Map<int, User> _usermap;

  ChatRoomMediator() {
    _usermap = Map();
  }

  @override
  void addUserInRoom(User user) {
    _usermap[user.id] = user;
  }

  @override
  void sendMessage(String message, int userId) {
    User? user = _usermap[userId];
    user!.receivedMessage(message);
  }
}

void main(List<String> args) {
  IChatRoomMediator chatRoomMediator = ChatRoomMediator();

  User oguzhan = ChatUser(1, "Oğuzhan", chatRoomMediator);
  User ali = ChatUser(1, "Ali", chatRoomMediator);
  User ramo = ChatUser(1, "Ramo", chatRoomMediator);

  chatRoomMediator.addUserInRoom(oguzhan);
  chatRoomMediator.addUserInRoom(ali);
  chatRoomMediator.addUserInRoom(ramo);

  oguzhan.sendMesssage("Naber knk?", ali.id);
  ali.sendMesssage("Takılıyoz knk", oguzhan.id);
}
