import 'package:acti_buddy/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final storeProvider = FutureProvider<Store>((ref) async {
  final docsDir = await getApplicationDocumentsDirectory();
  return openStore(directory: p.join(docsDir.path, 'master-db'));
});
