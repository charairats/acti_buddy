class ProfileEntity {
  ProfileEntity({
    this.uid,
    this.name,
    this.username,
    this.caption,
    this.connection,
    this.activitiesjoined,
    this.followers,
  });

  final String? uid;
  final String? name;
  final String? username;
  final String? caption;
  final int? connection;
  final int? activitiesjoined;
  final int? followers;
}
