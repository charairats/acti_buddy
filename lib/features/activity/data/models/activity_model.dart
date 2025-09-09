// activity.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class ActivityModel {
  const ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.hostId,
    required this.maxParticipants,
    this.isCompleted = false,
  });

  // Factory constructor from Firestore Document
  factory ActivityModel.fromDocument(DocumentSnapshot doc) {
    return ActivityModel(
      id: doc.id,
      title: doc['title'] as String,
      description: doc['description'] as String,
      date: (doc['date'] as Timestamp).toDate(),
      hostId: doc['userId'] as String,
      maxParticipants: doc['maxParticipants'] as int,
      isCompleted: doc['isCompleted'] as bool,
    );
  }
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String hostId;
  final int maxParticipants;
  final bool isCompleted;

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'hostId': hostId,
      'maxParticipants': maxParticipants,
      'isCompleted': isCompleted,
    };
  }
}
