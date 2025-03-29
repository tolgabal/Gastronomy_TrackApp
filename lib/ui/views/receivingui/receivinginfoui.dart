import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/entity/receivingasset.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';

class ReceivingInfoUI extends StatefulWidget {
  final ReceivingAsset asset;
  final User user;
  final Role userRole;

  const ReceivingInfoUI(this.asset, this.user, this.userRole, {super.key});
  @override
  _ReceivingAssetFormState createState() => _ReceivingAssetFormState();
}

class _ReceivingAssetFormState extends State<ReceivingInfoUI> {
  // Controllers for text fields
  final TextEditingController recDateController = TextEditingController();
  final TextEditingController firmIdController = TextEditingController();
  final TextEditingController assetNameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController prodDateController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();
  final TextEditingController seriNumController = TextEditingController();
  final TextEditingController fatNumController = TextEditingController();
  final TextEditingController assetQuantController = TextEditingController();
  final TextEditingController carHeatController = TextEditingController();
  final TextEditingController assetHeatController = TextEditingController();
  final TextEditingController personnelController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String carHygene = 'Uygun';
  String labelCond = 'Uygun';
  String quantType = 'KG';
  String agreement = 'Kabul';
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Homepage(user: widget.user, userRole: widget.userRole),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(index);
    });
  }


  // Method to pick date
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receiving Asset Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildTextField(recDateController, 'Rec. Date')),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      setState(() {
                        recDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                      });
                    },
                  ),
                ],
              ),
              _buildTextField(firmIdController, 'Firm ID'),
              _buildTextField(assetNameController, 'Asset Name'),
              _buildTextField(brandController, 'Brand'),
              _buildDatePickerField(prodDateController, 'Production Date'),
              _buildDatePickerField(expDateController, 'Expiry Date'),
              _buildTextField(seriNumController, 'Serial Number'),
              _buildTextField(fatNumController, 'Factory Number'),

              // Car Hygiene Radio Button
              _buildRadioField('Car Hygiene', ['Uygun', 'Uygun Değil'], carHygene, (val) {
                setState(() {
                  carHygene = val!;
                });
              }),

              // Label Condition Radio Button
              _buildRadioField('Label Condition', ['Uygun', 'Uygun Değil'], labelCond, (val) {
                setState(() {
                  labelCond = val!;
                });
              }),

              Row(
                children: [
                  Expanded(child: _buildTextField(assetQuantController, 'Asset Quantity', isNumeric: true)),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: quantType,
                    onChanged: (String? newValue) {
                      setState(() {
                        quantType = newValue!;
                      });
                    },
                    items: <String>['KG', 'Adet', 'Bağ', 'Karton'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),

              _buildTextField(carHeatController, 'Car Heat (°C)', isNumeric: true),
              _buildTextField(assetHeatController, 'Asset Heat (°C)', isNumeric: true),

              // Agreement button toggle
              _buildToggleButtons(),

              _buildTextField(personnelController, 'Personnel'),
              _buildTextField(noteController, 'Note'),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Submit action
                  _submitForm();
                },
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
              bottomNavigationBar: CustomBottomNavigationBar(
    currentIndex: _selectedIndex,
    onTap: _onItemTapped,),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          _selectDate(context, controller);
        },
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: label,
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioField(String label, List<String> options, String groupValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Row(
            children: options.map((option) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: groupValue,
                  onChanged: onChanged,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ToggleButtons(
        isSelected: [
          agreement == 'Kabul',
          agreement == 'Şartlı Kabul',
          agreement == 'Red'
        ],
        onPressed: (int index) {
          setState(() {
            if (index == 0) agreement = 'Kabul';
            if (index == 1) agreement = 'Şartlı Kabul';
            if (index == 2) agreement = 'Red';
          });
        },
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Kabul'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Şartlı Kabul'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Red'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    // You can handle form submission here
    print('Rec. Date: ${recDateController.text}');
    print('Firm ID: ${firmIdController.text}');
    print('Asset Name: ${assetNameController.text}');
    print('Brand: ${brandController.text}');
    print('Production Date: ${prodDateController.text}');
    print('Expiry Date: ${expDateController.text}');
    print('Serial Number: ${seriNumController.text}');
    print('Factory Number: ${fatNumController.text}');
    print('Car Hygiene: $carHygene');
    print('Label Condition: $labelCond');
    print('Asset Quantity: ${assetQuantController.text}');
    print('Quantity Type: $quantType');
    print('Car Heat: ${carHeatController.text}');
    print('Asset Heat: ${assetHeatController.text}');
    print('Agreement: $agreement');
    print('Personnel: ${personnelController.text}');
    print('Note: ${noteController.text}');
  }

  @override
  void dispose() {
    recDateController.dispose();
    firmIdController.dispose();
    assetNameController.dispose();
    brandController.dispose();
    prodDateController.dispose();
    expDateController.dispose();
    seriNumController.dispose();
    fatNumController.dispose();
    assetQuantController.dispose();
    carHeatController.dispose();
    assetHeatController.dispose();
    personnelController.dispose();
    noteController.dispose();
    super.dispose();
  }
}