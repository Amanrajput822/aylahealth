import 'package:path_provider/path_provider.dart';
Future<void> deleteCacheDir() async {
  print('_deleteCacheDir');
  final cacheDir = await getTemporaryDirectory();

  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
}

Future<void> deleteAppDir() async {
  print('_deleteAppDir');
  final appDir = await getApplicationSupportDirectory();

  if(appDir.existsSync()){
    appDir.deleteSync(recursive: true);
  }
}