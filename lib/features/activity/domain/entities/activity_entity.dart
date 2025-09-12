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
  final int participants;
  final String? categoryId;
  final DateTime? cancelledAt;
  final DateTime? deletedAt;
  final DateTime? finishedAt;
  final DateTime? updatedAt;
}
