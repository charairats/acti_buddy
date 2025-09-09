import 'package:acti_buddy/acti_buddy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}
