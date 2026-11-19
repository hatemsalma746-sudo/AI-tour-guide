import 'package:flutter/material.dart';

import '../utils/app_language.dart';
import 'artifact_image_resolver.dart';
import 'artifact_data.dart';
import 'artifact_ui.dart';

class AiReconstructionScreen extends StatelessWidget {
  const AiReconstructionScreen({super.key, required this.artifact});

  final Artifact? artifact;

  @override
  Widget build(BuildContext context) => TourPageShell(
    title: 'AI Reconstruction',
    fullWidth: true,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final item = artifact;
        if (item == null) {
          return Center(
            child: Text(
              tourText(
                context,
                'Artifact not found.',
                'لم يتم العثور على القطعة.',
              ),
              style: const TextStyle(color: tourMuted),
            ),
          );
        }
        final title = isArabic(context) ? item.arabicName : item.name;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: tourCream,
                    fontFamily: 'serif',
                    fontSize: responsiveFontSize(context, 25),
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 12),
                _BeforeAfterPhoto(artifact: item),
                const SizedBox(height: 14),
                _HistoricalNote(artifact: item),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    tourText(
                      context,
                      'Reconstructed using AI & historical references',
                      'إعادة بناء بالذكاء الاصطناعي ومراجع تاريخية',
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: tourMuted, fontSize: 11),
                  ),
                ),
                SizedBox(height: constraints.maxHeight > 680 ? 14 : 4),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _BeforeAfterPhoto extends StatefulWidget {
  const _BeforeAfterPhoto({required this.artifact});

  final Artifact artifact;

  @override
  State<_BeforeAfterPhoto> createState() => _BeforeAfterPhotoState();
}

class _BeforeAfterPhotoState extends State<_BeforeAfterPhoto> {
  double _split = .5;
  String? _beforeAsset;
  String? _afterAsset;

  @override
  void initState() {
    super.initState();
    _findComparisonImages();
  }

  @override
  void didUpdateWidget(covariant _BeforeAfterPhoto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.artifact.id != widget.artifact.id) {
      _beforeAsset = null;
      _afterAsset = null;
      _findComparisonImages();
    }
  }

  Future<void> _findComparisonImages() async {
    final artifact = widget.artifact;
    if (artifact.reconstruction != null) return;
    final images = await Future.wait([
      findArtifactComparisonImage(artifact, 'before'),
      findArtifactComparisonImage(artifact, 'after'),
    ]);
    if (!mounted || widget.artifact.id != artifact.id) return;
    setState(() {
      _beforeAsset = images[0];
      _afterAsset = images[1];
    });
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1.34,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final artifact = widget.artifact;
        final beforeAsset = _beforeAsset ?? artifact.imageAsset;
        final afterAsset = _afterAsset ?? artifact.imageAsset;
        final reconstruction = artifact.reconstruction;
        final beforeUrl = reconstruction?.isReady == true
            ? reconstruction!.beforeImageUrl
            : null;
        final afterUrl = reconstruction?.isReady == true
            ? reconstruction!.afterImageUrl
            : null;
        final originalPhoto = ArtifactPhoto(
          assetPath: artifact.imageAsset,
          color: Color(artifact.color),
          imageUrl: artifact.imageUrl,
          fit: BoxFit.cover,
        );
        final beforeFallback = Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                .58,
                .12,
                .08,
                0,
                5,
                .10,
                .48,
                .08,
                0,
                4,
                .06,
                .07,
                .40,
                0,
                1,
                0,
                0,
                0,
                .72,
                0,
              ]),
              child: originalPhoto,
            ),
            ColoredBox(color: Colors.black.withValues(alpha: .24)),
          ],
        );
        final beforeLayer = beforeUrl != null
            ? _comparisonImage(
                artifact,
                imageUrl: beforeUrl,
                fallback: originalPhoto,
              )
            : _beforeAsset == null
            ? beforeFallback
            : _comparisonImage(
                artifact,
                assetPath: beforeAsset,
                fallback: beforeFallback,
              );
        final splitX = constraints.maxWidth * _split;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            setState(() {
              _split = (details.localPosition.dx / constraints.maxWidth).clamp(
                0.0,
                1.0,
              );
            });
          },
          onTapDown: (details) {
            setState(() {
              _split = (details.localPosition.dx / constraints.maxWidth).clamp(
                0.0,
                1.0,
              );
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(widget.artifact.color).withValues(alpha: .5),
                        const Color(0xff34291d),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: afterUrl != null
                      ? _comparisonImage(
                          artifact,
                          imageUrl: afterUrl,
                          fallback: originalPhoto,
                        )
                      : _afterAsset == null
                      ? originalPhoto
                      : _comparisonImage(
                          artifact,
                          assetPath: afterAsset,
                          fallback: originalPhoto,
                        ),
                ),
                ClipRect(
                  clipper: _LeftSideClipper(_split),
                  child: Stack(fit: StackFit.expand, children: [beforeLayer]),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _ImageTag(label: tourText(context, 'Before', 'قبل')),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _ImageTag(label: tourText(context, 'After', 'بعد')),
                ),
                Positioned(
                  left: splitX - 1.25,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 2.5, color: tourCream),
                ),
                Positioned(
                  left: (splitX - 19).clamp(0.0, constraints.maxWidth - 38),
                  top: constraints.maxHeight / 2 - 19,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: tourCream,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.swap_horiz,
                      color: tourInk,
                      size: 25,
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

  Widget _comparisonImage(
    Artifact artifact, {
    String? imageUrl,
    String? assetPath,
    required Widget fallback,
  }) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }
    if (assetPath != null) {
      return Image.asset(
        assetPath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }
    return ArtifactPhoto(
      assetPath: artifact.imageAsset,
      color: Color(artifact.color),
      imageUrl: artifact.imageUrl,
      fit: BoxFit.cover,
    );
  }
}

