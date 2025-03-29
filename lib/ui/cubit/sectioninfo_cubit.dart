import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/userdao_repository.dart';

class SectionInfoCubit extends Cubit{
  SectionInfoCubit():super(0);

  var URepo = UserDaoRepository();

  Future<void> sectionUpdate(String id, String section_name, String hotel) async {
    await URepo.sectionUpdate(id, section_name, hotel);
  }
}