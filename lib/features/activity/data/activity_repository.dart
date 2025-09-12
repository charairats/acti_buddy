import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ActivityRepository {
  ActivityRepository({required this.firestore});

  final FirebaseFirestore firestore;
  // final FirebaseStorage storage;

  ///Add activity to Firestore
  Future<void> addActivity(Map<String, dynamic> activityData) async {
    await firestore
        .collection(FireStoreCollection.activities)
        .add(activityData);

    // await storage.ref(activityData['imagePath']).putFile(activityData['imageFile']);
  }

  /// Get activities by user ID
  Future<Result<List<ActivityEntity>>> getActivitiesByUser(
    String userId,
  ) async {
    try {
      final snapshot = await firestore
          .collection(FireStoreCollection.activities)
          .where('createdBy', isEqualTo: userId)
          .orderBy('startDate', descending: false)
          .get();

      final activities = snapshot.docs.map(ActivityModel.fromDocument).toList();

      return Success(activities.map((model) => model.toEntitity()).toList());
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return Failure(e);
    } catch (e) {
      debugPrint(e.toString());
      return Failure(
        FirebaseException(plugin: 'cloud_firestore', message: e.toString()),
      );
    }
  }

  /// Cancel activity
  Future<Result<void>> cancelActivity(String activityId) async {
    try {
      await firestore
          .collection(FireStoreCollection.activities)
          .doc(activityId)
          .update({
            'cancelledAt': Timestamp.now(),
            'updatedAt': Timestamp.now(),
          });

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        FirebaseException(plugin: 'cloud_firestore', message: e.toString()),
      );
    }
  }

  /// Delete activity
  Future<Result<void>> deleteActivity(String activityId) async {
    try {
      await firestore
          .collection(FireStoreCollection.activities)
          .doc(activityId)
          .update({
            'deletedAt': Timestamp.now(),
            'updatedAt': Timestamp.now(),
          });

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        FirebaseException(plugin: 'cloud_firestore', message: e.toString()),
      );
    }
  }

  /// Permanently delete activity (hard delete)
  Future<Result<void>> permanentlyDeleteActivity(String activityId) async {
    try {
      await firestore
          .collection(FireStoreCollection.activities)
          .doc(activityId)
          .delete();

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        FirebaseException(plugin: 'cloud_firestore', message: e.toString()),
      );
    }
  }
}