class _LeftSideClipper extends CustomClipper<Rect> {
  const _LeftSideClipper(this.split);

  final double split;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(0, 0, size.width * split, size.height);

  @override
  bool shouldReclip(covariant _LeftSideClipper oldClipper) =>
      oldClipper.split != split;
}

class _ImageTag extends StatelessWidget {
  const _ImageTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
    decoration: BoxDecoration(
      color: tourInk.withValues(alpha: .78),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Text(label, style: const TextStyle(color: tourCream, fontSize: 12)),
  );
}

class _HistoricalNote extends StatelessWidget {
  const _HistoricalNote({required this.artifact});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(20, 17, 20, 15),
    decoration: BoxDecoration(
      color: const Color(0xff20201f),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xff453b2b)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.menu_book_outlined, color: tourGold, size: 23),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tourText(
                  context,
                  'Historical Reconstruction',
                  'إعادة بناء تاريخية',
                ),
                style: TextStyle(
                  color: tourGold,
                  fontFamily: 'serif',
                  fontSize: responsiveFontSize(context, 19),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(color: Color(0xff494238), height: 1),
        const SizedBox(height: 14),
        Text(
          tourText(
            context,
            'This AI-assisted reconstruction is based on historical research and available archaeological references.',
            'إعادة البناء بمساعدة الذكاء الاصطناعي، وتعتمد على الأبحاث التاريخية والمراجع الأثرية المتاحة.',
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(color: tourCream, height: 1.45, fontSize: 13),
        ),
        const SizedBox(height: 9),
        Text(
          tourText(
            context,
            'An informed interpretation of how the damaged artifact may have looked.',
            'تصوّر مبني على المراجع للشكل المحتمل للقطعة قبل تلفها.',
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(color: tourMuted, height: 1.4, fontSize: 12),
        ),
        const SizedBox(height: 11),
        Center(
          child: Text(
            tourText(
              context,
              '◆ AI-assisted historical interpretation',
              '◆ تفسير تاريخي بمساعدة الذكاء الاصطناعي',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(color: tourGold, fontSize: 11),
          ),
        ),
      ],
    ),
  );
}
