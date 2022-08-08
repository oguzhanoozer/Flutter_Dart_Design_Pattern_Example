import 'package:logger/logger.dart';

class StudentMoment {
  String name;

  StudentMoment(this.name);

  String get studentName => name;

  void set(String name) {
    this.name = name;
  }
}

class Originator {
  late String name;
  String get studentName => name;

  void setName(String name) {
    this.name = name;
  }

  StudentMoment saveNameToMoment() {
    return StudentMoment(name);
  }

  void getNameFromMoment(StudentMoment studentMoment) {
    name = studentMoment.studentName;
  }
}

class CareTaker {
  List<StudentMoment> studentMomentlist = [];

  void addStudentList(StudentMoment studentMoment) {
    studentMomentlist.add(studentMoment);
  }

  StudentMoment getStudentMoment(int index) {
    return studentMomentlist.elementAt(index);
  }
}

void main(List<String> args) {
  CareTaker careTaker = CareTaker();
  Originator originator = Originator();

  originator.setName("oğuzhan");
  originator.setName("Özer");
  careTaker.addStudentList(originator.saveNameToMoment());

  originator.setName("Ali");
  careTaker.addStudentList(originator.saveNameToMoment());

  originator.setName("Berk");
  careTaker.addStudentList(originator.saveNameToMoment());

  originator.getNameFromMoment(careTaker.getStudentMoment(0));  
  Logger().d("First ${originator.studentName}");
  originator.getNameFromMoment(careTaker.getStudentMoment(1));  
  Logger().d("Second ${originator.studentName}");
}
