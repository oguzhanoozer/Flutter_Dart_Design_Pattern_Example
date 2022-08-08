import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/product/normal_button.dart';

abstract class IExpression {
  int interpret(ExpressionContext context);
}

class ExpressionContext {
  final List<String> _solutionSteps = [];

  List<String> getSolutionStep() {
    return _solutionSteps;
  }

  void addSolutionStep(String operatorSymbol, int left, int right, int result) {
    final solutionStep = '${_solutionSteps.length + 1}) $left $operatorSymbol $right = $result';
    _solutionSteps.add(solutionStep);
  }
}

class Add implements IExpression {
  final IExpression leftExpression;
  final IExpression rightExpression;

  Add(this.leftExpression, this.rightExpression);

  @override
  int interpret(ExpressionContext context) {
    final left = leftExpression.interpret(context);
    final right = rightExpression.interpret(context);
    final result = left + right;
    context.addSolutionStep('+', left, right, result);
    return result;
  }
}

class Multiply implements IExpression {
  final IExpression leftExpression;
  final IExpression rightExpression;

  const Multiply(this.leftExpression, this.rightExpression);

  @override
  int interpret(ExpressionContext context) {
    final left = leftExpression.interpret(context);
    final right = rightExpression.interpret(context);
    final result = left * right;
    context.addSolutionStep('*', left, right, result);

    return result;
  }
}

class Subtract implements IExpression {
  final IExpression leftExpression;
  final IExpression rightExpression;

  const Subtract(this.leftExpression, this.rightExpression);

  @override
  int interpret(ExpressionContext context) {
    final left = leftExpression.interpret(context);
    final right = rightExpression.interpret(context);
    final result = left - right;
    context.addSolutionStep('-', left, right, result);

    return result;
  }
}

class Number implements IExpression {
  final int number;

  const Number(this.number);

  @override
  int interpret(ExpressionContext context) {
    return number;
  }
}

class ExpressionHelpers {
  static final List<String> _operators = ["+", "-", "*"];

  static IExpression buildExpressionTree(String postFixExpression) {
    final expressionStack = ListQueue<IExpression>();

    for (final symbol in postFixExpression.split(' ')) {
      if (_isOperator(symbol)) {
        final rightExpression = expressionStack.removeLast();
        final leftExpression = expressionStack.removeLast();
        final nonTerminalExpression = _getNonterminalExpression(symbol, leftExpression, rightExpression);
        expressionStack.addLast(nonTerminalExpression);
      } else {
        final numberExpression = Number(int.parse(symbol));
        expressionStack.addLast(numberExpression);
      }
    }
    return expressionStack.single;
  }

  static bool _isOperator(String symbol) {
    return _operators.contains(symbol);
  }

  static IExpression _getNonterminalExpression(
    String symbol,
    IExpression leftExpression,
    IExpression rightExpression,
  ) {
    IExpression expression;
    switch (symbol) {
      case '+':
        expression = Add(leftExpression, rightExpression);
        break;
      case '-':
        expression = Subtract(leftExpression, rightExpression);
        break;
      case '*':
        expression = Multiply(leftExpression, rightExpression);
        break;
      default:
        throw Exception('Expression is not defined.');
    }
    return expression;
  }
}

class InterpretView extends StatefulWidget {
  InterpretView({Key? key}) : super(key: key);

  @override
  State<InterpretView> createState() => _InterpretViewState();
}

class _InterpretViewState extends State<InterpretView> {
  final List<String> _postFixExpression = ['20 3 5 * - 2 3 * +', '1 1 1 1 1 + + + * 2 -', '123 12 1 - - 12 9 * -', '9 8 7 6 5 4 3 2 1 + - + - + - + -'];

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var postfixExpression in _postFixExpression)
              ExpressionSection(
                postfixExpression: postfixExpression,
              ),
          ],
        ),
      ),
    );
  }
}

class ExpressionSection extends StatefulWidget {
  final String postfixExpression;
  ExpressionSection({Key? key, required this.postfixExpression}) : super(key: key);

  @override
  State<ExpressionSection> createState() => _ExpressionSectionState();
}

class _ExpressionSectionState extends State<ExpressionSection> {
  final ExpressionContext _expressionContext = ExpressionContext();

  List<String> _solutionSteps = [];

  void _solvePrefixExpression() {
    final solutionSteps = <String>[];
    final expression = ExpressionHelpers.buildExpressionTree(widget.postfixExpression);
    final result = expression.interpret(_expressionContext);

    solutionSteps
      ..addAll(_expressionContext.getSolutionStep())
      ..add('Result: $result');

    setState(() {
      _solutionSteps.addAll(solutionSteps);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.postfixExpression,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 10),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          firstChild: NormalButton(
            materialColor: Colors.black,
            materialTextColor: Colors.white,
            onPressed: _solvePrefixExpression,
            text: 'Solve',
          ),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (var solutionStep in _solutionSteps)
                Text(
                  solutionStep,
                  style: Theme.of(context).textTheme.subtitle2,
                )
            ],
          ),
          crossFadeState: _solutionSteps.isEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}