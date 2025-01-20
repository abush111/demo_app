import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicele/database/firebase_service.dart';
import 'package:vehicele/model/vehicel_status.dart';

class DetailWidget extends StatefulWidget {
  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  final UserFirebase _userFirebase = UserFirebase();
  final List<VehicleStatusModel> _vehicleStatusList = [];

  final _fuelLevelController = TextEditingController();
  final _batteryLevelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final vehicles = await _userFirebase.fetchAllVehicles();
      setState(() {
        _vehicleStatusList.clear();
        _vehicleStatusList.addAll(vehicles);
      });
    } catch (e) {
      print('Error fetching vehicle details: $e');
    }
  }

  Future<void> _addOrUpdateVehicleDetail({VehicleStatusModel? detail}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('auth_token');

    VehicleStatusModel newDetail = VehicleStatusModel(
      uid: "${action}",
      fuelLevel: _fuelLevelController.text,
      batteryLevel: _batteryLevelController.text,
      updatedOn: DateTime.now().millisecondsSinceEpoch,
    );

    if (detail == null) {
      await _userFirebase.Addvehiclestatusr(newDetail);
    } else {
      newDetail.uid = detail.uid; // Update existing vehicle
      await _userFirebase.updateVehiclestatus(newDetail);
    }

    _fetchUserDetails();
    Navigator.of(context).pop(); // Close the dialog
  }

  void _showAddUpdateDialog({VehicleStatusModel? detail}) {
    if (detail != null) {
      _fuelLevelController.text = detail.fuelLevel;
      _batteryLevelController.text = detail.batteryLevel!;
    } else {
      _fuelLevelController.clear();
      _batteryLevelController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(detail == null ? 'Add Vehicle' : 'Update Vehicle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _fuelLevelController,
                  decoration: InputDecoration(
                    labelText: 'Fuel Level (liters)',
                    hintText: 'Enter fuel level in liters',
                  ),
                  keyboardType: TextInputType.number, // Numeric input
                ),
                TextField(
                  controller: _batteryLevelController,
                  decoration: InputDecoration(
                    labelText: 'Battery Level (%)',
                    hintText: 'Enter battery level in percentage',
                  ),
                  keyboardType: TextInputType.number, // Numeric input
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addOrUpdateVehicleDetail(detail: detail);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(detail == null ? 'Add' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    ).whenComplete(() {
      // Clear the text fields when the dialog is dismissed
      _fuelLevelController.clear();
      _batteryLevelController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              children: [
                SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: _vehicleStatusList.length,
                    itemBuilder: (context, index) {
                      final detail = _vehicleStatusList[index];
                      return ListTile(
                        title: Text('Fuel Level: ${detail.fuelLevel} liters',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'Battery Level: ${detail.batteryLevel} %',
                            style: TextStyle(fontSize: 16)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  _showAddUpdateDialog(detail: detail),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmation(context, detail);
                              },
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.all(16.0),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () => _showAddUpdateDialog(),
                child: Icon(Icons.add),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteVehicleDetail(VehicleStatusModel detail) async {
    await _userFirebase.deleteVehiclestatus(
        detail.uid); // Assuming deleteVehiclestatus takes uid
    _fetchUserDetails();
  }

  void _showDeleteConfirmation(
      BuildContext context, VehicleStatusModel detail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _deleteVehicleDetail(detail);
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Item deleted successfully.')),
                );
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
