import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/userdao_repository.dart';

class SectionSubmitCubit extends Cubit{
  SectionSubmitCubit():super(0);

  var URepo = UserDaoRepository();

  Future<void> sectionSubmit(String section_name, String hotel) async {
    URepo.sectionSubmit(section_name, hotel);
  }
}