import 'package:acti_buddy/features/profile/domain/entities/profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  ProfileModel({
    this.uid,
    this.name,
    this.username,
    this.caption,
    this.connection,
    this.activitiesjoined,
    this.followers,
  });

  factory ProfileModel.fromDocument(DocumentSnapshot doc) {
    return ProfileModel(
      uid: doc['uid'] as String?,
      name: doc['name'] as String?,
      username: doc['username'] as String?,
      caption: doc['caption'] as String?,
      connection: doc['connection'] as int?,
      activitiesjoined: doc['activitiesjoined'] as int?,
      followers: doc['followers'] as int?,
    );
  }

  final String? uid;
  final String? name;
  final String? username;
  final String? caption;
  final int? connection;
  final int? activitiesjoined;
  final int? followers;

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'caption': caption,
      'connection': connection,
      'activitiesjoined': activitiesjoined,
      'followers': followers,
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      uid: uid,
      name: name,
      username: username,
      caption: caption,
      connection: connection,
      activitiesjoined: activitiesjoined,
      followers: followers,
    );
  }
}
