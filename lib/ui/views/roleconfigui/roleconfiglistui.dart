import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/main.dart';
import 'package:gastrobluecheckapp/ui/cubit/roleconfiglist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/roleconfigui/roleconfiginfoui.dart';
import 'package:gastrobluecheckapp/ui/views/roleconfigui/roleconfigsubmitui.dart';

import '../../../data/entity/user.dart';

class RoleConfigListUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const RoleConfigListUI({required this.user, required this.userRole, Key? key}) : super(key: key);

  @override
  State<RoleConfigListUI> createState() => _RoleConfigListUIState();
}

class _RoleConfigListUIState extends State<RoleConfigListUI> {
  bool searchIsActive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<RoleConfigListCubit>().loadRoles(widget.user.hotel);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: searchIsActive
          ? TextField(
          decoration: InputDecoration(hintText: "Rol Ara"),
          onChanged: (searching) {
            context.read<RoleConfigListCubit>().search(searching, widget.user.hotel);
          },
        )
            : const Text("Rol Listesi"),
        actions: [
          searchIsActive
              ? IconButton(
              onPressed: () {
                setState(() {
                  searchIsActive = false;
                });
                context.read<RoleConfigListCubit>().loadRoles(widget.user.hotel);
              },
              icon: const Icon(Icons.clear),
          )
              : IconButton(
            onPressed: () {
              setState(() {
                searchIsActive = true;
              });
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: BlocBuilder<RoleConfigListCubit, List<Role>>(
        builder: (context, roleList) {
          if(roleList.isNotEmpty) {
            return ListView.builder(
              itemCount: roleList.length,
              itemBuilder: (context, index) {
                var role = roleList[index];
                return Dismissible(
                  key: Key(role.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "${role.role_name} rolünü silmek istiyor musunuz?"
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Hayır"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Evet"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    context.read<RoleConfigListCubit>().delete(role.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${role.role_name} silindi",style: TextStyle(color: Colors.black),),
                        backgroundColor: smallWidgetColor,
                      ),
                    );
                  },
                  child: Card(
                    color: smallWidgetColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(role.role_name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RoleConfigInfoUI(role, widget.user, widget.userRole)
                          ),
                        ).then((value) {
                          context.read<RoleConfigListCubit>().loadRoles(widget.user.hotel);
                        });
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Rol Bulunmamaktadır"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: bigWidgetColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RoleConfigSubmitUI(user: widget.user, userRole: widget.userRole)
              ));
        },
      child: const Icon(Icons.add, color: Colors.white),),
    );
  }
}

