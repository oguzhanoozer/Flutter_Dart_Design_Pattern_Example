import 'package:logger/logger.dart';

class Lesson {
  late int id;
  late String name;
  late double price;
  late double discountedPrice;
  late bool discountApplied;
  late String lessonNote;
}

abstract class LessonBuilder {
  late Lesson lesson;
  void getLesson();
  void applyDiscount();
  Lesson getResultLesson();
}

class NewStudentLessonBuilder implements LessonBuilder {
  @override
  late Lesson lesson;

  @override
  void applyDiscount() {
    lesson.discountedPrice = lesson.price * 0.5;
    lesson.discountApplied = true;
  }

  @override
  void getLesson() {
    lesson = Lesson();
    lesson.id = 1;
    lesson.name =
        "Artificial Intelligence -  Beginner to Advanced in 10 Minute.";
    lesson.price = 49.99;
  }

  @override
  Lesson getResultLesson() {
    return lesson;
  }
}

class OldStudentLessonBuilder implements LessonBuilder {
  @override
  late Lesson lesson;

  @override
  void applyDiscount() {
    lesson.discountedPrice = lesson.price;
    lesson.discountApplied = false;
  }

  @override
  void getLesson() {
    lesson = Lesson();
    lesson.id = 1;
    lesson.name =
        "Artificial Intelligence -  Beginner to Advanced in 10 Minute.";
    lesson.price = 49.99;
  }

  @override
  Lesson getResultLesson() {
    return lesson;
  }
}

class LessonDiredtor {
  late LessonBuilder lessonBuilder;
  LessonDiredtor(this.lessonBuilder);
  void make() {
    lessonBuilder.getLesson();
    lessonBuilder.applyDiscount();
  }
}

void main(List<String> args) {
  LessonBuilder lessonBuilder = NewStudentLessonBuilder();
  LessonDiredtor lessonDirector = LessonDiredtor(lessonBuilder);
  lessonDirector.make();
  Lesson lesson = lessonBuilder.getResultLesson();
  Logger().d(
      "${lesson.name}  - ${lesson.price} - ${lesson.discountApplied} - ${lesson.discountedPrice}");
}
