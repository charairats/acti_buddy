import 'package:acti_buddy/acti_buddy.dart';

abstract class ProfileRepository {
  Future<Result<ProfileEntity>> fetchProfile(String uid);
}
