import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/features/activity/data/models/activity_participant_model.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_participant_entity.dart';
import 'package:acti_buddy/features/activity/domain/repositories/activity_participant_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityParticipantRepositoryImpl
    implements ActivityParticipantRepository {
  ActivityParticipantRepositoryImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference get _participantsCollection =>
      _firestore.collection('activity_participants');

  CollectionReference get _activitiesCollection =>
      _firestore.collection(FireStoreCollection.activities);

  @override
  Future<void> joinActivity(String activityId, String userId) async {
    final batch = _firestore.batch();

    try {
      // Check if user already joined
      final existingParticipant = await _participantsCollection
          .where('activityId', isEqualTo: activityId)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: ParticipantStatus.active.name)
          .get();

      if (existingParticipant.docs.isNotEmpty) {
        throw Exception('User already joined this activity');
      }

      // Get current participant count
      final activityDoc = await _activitiesCollection.doc(activityId).get();
      if (!activityDoc.exists) {
        throw Exception('Activity not found');
      }

      final activityData = activityDoc.data() as Map<String, dynamic>;
      final maxParticipants = activityData['participants'] as int;
      final currentParticipants =
          (activityData['currentParticipants'] as int?) ?? 0;

      if (currentParticipants >= maxParticipants) {
        throw Exception('Activity is full');
      }

      // Add participant
      final participantDoc = _participantsCollection.doc();
      final participant = ActivityParticipantModel(
        id: participantDoc.id,
        activityId: activityId,
        userId: userId,
        joinedAt: DateTime.now(),
      );

      batch.set(participantDoc, participant.toDocument());

      // Update activity counts
      batch.update(_activitiesCollection.doc(activityId), {
        'currentParticipants': FieldValue.increment(1),
        'joinCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to join activity: $e');
    }
  }

  @override
  Future<void> leaveActivity(String activityId, String userId) async {
    final batch = _firestore.batch();

    try {
      // Find active participant record
      final participantQuery = await _participantsCollection
          .where('activityId', isEqualTo: activityId)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: ParticipantStatus.active.name)
          .get();

      if (participantQuery.docs.isEmpty) {
        throw Exception('User is not a participant of this activity');
      }

      // Update participant status
      final participantDoc = participantQuery.docs.first;
      batch.update(participantDoc.reference, {
        'status': ParticipantStatus.left.name,
        'leftAt': FieldValue.serverTimestamp(),
      });

      // Update activity count
      batch.update(_activitiesCollection.doc(activityId), {
        'currentParticipants': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to leave activity: $e');
    }
  }

  @override
  Future<List<ActivityParticipantEntity>> getActivityParticipants(
    String activityId,
  ) async {
    try {
      final querySnapshot = await _participantsCollection
          .where('activityId', isEqualTo: activityId)
          .where('status', isEqualTo: ParticipantStatus.active.name)
          .orderBy('joinedAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => ActivityParticipantModel.fromDocument(doc).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get activity participants: $e');
    }
  }

  @override
  Future<List<ActivityParticipantEntity>> getUserJoinedActivities(
    String userId,
  ) async {
    try {
      final querySnapshot = await _participantsCollection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: ParticipantStatus.active.name)
          .orderBy('joinedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ActivityParticipantModel.fromDocument(doc).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get user joined activities: $e');
    }
  }

  @override
  Future<bool> isUserJoined(String activityId, String userId) async {
    try {
      final querySnapshot = await _participantsCollection
          .where('activityId', isEqualTo: activityId)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: ParticipantStatus.active.name)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> getParticipantCount(String activityId) async {
    try {
      final querySnapshot = await _participantsCollection
          .where('activityId', isEqualTo: activityId)
          .where('status', isEqualTo: ParticipantStatus.active.name)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }
}
