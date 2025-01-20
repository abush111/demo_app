import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicele/database/globalconfigurtions.dart';
import 'package:vehicele/model/vehicel_status.dart';

class UserFirebase {
  final DatabaseReference _databaseReference = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: GlobalConfiguration().getValue('databaseURL'),
  ).ref();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> Addvehiclestatusr(VehicleStatusModel user) async {
    String? token = await _getToken();
    if (token != null) {
      // Use a valid identifier, such as a Firebase UID instead of the token
      user.uid = token; // If you still want to use the token, consider hashing it or generating a new ID
      final DatabaseReference userRef =
          _databaseReference.child('vehicles').child(user.uid);
      await userRef.set(user.toJson());
    } else {
      throw Exception("No token found.");
    }
  }

  Future<void>updateVehiclestatus(VehicleStatusModel user) async {
    String? token = await _getToken();
    if (token != null) {
      if (user.uid.isEmpty) {
        user.uid = token; // Ensure the UID is set to the predefined value
      }
      final DatabaseReference userRef =
          _databaseReference.child('vehicles').child(user.uid);
      await userRef.update(user.toJson());
    } else {
      throw Exception("No token found.");
    }
  }

  Future<void> deleteVehiclestatus(String uid) async {
    String? token = await _getToken();
    if (token != null) {
      await _databaseReference
          .child('vehicles')
          .child(token)
          .remove(); // Use the UID for deletion
    } else {
      throw Exception("No token found.");
    }
  }

  Future<List<VehicleStatusModel>> fetchAllVehicles() async {
    final DatabaseEvent event =
        await _databaseReference.child('vehicles').once();
    final DataSnapshot snapshot =
        event.snapshot; // Get the snapshot from the event

    if (snapshot.value != null) {
      Map<dynamic, dynamic> vehiclesMap =
          snapshot.value as Map<dynamic, dynamic>;
      return vehiclesMap.entries.map((entry) {
        return VehicleStatusModel.fromJson(
            Map<String, dynamic>.from(entry.value));
      }).toList();
    } else {
      return []; // Return an empty list if no vehicles are found
    }
  }
}