import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/ui/cubit/roleconfigsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/roleconfigui/roleconfiglistui.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';

class RoleConfigSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const RoleConfigSubmitUI({required this.user,required this.userRole, Key? key}) : super(key: key);

  @override
  State<RoleConfigSubmitUI> createState() => _RoleConfigSubmitUIState();
}

class _RoleConfigSubmitUIState extends State<RoleConfigSubmitUI> {
  var tfRoleName = TextEditingController();

  // Checkbox groups with their members
  Map<String, List<Map<String, dynamic>>> checkboxGroups = {
    "Process": [
      {"title": "Hot Presentation", "value": false},
      {"title": "Cold Presentation", "value": false},
      {"title": "Disinfection", "value": false},
      {"title": "Soaking", "value": false},
      {"title": "Cool and Reheat", "value": false},
      {"title": "Receiving", "value": false},
    ],
    "Lists": [
      {"title": "Disinfection Assets", "value": false},
      {"title": "Cool and Reheat", "value": false},
      {"title": "Hot Presentation Assets", "value": false},
      {"title": "Cold Presentation Assets", "value": false},
      {"title": "Receiving Firms", "value": false},
    ],
    "Admin Panel": [
      {"title": "Personnel", "value": false},
      {"title": "Buffed Times", "value": false},
      {"title": "Role Configurations", "value": false},
      {"title": "Reports", "value": false},
    ],
    "Settings": [
      {"title": "Devices", "value": false},
      {"title": "Update User", "value": false},
    ],
  };

  // Function to handle checkbox state changes
  void _handleCheckboxChange(String group, int index, bool? value) {
    setState(() {
      checkboxGroups[group]![index]['value'] = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Role Submit"),
      ),
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

              const SizedBox(height: 20), // Adding some space before the submit button
              ElevatedButton(
                onPressed: () {
                  context.read<RoleConfigSubmitCubit>().submit(
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
                child: const Text("Submit"),
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