import 'package:acti_buddy/acti_buddy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityCategory {
  ActivityCategory({
    required this.id,
    required this.nameThai,
    required this.nameEnglish,
    required this.iconName,
  });

  factory ActivityCategory.fromDocument(DocumentSnapshot doc) {
    return ActivityCategory(
      id: doc.id,
      nameThai: doc['name_th'] as String,
      nameEnglish: doc['name_en'] as String,
      iconName: doc['icon'] as String,
    );
  }

  final String id;
  final String nameThai;
  final String nameEnglish;
  final String iconName;

  ActivityCategoryEntity toEntity() {
    return ActivityCategoryEntity(
      id: id,
      nameThai: nameThai,
      nameEnglish: nameEnglish,
      iconName: iconName,
    );
  }
}
