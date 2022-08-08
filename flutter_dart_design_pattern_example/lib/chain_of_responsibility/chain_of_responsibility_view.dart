import 'dart:async';
import 'dart:collection';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/product/normal_button.dart';

enum LogLevel { Debug, Info, Error }

extension LogLevelExtensions on LogLevel {
  bool operator <=(LogLevel level) => this.index <= level.index;
}

class LogMessage {
  final LogLevel logLevel;
  final String message;

  const LogMessage({
    required this.logLevel,
    required this.message,
  });

  String get _logLevelString => logLevel.toString().split('.').last.toUpperCase();

  Color _getLogEntryColor() {
    switch (logLevel) {
      case LogLevel.Debug:
        return Colors.grey;
      case LogLevel.Info:
        return Colors.blue;
      case LogLevel.Error:
        return Colors.red;
      default:
        throw Exception("Log level '$logLevel' is not supported.");
    }
  }

  Widget getFormattedMessage() {
    return Text(
      '$_logLevelString: $message',
      style: TextStyle(
        color: _getLogEntryColor(),
      ),
      textAlign: TextAlign.justify,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}

class LogBloc {
  final List<LogMessage> _logs = <LogMessage>[];
  final StreamController<List<LogMessage>> _logStream = StreamController<List<LogMessage>>();

  StreamSink<List<LogMessage>> get _inLogStream => _logStream.sink;
  Stream<List<LogMessage>> get outLogStream => _logStream.stream;

  void log(LogMessage logMessage) {
    _logs.add(logMessage);
    _inLogStream.add(UnmodifiableListView(_logs));
  }

  void dispose() {
    _logStream.close();
  }
}

class ExternalLogginService {
  final LogBloc logBloc;

  ExternalLogginService(this.logBloc);

  void logMessage(LogLevel logLevel, String message) {
    var logMessage = LogMessage(logLevel: logLevel, message: message);
    logBloc.log(logMessage);
  }
}

class MailService {
  final LogBloc logBloc;

  MailService(this.logBloc);

  void sendErrorMail(LogLevel logLevel, String message) {
    var logMessage = LogMessage(logLevel: logLevel, message: message);
    logBloc.log(logMessage);
  }
}

abstract class LoggerBase {
  @protected
  final LogLevel logLevel;
  final LoggerBase? _nextLogger;

  LoggerBase(this.logLevel, this._nextLogger);

  void logMessage(LogLevel level, String message) {
    if (logLevel <= level) {
      log(message);
    }

    _nextLogger?.logMessage(level, message);
  }

  void logDebug(String message) => logMessage(LogLevel.Debug, message);
  void logInfo(String message) => logMessage(LogLevel.Info, message);
  void logError(String message) => logMessage(LogLevel.Error, message);

  void log(String message);
}

class DebugLogger extends LoggerBase {
  final LogBloc logBloc;

  DebugLogger(this.logBloc, [LoggerBase? nextLogger]) : super(LogLevel.Debug, nextLogger);

  @override
  void log(String message) {
    final logMessage = LogMessage(logLevel: logLevel, message: message);

    logBloc.log(logMessage);
  }
}

class ErrorLogger extends LoggerBase {
  late MailService mailService;

  ErrorLogger(LogBloc logBloc, [LoggerBase? nextLogger]) : super(LogLevel.Error, nextLogger) {
    mailService = MailService(logBloc);
  }

  @override
  void log(String message) {
    mailService.sendErrorMail(logLevel, message);
  }
}

class InfoLogger extends LoggerBase {
  late ExternalLogginService externalLoggingService;

  InfoLogger(LogBloc logBloc, [LoggerBase? nextLogger]) : super(LogLevel.Info, nextLogger) {
    externalLoggingService = ExternalLogginService(logBloc);
  }

  @override
  void log(String message) {
    externalLoggingService.logMessage(logLevel, message);
  }
}

class ChainOfResponsibilityView extends StatefulWidget {
  ChainOfResponsibilityView({Key? key}) : super(key: key);

  @override
  State<ChainOfResponsibilityView> createState() => _ChainOfResponsibilityViewState();
}

class _ChainOfResponsibilityViewState extends State<ChainOfResponsibilityView> {
  final LogBloc logBloc = LogBloc();
  late LoggerBase loggerBase;

  @override
  void initState() {
    loggerBase = DebugLogger(logBloc, InfoLogger(logBloc, ErrorLogger(logBloc)));
  }

  String get randomLog => faker.lorem.sentence();

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            NormalButton(
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: () => loggerBase.logDebug(randomLog),
              text: 'Log debug',
            ),
            NormalButton(
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: () => loggerBase.logInfo(randomLog),
              text: 'Log info',
            ),
            NormalButton(
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: () => loggerBase.logError(randomLog),
              text: 'Log error',
            ),
            const Divider(),
            Row(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<List<LogMessage>>(
                      initialData: const [], stream: logBloc.outLogStream, builder: (context, snapshot) => buildLogMessageColumn(snapshot)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column buildLogMessageColumn(AsyncSnapshot<List<LogMessage>> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var logMessage in snapshot.data!)
          Row(
            children: <Widget>[
              Expanded(
                child: logMessage.getFormattedMessage(),
              ),
            ],
          )
      ],
    );
  }
}
