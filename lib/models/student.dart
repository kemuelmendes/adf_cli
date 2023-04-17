// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'address.dart';
import 'course.dart';

class Student {
  final int? id;
  final String name;
  final int? age;
  final List<String> nameCourses;
  final List<Course> courses;
  final Address address;

  Student({
    this.id,
    required this.name,
    this.age,
    required this.nameCourses,
    required this.courses,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'nameCourses': nameCourses,
      'courses': courses.map((curso) => curso.toMap()).toList(),
      'address': address.toMap(),
    };

    if (age != null) {
      map['age'] = age;
    }
    return map;
  }

  String toJson() => jsonEncode(toMap());

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      age: map['age'],
      nameCourses: List<String>.from(map['nameCourses'] ?? <String>[]),
      address: Address.fromMap(map['address'] ?? <String, dynamic>{}),
      courses: map['courses']
              ?.map<Course>((cursoMap) => Course.fromMap(cursoMap))
              .toList() ??
          <Course>[],
    );
  }

  factory Student.fromJson(String json) => Student.fromMap(jsonDecode(json));
}
