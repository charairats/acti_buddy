class ActivityEntity {
  ActivityEntity({
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
  });

  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String createdBy;
  final int participants; // Max participants
  final String? categoryId;
  final int currentParticipants; // Current joined participants
  final int joinCount; // Total joins (including left participants)
  final int viewCount; // View count for popularity
  final DateTime? cancelledAt;
  final DateTime? deletedAt;
  final DateTime? finishedAt;
  final DateTime? updatedAt;

  bool get isFull => currentParticipants >= participants;
  bool get canJoin =>
      !isFull && cancelledAt == null && endDate.isAfter(DateTime.now());
}
