import 'dart:io';

import '../../../../models/address.dart';
import '../../../../models/city.dart';
import '../../../../models/phone.dart';
import '../../../../models/student.dart';
import '../../../../repositories/product_dio_repository.dart';
import '../../../../repositories/product_repository.dart';
import '../../../../repositories/student_dio_repository.dart';
import '../../../../repositories/student_repository.dart';
import 'package:args/command_runner.dart';

class InsertCommand extends Command {
  final StudentDioRepository studentRepository;
  final productRepository = ProductDioRepository();

  @override
  String get description => 'Insert Student';

  @override
  String get name => 'insert';

  InsertCommand(this.studentRepository) {
    argParser.addOption('file', help: 'Path of the csv file', abbr: 'f');
  }

  @override
  Future<void> run() async {
    print('Aguarde...');

    final filePath = argResults?['file'];
    final students = File(filePath).readAsLinesSync();
    print('-------------------------------------------');

//UM FOR DOS ESTUDANTES E DENTRO DELES O STUDANT E FIZ UM SPLI POR ; PARA QUEBRAR AS COLUNAS DO ARQUIVO
//DEPOIS PEGUEI O SEGUNDO CAMPO QUE È DOS CURSOS QUE PODE VIR UNICO OU SEPARADO POR VIRGULA, FIZ UM SPLIT DA VIRGULA E TIREI OS ESPACOS EM BRANCOS
//QUE PODE VIR AO LADO E TRANSFORMEI NUMA LISTA
    for (var student in students) {
      final studentData = student.split(';');
      final courseCsv = studentData[2].split(',').map((e) => e.trim()).toList();

//DEPOIS FIZ UM LOOP NA LISTA PARA BUSCAR O MODELO DOS CURSOS
      final courseFutures = courseCsv.map((c) async {
        final course = await productRepository.findByName(c);
        course.isStudent = true;
        return course;
      }).toList();

      final courses = await Future.wait(courseFutures);

      final studentModel = Student(
        name: studentData[0],
        age: int.tryParse(studentData[1]),
        nameCourses: courseCsv,
        courses: courses,
        address: Address(
            street: studentData[3],
            number: int.parse(studentData[4]),
            zipCode: studentData[5],
            city: City(id: 1, name: studentData[6]),
            phone:
                Phone(ddd: int.parse(studentData[7]), phone: studentData[8])),
      );

      await studentRepository.insert(studentModel);
    }
    print('-------------------------------------');
    print('Alunos Adicionados com Sucesso');
  }
}
