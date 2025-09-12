import 'package:acti_buddy/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:acti_buddy/features/activity/data/repositories/activity_participant_repository_impl.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_participant_entity.dart';
import 'package:acti_buddy/features/activity/domain/repositories/activity_participant_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityParticipantRepositoryProvider =
    Provider<ActivityParticipantRepository>((ref) {
      return ActivityParticipantRepositoryImpl(
        firestore: FirebaseFirestore.instance,
      );
    });

// Provider for joining an activity
final joinActivityProvider = FutureProvider.family<void, String>((
  ref,
  activityId,
) async {
  final repository = ref.read(activityParticipantRepositoryProvider);
  final user = ref.read(authStateProvider).value;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  await repository.joinActivity(activityId, user.uid);
});

// Provider for leaving an activity
final leaveActivityProvider = FutureProvider.family<void, String>((
  ref,
  activityId,
) async {
  final repository = ref.read(activityParticipantRepositoryProvider);
  final user = ref.read(authStateProvider).value;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  await repository.leaveActivity(activityId, user.uid);
});

// Provider for checking if user has joined an activity
final isUserJoinedProvider = FutureProvider.family<bool, String>((
  ref,
  activityId,
) async {
  final repository = ref.read(activityParticipantRepositoryProvider);
  final user = ref.read(authStateProvider).value;

  if (user == null) return false;

  return repository.isUserJoined(activityId, user.uid);
});

// Provider for getting activity participants
final activityParticipantsProvider =
    FutureProvider.family<List<ActivityParticipantEntity>, String>((
      ref,
      activityId,
    ) async {
      final repository = ref.read(activityParticipantRepositoryProvider);
      return repository.getActivityParticipants(activityId);
    });

// Provider for getting user's joined activities
final userJoinedActivitiesProvider =
    FutureProvider<List<ActivityParticipantEntity>>((ref) async {
      final repository = ref.read(activityParticipantRepositoryProvider);
      final user = ref.read(authStateProvider).value;

      if (user == null) return [];

      return repository.getUserJoinedActivities(user.uid);
    });

// Provider for getting participant count
final participantCountProvider = FutureProvider.family<int, String>((
  ref,
  activityId,
) async {
  final repository = ref.read(activityParticipantRepositoryProvider);
  return repository.getParticipantCount(activityId);
});
