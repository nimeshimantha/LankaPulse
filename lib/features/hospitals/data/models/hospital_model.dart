import 'package:equatable/equatable.dart';

class Hospital extends Equatable {
  final String id;
  final String name;
  final String type; // 'Government' or 'Private'
  final String address;
  final String phone;
  final String emergencyPhone;
  final String distance;
  final String operatingHours;
  final bool hasIcu;
  final bool hasAmbulance;
  final double latitude;
  final double longitude;

  const Hospital({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.phone,
    required this.emergencyPhone,
    required this.distance,
    required this.operatingHours,
    required this.hasIcu,
    required this.hasAmbulance,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [id, name, type, phone, distance];
}
