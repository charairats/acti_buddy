import 'package:acti_buddy/features/activity/domain/entities/activity_participant_entity.dart';

abstract interface class ActivityParticipantRepository {
  Future<void> joinActivity(String activityId, String userId);
  Future<void> leaveActivity(String activityId, String userId);
  Future<List<ActivityParticipantEntity>> getActivityParticipants(
    String activityId,
  );
  Future<List<ActivityParticipantEntity>> getUserJoinedActivities(
    String userId,
  );
  Future<bool> isUserJoined(String activityId, String userId);
  Future<int> getParticipantCount(String activityId);
}
