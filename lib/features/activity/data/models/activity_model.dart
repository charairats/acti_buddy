// activity.dart
import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class ActivityModel {
  const ActivityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.createdBy,
    required this.participants,
    this.cancelledAt,
    this.deletedAt,
    this.finishedAt,
    this.updatedAt,
    this.location,
  });

  // Factory constructor from Firestore Document
  factory ActivityModel.fromDocument(DocumentSnapshot doc) {
    return ActivityModel(
      id: doc.id,
      name: doc['name'] as String,
      description: doc['description'] as String,
      startDate: (doc['startDate'] as Timestamp).toDate(),
      endDate: (doc['endDate'] as Timestamp).toDate(),
      createdBy: doc['createdBy'] as String,
      participants: doc['participants'] as int,
      cancelledAt: doc['cancelledAt'] != null
          ? (doc['cancelledAt'] as Timestamp).toDate()
          : null,
      deletedAt: doc['deletedAt'] != null
          ? (doc['deletedAt'] as Timestamp).toDate()
          : null,
      finishedAt: doc['finishedAt'] != null
          ? (doc['finishedAt'] as Timestamp).toDate()
          : null,
      updatedAt: doc['updatedAt'] != null
          ? (doc['updatedAt'] as Timestamp).toDate()
          : null,
      location: doc['location'] as GeoPoint?,
    );
  }

  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? cancelledAt;
  final DateTime? deletedAt;
  final DateTime? finishedAt;
  final DateTime? updatedAt;
  final String createdBy;
  final int participants;
  final GeoPoint? location;

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdBy': createdBy,
      'participants': participants,
      'cancelledAt': cancelledAt != null
          ? Timestamp.fromDate(cancelledAt!)
          : null,
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
      'finishedAt': finishedAt != null ? Timestamp.fromDate(finishedAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'location': location,
    };
  }

  ActivityEntity toEntitity() {
    return ActivityEntity(
      id: id,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      createdBy: createdBy,
      participants: participants,
      cancelledAt: cancelledAt,
      deletedAt: deletedAt,
      finishedAt: finishedAt,
      updatedAt: updatedAt,
      // location: location,
    );
  }
}
