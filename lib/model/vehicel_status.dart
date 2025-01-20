import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleStatusModel {
  String uid;
  String? batteryLevel; // Fixed spelling for consistency
  String fuelLevel;

  int? updatedOn;
  LatLng? location;

 // Fixed naming convention

  VehicleStatusModel({
    required this.uid,
    required this.fuelLevel, // Added required for fuelLevel
    this.batteryLevel,
    this.location,
    this.updatedOn,

  });

  factory VehicleStatusModel.fromJson(Map<String, dynamic> json) {
    return VehicleStatusModel(
      uid: json['uid'] ?? '',
      fuelLevel: json['fuellevel'] ?? '', // Added fuelLevel from JSON
      batteryLevel: json['betterylevel'], // Fixed spelling and added battery level
      updatedOn: json['updatedOn'] != null ? int.tryParse(json['updatedOn'].toString()) : null,
      location: json['location'] != null
          ? LatLng(json['location']['latitude'], json['location']['longitude'])
          : const LatLng(36.1716, 115.1391),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'uid': uid,
      'fuellevel': fuelLevel, // Added fuelLevel to JSON output
      'betterylevel': batteryLevel, // Included battery level in JSON
      'updatedOn': updatedOn,
      'location': location != null
          ? {'latitude': location!.latitude, 'longitude': location!.longitude}
          : null,
    };

    return data;
  }
}