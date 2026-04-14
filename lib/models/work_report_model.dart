import 'package:cloud_firestore/cloud_firestore.dart';

class WorkReportModel {
  final String id;
  final String userId;
  final String task;
  final String location;
  final String? locationDetails;
  final GeoPoint? geoLocation;
  final DateTime date;
  final String ip;
  final String country;
  final String city;
  final String department;
  final String subDepartment;
  final String? imageUrl;
  final Map<String, dynamic>? additionalData;

  WorkReportModel({
    required this.id,
    required this.userId,
    required this.task,
    required this.location,
    this.locationDetails,
    this.geoLocation,
    required this.date,
    required this.ip,
    required this.country,
    required this.city,
    required this.department,
    required this.subDepartment,
    this.imageUrl,
    this.additionalData,
  });

  factory WorkReportModel.fromMap(Map<String, dynamic> data, String id) {
    return WorkReportModel(
      id: id,
      userId: data['userId'] ?? '',
      task: data['task'] ?? '',
      location: data['location'] ?? '',
      locationDetails: data['locationDetails'],
      geoLocation: data['geoLocation'] as GeoPoint?,
      date: (data['date'] as Timestamp).toDate(),
      ip: data['ip'] ?? '',
      country: data['country'] ?? '',
      city: data['city'] ?? '',
      department: data['department'] ?? '',
      subDepartment: data['subDepartment'] ?? '',
      imageUrl: data['imageUrl'],
      additionalData: data['additionalData'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'task': task,
      'location': location,
      'locationDetails': locationDetails,
      'geoLocation': geoLocation,
      'date': Timestamp.fromDate(date),
      'ip': ip,
      'country': country,
      'city': city,
      'department': department,
      'subDepartment': subDepartment,
      'imageUrl': imageUrl,
      'additionalData': additionalData,
    };
  }

  // Helper methods to get attendance data
  int get maleAttendance =>
      (additionalData?['maleAttendance'] as num?)?.toInt() ?? 0;
  int get femaleAttendance =>
      (additionalData?['femaleAttendance'] as num?)?.toInt() ?? 0;
  int get youthAttendance =>
      (additionalData?['youthAttendance'] as num?)?.toInt() ?? 0;
  int get totalAttendance =>
      maleAttendance + femaleAttendance + youthAttendance;
  String get description => additionalData?['description'] as String? ?? '';
  String get remarks => additionalData?['remarks'] as String? ?? '';

  /// Convert WorkReportModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'task': task,
      'location': location,
      'locationDetails': locationDetails,
      'geoLocation': geoLocation != null
          ? {
        'latitude': geoLocation!.latitude,
        'longitude': geoLocation!.longitude,
      }
          : null,
      'date': date.toIso8601String(),
      'ip': ip,
      'country': country,
      'city': city,
      'department': department,
      'subDepartment': subDepartment,
      'imageUrl': imageUrl,
      'additionalData': additionalData,
    };
  }

  // Convert JSON to WorkReportModel
  factory WorkReportModel.fromJson(Map<String, dynamic> json) {
    return WorkReportModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      task: json['task'] as String,
      location: json['location'] as String,
      locationDetails: json['locationDetails'] as String?,
      geoLocation: json['geoLocation'] != null
          ? GeoPoint(
        (json['geoLocation']['latitude'] as num).toDouble(),
        (json['geoLocation']['longitude'] as num).toDouble(),
      )
          : null,
      date: DateTime.parse(json['date'] as String),
      ip: json['ip'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      department: json['department'] as String,
      subDepartment: json['subDepartment'] as String,
      imageUrl: json['imageUrl'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }

}
