import 'dart:io';

import 'package:acti_buddy/acti_buddy.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteStorageProvider = Provider<RemoteStorage>((ref) {
  final storage = ref.watch(firebaseStorageProvider);
  return RemoteStorage(storage);
});

class RemoteStorage {
  RemoteStorage(this._storage);

  final FirebaseStorage _storage;

  Future<String> uploadFile(File file, String path) async {
    try {
      final storageRef = _storage.ref(path);
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (ex) {
      throw Exception('Failed to upload file: ${ex.message}');
    }
  }
}
