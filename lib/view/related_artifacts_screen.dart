import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/app_language.dart';
import '../utils/app_route.dart';
import 'artifact_data.dart';
import 'artifact_ui.dart';

class RelatedArtifactsScreen extends StatelessWidget {
  const RelatedArtifactsScreen({super.key, required this.artifact});

  final Artifact? artifact;

  @override
  Widget build(BuildContext context) => TourPageShell(
    title: 'Related Artifacts',
    trailing: const LanguagePill(),
    centerTitle: true,
    fullWidth: true,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final current = artifact;
        if (current == null) {
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

        final related = current.relatedArtifactIds
            .map(artifactForId)
            .whereType<Artifact>()
            .toList();
        final currentName = isArabic(context)
            ? current.arabicName
            : current.name;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tourText(context, 'Related to $currentName', 'قطع مرتبطة بـ$currentName'),
                  style: TextStyle(
                    color: tourCream,
                    fontFamily: 'serif',
                    fontSize: responsiveFontSize(context, 23),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                if (related.isNotEmpty) ...[
                  _RelatedMap(
                    artifact: current,
                    related: related.take(5).toList(),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _LegendChip(
                        color: tourGold,
                        label: tourText(context, 'Same museum', 'نفس المتحف'),
                      ),
                      _LegendChip(
                        color: const Color(0xff4388c9),
                        label: tourText(context, 'Abroad', 'في الخارج'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...related.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _RelatedArtifactCard(
                        artifact: item,
                        sameMuseum: item.museum == current.museum,
                      ),
                    ),
                  ),
                ] else
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Center(
                      child: Text(
                        tourText(
                          context,
                          'No related artifacts are available yet.',
                          'لا توجد قطع مرتبطة متاحة حاليًا.',
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: tourMuted),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _RelatedMap extends StatelessWidget {
  const _RelatedMap({required this.artifact, required this.related});

  final Artifact artifact;
  final List<Artifact> related;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 224,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final center = Offset(constraints.maxWidth / 2, 104);
        final points = _mapPoints(related.length, constraints.maxWidth);
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _RelationshipLines(center: center, points: points),
              ),
            ),
            for (var index = 0; index < related.length; index++)
              _MapNode(
                artifact: related[index],
                color: related[index].museum == artifact.museum
                    ? tourGold
                    : const Color(0xff4388c9),
                center: points[index],
                size: 58,
              ),
            _MapNode(
              artifact: artifact,
              color: const Color(0xffe0b742),
              center: center,
              size: 72,
              primary: true,
            ),
          ],
        );
      },
    ),
  );

  List<Offset> _mapPoints(int count, double width) {
    const nodeRadius = 29.0;
    final horizontalRadius = (width * .31)
        .clamp(52.0, 130.0)
        .toDouble();
    const verticalRadius = 68.0;
    if (count == 1) return [Offset(width / 2, 194)];
    if (count == 2) {
      return [
        Offset(width / 2 - horizontalRadius, 48),
        Offset(width / 2 + horizontalRadius, 48),
      ];
    }
    if (count == 3) {
      return [
        Offset(width / 2 - horizontalRadius, 46),
        Offset(width / 2 + horizontalRadius, 46),
        Offset(width / 2, 194),
      ];
    }
    final radius = math.min(
      math.min(horizontalRadius, verticalRadius),
      width / 2 - nodeRadius,
    ).toDouble();
    return List.generate(count, (index) {
      final angle = -math.pi / 2 + (2 * math.pi * index / count);
      return Offset(
        width / 2 + math.cos(angle) * radius,
        104 + math.sin(angle) * radius,
      );
    });
  }
}

class _RelationshipLines extends CustomPainter {
  const _RelationshipLines({required this.center, required this.points});

  final Offset center;
  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff77736c)
      ..strokeWidth = 1.3;
    for (final point in points) {
      canvas.drawLine(center, point, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RelationshipLines oldDelegate) =>
      oldDelegate.center != center || oldDelegate.points != points;
}

class _MapNode extends StatelessWidget {
  const _MapNode({
    required this.artifact,
    required this.color,
    required this.center,
    required this.size,
    this.primary = false,
  });

  final Artifact artifact;
  final Color color;
  final Offset center;
  final double size;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final name = isArabic(context) ? artifact.arabicName : artifact.name;
    return Positioned(
      left: center.dx - size / 2,
      top: center.dy - size / 2,
      width: size,
      height: size,
      child: Tooltip(
        message: name,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primary ? tourInk : Colors.white,
              fontSize: primary ? 10 : 8,
              height: 1.1,
              fontWeight: primary ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: tourRaised,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: color, size: 10),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: tourCream, fontSize: 12)),
      ],
    ),
  );
}

class _RelatedArtifactCard extends StatelessWidget {
  const _RelatedArtifactCard({
    required this.artifact,
    required this.sameMuseum,
  });

  final Artifact artifact;
  final bool sameMuseum;

  @override
  Widget build(BuildContext context) {
    final name = isArabic(context) ? artifact.arabicName : artifact.name;
    final museum = isArabic(context) ? artifact.arabicMuseum : artifact.museum;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => pushScreen(
          context,
          AppRoute.artifactDetailsScreen,
          artifact.id,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: tourRaised,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xff403b30)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 46,
                height: 46,
                child: ArtifactPhoto(
                  assetPath: artifact.imageAsset,
                  color: Color(artifact.color),
                  imageUrl: artifact.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: tourCream,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      museum,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: tourMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                sameMuseum ? Icons.account_balance_outlined : Icons.public,
                color: sameMuseum ? tourGold : const Color(0xff4388c9),
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
