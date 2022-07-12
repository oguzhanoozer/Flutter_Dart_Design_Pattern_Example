import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/builder/builder_selection.dart';

class Student {
  late List<double> lessonScore;
  late String lessonName;

  double getAverageOfLesson() {
    double sumScore = 0.0;
    lessonScore.forEach((element) {
      sumScore += element;
    });
    return sumScore / lessonScore.length;
  }

  String get getLessonName => lessonName;
}

abstract class StudentBuilder {
  late Student student;
  void getStudent();
  double getAverageOfLesson();
  Student getResultStudent();
  String getStudentName();
}

class StudentALessonBuilder implements StudentBuilder {
  @override
  late Student student;

  @override
  double getAverageOfLesson() {
    return student.getAverageOfLesson();
  }

  @override
  Student getResultStudent() {
    return student;
  }

  @override
  void getStudent() {
    student = Student();
    student.lessonScore = [90, 70, 67, 92];

    student.lessonName = "Math";
  }

  String getStudentName() {
    return "Student A";
  }
}

class StudentBLessonBuilder implements StudentBuilder {
  @override
  late Student student;

  @override
  double getAverageOfLesson() {
    return student.getAverageOfLesson();
  }

  @override
  Student getResultStudent() {
    return student;
  }

  @override
  void getStudent() {
    student = Student();
    student.lessonScore = [55, 44, 34, 67];

    student.lessonName = "Physic";
  }

  String getStudentName() {
    return "Student B";
  }
}

class StudentDirector {
  late StudentBuilder studentBuilder;
  StudentDirector(this.studentBuilder);

  void make() {
    studentBuilder.getStudent();
  }
}

class BuilderView extends StatefulWidget {
  BuilderView({Key? key}) : super(key: key);

  @override
  State<BuilderView> createState() => _BuilderViewState();
}

class _BuilderViewState extends State<BuilderView> {
  List<StudentBuilder> _studentBuilderList = [
    StudentALessonBuilder(),
    StudentBLessonBuilder()
  ];

  late StudentDirector _studentDirector;
  late Student _student;
  void createBuilder() {
    _studentDirector =
        StudentDirector(_studentBuilderList[_selectedOptionIndex]);
    _studentDirector.make();
    _student = _studentBuilderList[_selectedOptionIndex].getResultStudent();
  }

  void _changeStudentOptionIndex(int? index) {
    setState(() {
      _selectedOptionIndex = index!;
    });
    createBuilder();
  }

  int _selectedOptionIndex = 0;

  @override
  void initState() {
    createBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BuilderSelection(
            onChanged: _changeStudentOptionIndex,
            selectedIndex: _selectedOptionIndex,
            studentBuilderList: _studentBuilderList,
          ),
          Text(_student.getLessonName),
          Text(_student.getAverageOfLesson().toString()),
        ],
      ),
    ));
  }
}
