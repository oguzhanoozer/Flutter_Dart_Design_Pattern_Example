import 'package:logger/logger.dart';

abstract class ILessonComposit {
  void completeSubject();
}

class LessonCategory extends ILessonComposit {
  final String name;
  late List<ILessonComposit> _listLessonComponent;

  LessonCategory(this.name) {
    _listLessonComponent = [];
  }

  void addLesson(ILessonComposit lessonComposit) {
    _listLessonComponent.add(lessonComposit);
  }

  void removeLesson(ILessonComposit lessonComposit) {
    _listLessonComponent.remove(lessonComposit);
  }

  @override
  void completeSubject() {
    Logger().d(name);
    _listLessonComponent.forEach((element) {
      element.completeSubject();
    });
  }
}

class Lesson extends ILessonComposit {
  final String lessonName;

  Lesson(this.lessonName);

  @override
  void completeSubject() {
    Logger().d(lessonName);
  }
}

void main(List<String> args) {
  LessonCategory lessons = LessonCategory("Lessons");
  LessonCategory math = LessonCategory("Math");
  LessonCategory physics = LessonCategory("Physics");
  LessonCategory sport = LessonCategory("Sport");
  LessonCategory music = LessonCategory("Music");

  Lesson biology = Lesson("Biology");
  Lesson english = Lesson("English");

  lessons.addLesson(math);
  math.addLesson(physics);
  physics.addLesson(sport);
  sport.addLesson(music);
  math.addLesson(biology);
  sport.addLesson(english);
  lessons.completeSubject();
}
