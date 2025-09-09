import 'package:acti_buddy/acti_buddy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRepository {
  SearchRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<Result<List<ActivityCategoryEntity>>>
  getAllActivityCategories() async {
    try {
      final snapshot = await _firestore
          .collection(FireStoreCollection.activityCategory)
          .get();

      final categories = snapshot.docs
          .map((doc) => ActivityCategory.fromDocument(doc).toEntity())
          .toList();

      return Success(categories);
    } on FirebaseException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        FirebaseException(plugin: 'cloud_firestore', message: e.toString()),
      );
    }
  }
}
