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
    this.categoryId,
    this.currentParticipants = 0,
    this.joinCount = 0,
    this.viewCount = 0,
    this.cancelledAt,
    this.deletedAt,
    this.finishedAt,
    this.updatedAt,
    this.location,
  });

  // Factory constructor from Firestore Document
  factory ActivityModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    T getValue<T>(String key, T defaultValue) {
      if (data != null && data.containsKey(key)) {
        return data[key] as T;
      }
      return defaultValue;
    }

    return ActivityModel(
      id: doc.id,
      name: getValue<String>('name', ''),
      description: getValue<String>('description', ''),
      startDate: getValue<Timestamp>('startDate', Timestamp.now()).toDate(),
      endDate: getValue<Timestamp>('endDate', Timestamp.now()).toDate(),
      createdBy: getValue<String>('createdBy', ''),
      participants: getValue<int>('participants', 0),
      categoryId: getValue<String?>('categoryId', null),
      currentParticipants: getValue<int>('currentParticipants', 0),
      cancelledAt: getValue<Timestamp?>('cancelledAt', null)?.toDate(),
      deletedAt: getValue<Timestamp?>('deletedAt', null)?.toDate(),
      finishedAt: getValue<Timestamp?>('finishedAt', null)?.toDate(),
      updatedAt: getValue<Timestamp?>('updatedAt', null)?.toDate(),
      location: getValue<GeoPoint?>('location', null),
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
  final String? categoryId;
  final int currentParticipants;
  final int joinCount;
  final int viewCount;
  final GeoPoint? location;

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdBy': createdBy,
      'participants': participants,
      'categoryId': categoryId,
      'currentParticipants': currentParticipants,
      'joinCount': joinCount,
      'viewCount': viewCount,
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
      categoryId: categoryId,
      currentParticipants: currentParticipants,
      joinCount: joinCount,
      viewCount: viewCount,
      cancelledAt: cancelledAt,
      deletedAt: deletedAt,
      finishedAt: finishedAt,
      updatedAt: updatedAt,
      // location: location,
    );
  }
}
