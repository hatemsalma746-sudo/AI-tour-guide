import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_language.dart';
import 'artifact_data.dart';
import 'artifact_ui.dart';

class ArtifactLocationScreen extends StatelessWidget {
  const ArtifactLocationScreen({super.key, required this.artifact});

  final Artifact? artifact;

  @override
  Widget build(BuildContext context) => TourPageShell(
    title: 'Where is it now?',
    centerTitle: true,
    fullWidth: true,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final item = artifact;
        if (item == null) {
          return Center(
            child: Text(
              tourText(
                context,
                'Artifact details are unavailable.',
                'تفاصيل القطعة الأثرية غير متاحة.',
              ),
              style: const TextStyle(color: tourMuted),
            ),
          );
        }

        final arabic = isArabic(context);
        final name = (arabic ? item.arabicName : item.name).trim();
        final dynasty = (arabic ? item.arabicDynasty : item.dynasty).trim();
        final period = (arabic ? item.arabicPeriod : item.period).trim();
        final subtitleParts = [dynasty, period]
            .where((value) => value.isNotEmpty)
            .toList();
        final subtitle = subtitleParts.isEmpty
            ? tourText(context, 'Artifact information', 'بيانات القطعة')
            : subtitleParts.join(' · ');
        final city = _museumCity(item.museum, arabic);
        final location = _currentLocation(item.museum, arabic);
        final museumName = _firstFilled([
              arabic ? item.arabicMuseum : item.museum,
              item.museum,
            ]) ??
            tourText(
              context,
              'Museum location not documented',
              'موقع المتحف غير موثق',
            );
        final discovery = _firstFilled([
          arabic ? item.arabicDiscovery : item.discovery,
        ]);
        final story = _firstFilled([
          arabic ? item.arabicLocationStory : item.locationStory,
          arabic ? item.arabicRemovalInformation : item.removalInformation,
        ]) ??
            tourText(
              context,
              discovery == null
                  ? 'Current recorded location: $location.'
                  : 'Discovered at $discovery; current recorded location: $location.',
              discovery == null
                  ? 'المكان المسجل حاليًا: $location.'
                  : 'اكتُشفت في $discovery، ومكانها المسجل حاليًا: $location.',
            );
        final removalYear = _firstFilled([item.removalYear]) ??
            tourText(context, 'Not documented', 'غير موثقة');
        final imageWidth = (constraints.maxWidth * .25)
            .clamp(74.0, 94.0)
            .toDouble();

        return SizedBox(
          width: double.infinity,
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ArtifactHeaderCard(
                    artifact: item,
                    name: name.isEmpty
                        ? tourText(context, 'Artifact', 'قطعة أثرية')
                        : name,
                    subtitle: subtitle,
                  imageWidth: imageWidth,
                ),
                  _LocationDataSection(
                    label: tourText(
                      context,
                      'Current location',
                      'المكان الحالي',
                    ),
                    value: location,
                  ),
                  _LocationDataSection(
                    label: tourText(context, 'Year of removal', 'سنة النقل'),
                    value: removalYear,
                  ),
                  _LocationDataSection(
                    label: tourText(context, 'Story', 'القصة'),
                    value: story,
                    muted: true,
                  ),
                  _MuseumCard(
                    artifact: item,
                    city: city,
                    museumName: museumName,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  static String _currentLocation(String museum, bool arabic) => switch (museum) {
    'Grand Egyptian Museum, Giza' => arabic
        ? 'المتحف المصري الكبير، الجيزة، مصر'
        : 'Grand Egyptian Museum, Giza, Egypt',
    'Egyptian Museum, Cairo' => arabic
        ? 'المتحف المصري، القاهرة، مصر'
        : 'Egyptian Museum, Cairo, Egypt',
    _ => museum.trim().isEmpty
        ? (arabic ? 'المكان غير موثق' : 'Location not documented')
        : museum.trim(),
  };

  static String _museumCity(String museum, bool arabic) => switch (museum) {
    'Grand Egyptian Museum, Giza' => arabic ? 'الجيزة' : 'Giza',
    'Egyptian Museum, Cairo' => arabic ? 'القاهرة' : 'Cairo',
    _ => arabic ? 'الموقع غير موثق' : 'Location not documented',
  };
}

String? _firstFilled(Iterable<String?> values) {
  for (final value in values) {
    final trimmed = value?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;
  }
  return null;
}

class _ArtifactHeaderCard extends StatelessWidget {
  const _ArtifactHeaderCard({
    required this.artifact,
    required this.name,
    required this.subtitle,
    required this.imageWidth,
  });

  final Artifact artifact;
  final String name;
  final String subtitle;
  final double imageWidth;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: tourRaised,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xff403b30)),
    ),
    child: Row(
      children: [
        SizedBox(
          width: imageWidth,
          height: 100,
          child: ArtifactPhoto(
            assetPath: artifact.imageAsset,
            imageUrl: artifact.imageUrl,
            color: Color(artifact.color),
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: tourCream,
                  fontFamily: 'serif',
                  fontSize: responsiveFontSize(context, 24),
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: tourMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _LocationDataSection extends StatelessWidget {
  const _LocationDataSection({
    required this.label,
    required this.value,
    this.muted = false,
  });

  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: tourMuted, fontSize: 11)),
      const SizedBox(height: 3),
      Text(
        value,
        style: TextStyle(
          color: muted ? tourMuted : tourCream,
          fontSize: 14,
          height: muted ? 1.45 : null,
        ),
      ),
    ],
  );
}

class _MuseumCard extends StatelessWidget {
  const _MuseumCard({
    required this.artifact,
    required this.city,
    required this.museumName,
  });

