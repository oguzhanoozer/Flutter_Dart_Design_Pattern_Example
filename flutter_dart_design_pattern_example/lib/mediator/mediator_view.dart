import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/product/normal_button.dart';

abstract class TeamMember {
  final String name;
  NotificationHub? notificationHub;
  String? lastNotification;

  TeamMember(this.name);

  void receive(String from, String message) {
    lastNotification = "$from: $message";
  }

  void send(String message) {
    notificationHub?.send(this, message);
  }

  void sendTo<T extends TeamMember>(String message) {
    notificationHub?.sendTo<T>(this, message);
  }
}

abstract class NotificationHub {
  List<TeamMember> getTeamMembers();
  void register(TeamMember member);
  void send(TeamMember sender, String message);
  void sendTo<T extends TeamMember>(TeamMember sender, String message);
}

class Admin extends TeamMember {
  Admin(String name) : super(name);

  String toString() {
    return "$name (Admin)";
  }
}

class Developer extends TeamMember {
  Developer(String name) : super(name);

  String toString() {
    return "$name (Developer)";
  }
}

class Tester extends TeamMember {
  Tester(String name) : super(name);

  String toString() {
    return "$name (Tester)";
  }
}

class TeamNotificationHub extends NotificationHub {
  final _teamMembers = <TeamMember>[];
  TeamNotificationHub(List<TeamMember>? members) {
    members?.forEach(register);
  }

  @override
  List<TeamMember> getTeamMembers() => _teamMembers;

  @override
  void register(TeamMember member) {
    member.notificationHub = this;
    _teamMembers.add(member);
  }

  @override
  void send(TeamMember sender, String message) {
    final _filteredMembers = _teamMembers.where((element) => element != sender);
    for (final member in _filteredMembers) {
      member.receive(sender.toString(), message);
    }
  }

  @override
  void sendTo<T extends TeamMember>(TeamMember sender, String message) {
    final _filteredMembers = _teamMembers.where((element) => element != sender).whereType<T>();

    for (final member in _filteredMembers) {
      member.receive(sender.toString(), message);
    }
  }
}

class MediatorView extends StatefulWidget {
  MediatorView({Key? key}) : super(key: key);

  @override
  State<MediatorView> createState() => _MediatorViewState();
}

class _MediatorViewState extends State<MediatorView> {
  late final NotificationHub _notificationHub;
  final _admin = Admin("God");

  @override
  void initState() {
    super.initState();

    final _members = [_admin, Developer("Ali"), Developer("Buğra"), Tester("Elif"), Tester("Ahmet")];
    _notificationHub = TeamNotificationHub(_members);
  }

  void _sendToAll() {
    setState(() {
      _admin.send("Hello");
    });
  }

  void _sendToTester() {
    setState(() {
      _admin.sendTo<Tester>("BUG");
    });
  }

  void _sendToDeveloper() {
    setState(() {
      _admin.sendTo<Developer>("Hello World");
    });
  }

  void _addTeamMember() {
    final name = "${faker.person.firstName()} ${faker.person.lastName()}}";
    final teamMember = faker.randomGenerator.boolean() ? Tester(name) : Developer(name);
    setState(() {
      _notificationHub.register(teamMember);
    });
  }

void _sendFromMember(TeamMember member) {
    setState(() {
      member.send('Hello from ${member.name}');
    });
  }
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            NormalButton(
              text: "Admin: Send 'Hello' to all",
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: _sendToAll,
            ),
            NormalButton(
              text: "Admin: Send 'BUG!' to QA",
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: _sendToTester,
            ),
            NormalButton(
              text: "Admin: Send 'Hello, World!' to Developers",
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: _sendToDeveloper,
            ),
            const Divider(),
            NormalButton(
              text: "Add team member",
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: _addTeamMember,
            ),
            const SizedBox(height: 10),
            NotificationList(
              members: _notificationHub.getTeamMembers(),
              onTap: _sendFromMember,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  final List<TeamMember> members;
  final ValueSetter<TeamMember> onTap;

  const NotificationList({
    required this.members,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Last notifications',
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 10),
        Text(
          'Note: click on the card to send a notification from the team member.',
          style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(height:10),
        for (final member in members)
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 10
            ),
            child: InkWell(
              onTap: () => onTap(member),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical:10,
                  horizontal:10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(member.lastNotification ?? '-'),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.message),
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
