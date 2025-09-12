class ActivityParticipantEntity {
  ActivityParticipantEntity({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.joinedAt,
    this.leftAt,
    this.status = ParticipantStatus.active,
  });

  final String id;
  final String activityId;
  final String userId;
  final DateTime joinedAt;
  final DateTime? leftAt;
  final ParticipantStatus status;
}

enum ParticipantStatus {
  active,
  left,
  removed,
}
