import 'package:flutter/services.dart';

import 'artifact_data.dart';

const supportedArtifactImageExtensions = [
  'jpg',
  'jpeg',
  'png',
  'webp',
  'gif',
  'bmp',
  'wbmp',
];

final Map<String, Future<String?>> _comparisonImageCache = {};
final Map<String, Future<bool>> _reconstructionReadyCache = {};

Future<String?> findArtifactComparisonImage(Artifact artifact, String side) {
  final key = '${artifact.imageAsset}:$side';
  return _comparisonImageCache.putIfAbsent(key, () async {
    final filename = artifact.imageAsset.split('/').last;
    final extensionIndex = filename.lastIndexOf('.');
    final imageStem = extensionIndex < 0
        ? filename
        : filename.substring(0, extensionIndex);

    for (final extension in supportedArtifactImageExtensions) {
      final assetPath =
          'assets/images/artifacts/$side/$imageStem.$extension';
      try {
        await rootBundle.load(assetPath);
        return assetPath;
      } catch (_) {
        // Optional comparison images may not have been added yet.
      }
    }
    return null;
  });
}

Future<bool> hasArtifactReconstructionImages(Artifact artifact) {
  if (artifact.reconstruction != null) {
    return Future.value(artifact.restoreAvailable);
  }
  return _reconstructionReadyCache.putIfAbsent(artifact.imageAsset, () async {
    final pair = await Future.wait([
      findArtifactComparisonImage(artifact, 'before'),
      findArtifactComparisonImage(artifact, 'after'),
    ]);
    return pair.every((path) => path != null);
  });
}
