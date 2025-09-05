import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/features/profile/domain/entities/profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.firestore});

  final FirebaseFirestore firestore;

  @override
  Future<Result<ProfileEntity>> fetchProfile(String uid) async {
    try {
      final docSnapshot = firestore
          .collection(FireStoreCollection.profile)
          .doc(uid);
      final profile = await docSnapshot.get();

      if (profile.exists) {
        final data = ProfileModel.fromDocument(profile);
        return Success(data.toEntity());
      } else {
        return Failure(Exception('Profile not found'));
      }
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return Failure(Exception(e.toString()));
    }
  }
}
