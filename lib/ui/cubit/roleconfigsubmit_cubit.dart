import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/roledao_repository.dart';

class RoleConfigSubmitCubit extends Cubit{
  RoleConfigSubmitCubit():super(0);

  var RRepo = RoleDaoRepository();

  Future<void> submit(String role_name, bool hotpre, bool coldpre, bool disinf, bool soak, bool candr, bool receiving, bool disinf_list, bool candr_list, bool hotpre_list, bool coldpre_list, bool receiving_firms, bool personnel, bool buffedtimes, bool roleconfig, bool reports, bool devices, bool updateuser, String hotel) async {
    RRepo.submit(role_name, hotpre, coldpre, disinf, soak, candr, receiving, disinf_list, candr_list, hotpre_list, coldpre_list, receiving_firms, personnel, buffedtimes, roleconfig, reports, devices, updateuser, hotel);
  }
}