import 'package:acti_buddy/features/activity/domain/entities/activity_participant_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class ActivityParticipantModel {
  const ActivityParticipantModel({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.joinedAt,
    this.leftAt,
    this.status = ParticipantStatus.active,
  });

  factory ActivityParticipantModel.fromDocument(DocumentSnapshot doc) {
    return ActivityParticipantModel(
      id: doc.id,
      activityId: doc['activityId'] as String,
      userId: doc['userId'] as String,
      joinedAt: (doc['joinedAt'] as Timestamp).toDate(),
      leftAt: doc['leftAt'] != null
          ? (doc['leftAt'] as Timestamp).toDate()
          : null,
      status: ParticipantStatus.values.firstWhere(
        (status) => status.name == doc['status'],
        orElse: () => ParticipantStatus.active,
      ),
    );
  }

  final String id;
  final String activityId;
  final String userId;
  final DateTime joinedAt;
  final DateTime? leftAt;
  final ParticipantStatus status;

  Map<String, dynamic> toDocument() {
    return {
      'activityId': activityId,
      'userId': userId,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'leftAt': leftAt != null ? Timestamp.fromDate(leftAt!) : null,
      'status': status.name,
    };
  }

  ActivityParticipantEntity toEntity() {
    return ActivityParticipantEntity(
      id: id,
      activityId: activityId,
      userId: userId,
      joinedAt: joinedAt,
      leftAt: leftAt,
      status: status,
    );
  }
}
