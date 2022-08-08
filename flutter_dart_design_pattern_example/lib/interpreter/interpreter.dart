import 'package:logger/logger.dart';

class Context {
  String formula;
  int totalPoint;

  Context(this.formula, this.totalPoint);
}

abstract class JobExpression {
  void interpret(Context context);
}

class TeamLeadExpression extends JobExpression {
  @override
  void interpret(Context context) {
    if (context.formula.contains("L")) {
      context.totalPoint += 7000;
    }
  }
}

class AccountExpression extends JobExpression {
  @override
  void interpret(Context context) {
    if (context.formula.contains("M")) {
      context.totalPoint += 3000;
    }
  }
}

class DeveloperExpression extends JobExpression {
  @override
  void interpret(Context context) {
    if (context.formula.contains("G")) {
      context.totalPoint += 4000;
    }
  }
}

class JobManager {
  List<JobExpression> _createExpression(String formula) {
    List<JobExpression> tree = [];

    formula.split('').forEach((element) {
      if (element.contains("G")) {
        tree.add(DeveloperExpression());
      } else if (element.contains("L")) {
        tree.add(TeamLeadExpression());
      } else if (element.contains("M")) {
        tree.add(AccountExpression());
      } else {
        throw Exception("Unexpected role!");
      }
    });
    return tree;
  }

  void runExpression(Context context) {
    for (JobExpression jobExpression in _createExpression(context.formula)) {
      jobExpression.interpret(context);
    }
  }
}

void main(List<String> args) {
  Context context = Context("GGML", 0);
  JobManager jobManager = JobManager();
  jobManager.runExpression(context);
  Logger().d("${context.formula} -> ${context.totalPoint}");
}
