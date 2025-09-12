import 'package:acti_buddy/core/core.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ActivitySortType {
  latest,
  popular,
}

class BrowseActivityRepositoryImpl implements BrowseActivityRepository {
  BrowseActivityRepositoryImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference get _activitiesCollection =>
      _firestore.collection(FireStoreCollection.activities);

  @override
  Future<List<ActivityEntity>> browseActivities({
    String? categoryId,
    ActivitySortType sortType = ActivitySortType.latest,
    String? excludeUserId,
    int limit = 20,
  }) async {
    try {
      Query query;

      // Simple query without orderBy to avoid index issues
      if (categoryId != null && categoryId.isNotEmpty) {
        // Query with category filter only
        query = _activitiesCollection
            .where('categoryId', isEqualTo: categoryId)
            .where('startDate', isGreaterThan: Timestamp.now());
      } else {
        // Query with date filter only
        query = _activitiesCollection.where(
          'startDate',
          isGreaterThan: Timestamp.now(),
        );
      }

      query = query.limit(limit * 3); // Get more to filter and sort client-side

      final querySnapshot = await query.get();

      // Filter client-side to avoid complex index requirements
      var filteredDocs = querySnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Filter out deleted activities
        if (data['deletedAt'] != null) return false;

        // Filter out cancelled activities
        if (data['cancelledAt'] != null) return false;

        // Filter out current user's activities
        if (excludeUserId != null && excludeUserId.isNotEmpty) {
          if (data['createdBy'] == excludeUserId) return false;
        }

        return true;
      }).toList();

      // Sort client-side for both latest and popular
      if (sortType == ActivitySortType.popular) {
        filteredDocs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aJoinCount = (aData['joinCount'] as int?) ?? 0;
          final bJoinCount = (bData['joinCount'] as int?) ?? 0;
          return bJoinCount.compareTo(aJoinCount); // Descending order
        });
      } else {
        // Sort by latest (soonest first)
        filteredDocs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aStartDate = (aData['startDate'] as Timestamp).toDate();
          final bStartDate = (bData['startDate'] as Timestamp).toDate();
          return aStartDate.compareTo(
            bStartDate,
          ); // Ascending order (soonest first)
        });
      }

      // Take only the required limit
      final resultDocs = filteredDocs.take(limit).toList();

      return resultDocs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ActivityEntity(
          id: doc.id,
          name: (data['name'] as String?) ?? '',
          description: (data['description'] as String?) ?? '',
          startDate: (data['startDate'] as Timestamp).toDate(),
          endDate: (data['endDate'] as Timestamp).toDate(),
          createdBy: (data['createdBy'] as String?) ?? '',
          participants: (data['participants'] as int?) ?? 0,
          currentParticipants: (data['currentParticipants'] as int?) ?? 0,
          joinCount: (data['joinCount'] as int?) ?? 0,
          viewCount: (data['viewCount'] as int?) ?? 0,
          categoryId: data['categoryId'] as String?,
          updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to browse activities: $e');
    }
  }

  @override
  Future<void> incrementViewCount(String activityId) async {
    try {
      await _activitiesCollection.doc(activityId).update({
        'viewCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignore view count errors
    }
  }
}

abstract class BrowseActivityRepository {
  Future<List<ActivityEntity>> browseActivities({
    String? categoryId,
    ActivitySortType sortType = ActivitySortType.latest,
    String? excludeUserId,
    int limit = 20,
  });

  Future<void> incrementViewCount(String activityId);
}