  final Artifact artifact;
  final String city;
  final String museumName;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: tourRaised,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xff403b30)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.circle, color: Color(0xff4388c9), size: 9),
            const SizedBox(width: 8),
            Text(city, style: const TextStyle(color: tourMuted, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          museumName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: tourCream,
            fontFamily: 'serif',
            fontSize: responsiveFontSize(context, 22),
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MuseumFacadePhoto(
                artifact: artifact,
                assetPath: _museumPhotoAsset(artifact.museum),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _MuseumImage(artifact: artifact)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _openInMaps(context),
            icon: const Icon(Icons.directions_outlined),
            label: Text(
              tourText(context, 'Open in Maps', 'افتح في الخرائط'),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: tourGold,
              side: const BorderSide(color: tourGold),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Future<void> _openInMaps(BuildContext context) async {
    final query = switch (artifact.museum) {
      'Grand Egyptian Museum, Giza' => 'Grand Egyptian Museum, Giza, Egypt',
      'Egyptian Museum, Cairo' => 'Egyptian Museum, Tahrir Square, Cairo, Egypt',
      _ => artifact.museum,
    };
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': query,
    });

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tourText(
                context,
                'Could not open Maps.',
                'تعذر فتح الخرائط.',
              ),
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tourText(
                context,
                'Could not open Maps.',
                'تعذر فتح الخرائط.',
              ),
            ),
          ),
        );
      }
    }
  }

  String? _museumPhotoAsset(String museum) => switch (museum) {
    'Egyptian Museum, Cairo' =>
      'assets/images/museums/egyptian_museum_tahrir.jpg',
    'Grand Egyptian Museum, Giza' =>
      'assets/images/museums/grand_egyptian_museum.jpg',
    _ => null,
  };
}

class _MuseumFacadePhoto extends StatelessWidget {
  const _MuseumFacadePhoto({required this.artifact, required this.assetPath});

  final Artifact artifact;
  final String? assetPath;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1.05,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: assetPath == null
          ? ArtifactPhoto(
              assetPath: artifact.imageAsset,
              imageUrl: artifact.imageUrl,
              color: Color(artifact.color),
              fit: BoxFit.cover,
            )
          : Image.asset(
              assetPath!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ArtifactPhoto(
                assetPath: artifact.imageAsset,
                imageUrl: artifact.imageUrl,
                color: Color(artifact.color),
                fit: BoxFit.cover,
              ),
            ),
    ),
  );
}

class _MuseumImage extends StatelessWidget {
  const _MuseumImage({required this.artifact});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1.05,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ArtifactPhoto(
        assetPath: artifact.imageAsset,
        imageUrl: artifact.imageUrl,
        color: Color(artifact.color),
        fit: BoxFit.cover,
      ),
    ),
  );
}
