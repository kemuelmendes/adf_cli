// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:args/command_runner.dart';

import '../../../../repositories/student_dio_repository.dart';
import '../../../../repositories/student_repository.dart';

class DeleteCommand extends Command {
  StudentDioRepository repository;

  @override
  String get description => 'Delete Student by id';
  @override
  String get name => 'delete';

  DeleteCommand(
    this.repository,
  ) {
    argParser.addOption('id', help: 'Student Id', abbr: 'i');
  }

  @override
  Future<void> run() async {
    final id = int.tryParse(argResults?['id']);

    if (id == null) {
      print('Por favor informe o id do aluno com o comando --id=1 ou -i 1');
      return;
    }

    print('Aguarde...');
    final student = await repository.findById(id);

    print('Confirma a exclusão do aluno ${student.name}? (S ou N)');

    final confirmDelete = stdin.readLineSync();

    if (confirmDelete?.toLowerCase() == 's') {
      await repository.deleteById(id);
      print('--------------------------------------');
      print('Aluno Deletado com sucesso');
      print('--------------------------------------');
    } else {
      print('--------------------------------------');
      print('Operação Cancelada!!!');
      print('--------------------------------------');
    }
  }
}
