import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/student.dart';

class StudentDioRepository {
  Future<List<Student>> findAll() async {
    // final studentsResult =
    //     await http.get(Uri.parse('http://localhost:8080/students'));

    // if (studentsResult.statusCode != 200) {
    //   throw Exception();
    // }

    try {
      final studentsResult = await Dio().get('http://localhost:8080/students');

      return studentsResult.data.map<Student>((student) {
        return Student.fromMap(student);
      }).toList();
    } on DioError catch (e) {
      print(e);
      throw Exception();
    }
  }

  Future<Student> findById(int id) async {
    // final studentResult =
    //     await http.get(Uri.parse('http://localhost:8080/students/$id'));

    // if (studentResult.statusCode != 200) {
    //   throw Exception();
    // }

    try {
      final studentResult =
          await Dio().get('http://localhost:8080/students/$id');

      if (studentResult.data == null) {
        throw Exception();
      }

      return Student.fromMap(studentResult.data);
    } on Exception catch (e) {
      print(e);
      throw Exception();
    }
  }

  Future<void> insert(Student student) async {
    try {
      await Dio().post(
        'http://localhost:8080/students',
        data: student.toMap(),
      );
    } on Exception catch (e) {
      print(e);
      throw Exception();
    }
  }

  Future<void> update(Student student) async {
    try {
      await Dio().put(
        'http://localhost:8080/students/${student.id}',
        data: student.toMap(),
      );
    } on Exception catch (e) {
      print(e);
      throw Exception();
    }
  }

  Future<void> deleteById(int id) async {
    try {
      await Dio().delete(
        'http://localhost:8080/students/$id',
      );
    } on Exception catch (e) {
      print(e);
      throw Exception();
    }
  }
}
