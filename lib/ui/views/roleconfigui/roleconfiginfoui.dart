import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/ui/cubit/roleconfiginfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/roleconfigui/roleconfiglistui.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';

class RoleConfigInfoUI extends StatefulWidget {
  final Role role;
  final User user;
  final Role userRole;
  const RoleConfigInfoUI(this.role, this.user, this.userRole, {super.key});

  @override
  State<RoleConfigInfoUI> createState() => _RoleConfigInfoUIState();
}

class _RoleConfigInfoUIState extends State<RoleConfigInfoUI> {
  var tfRoleName = TextEditingController();

  // Checkbox groups with their members (dynamically initialized from the Role)
  late Map<String, List<Map<String, dynamic>>> checkboxGroups;

  @override
  void initState() {
    super.initState();

    // Initialize role name
    tfRoleName.text = widget.role.role_name;

    // Initialize checkbox groups based on the passed role's permissions
    checkboxGroups = {
      "Process": [
        {"title": "Hot Presentation", "value": widget.role.hotpre == 1}, // Convert to boolean
        {"title": "Cold Presentation", "value": widget.role.coldpre == 1},
        {"title": "Disinfection", "value": widget.role.disinf == 1},
        {"title": "Soaking", "value": widget.role.soak == 1},
        {"title": "Cool and Reheat", "value": widget.role.candr == 1},
        {"title": "Receiving", "value": widget.role.receiving == 1},
      ],
      "Lists": [
        {"title": "Disinfection Assets", "value": widget.role.disinf_list == 1},
        {"title": "Cool and Reheat", "value": widget.role.candr_list == 1},
        {"title": "Hot Presentation Assets", "value": widget.role.hotpre_list == 1},
        {"title": "Cold Presentation Assets", "value": widget.role.coldpre_list == 1},
        {"title": "Receiving Firms", "value": widget.role.receiving_firms == 1},
      ],
      "Admin Panel": [
        {"title": "Personnel", "value": widget.role.personnel == 1},
        {"title": "Buffed Times", "value": widget.role.buffedtimes == 1},
        {"title": "Role Configurations", "value": widget.role.roleconfig == 1},
        {"title": "Reports", "value": widget.role.reports == 1},
      ],
      "Settings": [
        {"title": "Devices", "value": widget.role.devices == 1},
        {"title": "Update User", "value": widget.role.updateuser == 1},
      ],
    };
  }

  // Function to handle checkbox state changes
  void _handleCheckboxChange(String group, int index, bool? value) {
    setState(() {
      checkboxGroups[group]![index]['value'] = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Information Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Role name input field
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: tfRoleName,
                  decoration: const InputDecoration(
                    hintText: "Role Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // Build checkbox groups dynamically
              ..._buildCheckboxGroups(),

              const SizedBox(height: 20), // Adding some space before the update button
              ElevatedButton(
                onPressed: () {
                  context.read<RoleConfigInfoCubit>().update(
                      widget.role.id,
                      tfRoleName.text,
                      checkboxGroups["Process"]![0]['value'], // hotpre
                      checkboxGroups["Process"]![1]['value'], // coldpre
                      checkboxGroups["Process"]![2]['value'], // disinf
                      checkboxGroups["Process"]![3]['value'], // soak
                      checkboxGroups["Process"]![4]['value'], // candr
                      checkboxGroups["Process"]![5]['value'], // receiving
                      checkboxGroups["Lists"]![0]['value'], // disinfList
                      checkboxGroups["Lists"]![1]['value'], // candrList
                      checkboxGroups["Lists"]![2]['value'], // hotpreList
                      checkboxGroups["Lists"]![3]['value'], // coldpreList
                      checkboxGroups["Lists"]![4]['value'], // receivingFirms
                      checkboxGroups["Admin Panel"]![0]['value'], // personnel
                      checkboxGroups["Admin Panel"]![1]['value'], // buffedtimes
                      checkboxGroups["Admin Panel"]![2]['value'], // roleconfig
                      checkboxGroups["Admin Panel"]![3]['value'], // reports
                      checkboxGroups["Settings"]![0]['value'], // devices
                      checkboxGroups["Settings"]![1]['value'], // updateuser
                      widget.user.hotel
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoleConfigListUI(user: widget.user, userRole: widget.userRole)),
                  );
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the checkbox groups
  List<Widget> _buildCheckboxGroups() {
    return checkboxGroups.entries.map((entry) {
      String groupName = entry.key;
      List<Map<String, dynamic>> groupCheckboxes = entry.value;

      return Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                groupName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              ...groupCheckboxes.asMap().entries.map((entry) {
                int index = entry.key;
                var option = entry.value;
                return CheckboxListTile(
                  title: Text(option['title']),
                  value: option['value'],
                  onChanged: (val) {
                    _handleCheckboxChange(groupName, index, val);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      );
    }).toList();
  }
}