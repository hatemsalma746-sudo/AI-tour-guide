import 'package:flutter/material.dart';
import '../utils/app_route.dart';
import '../utils/app_language.dart';
import 'artifact_data.dart';
import 'artifact_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtifactDetailsScreen extends StatelessWidget {
  const ArtifactDetailsScreen({super.key, this.artifact});

  final Artifact? artifact;

  @override
  Widget build(BuildContext context) => TourPageShell(
    title: 'Artifact Details',
    trailing: const LanguagePill(),
    centerTitle: true,
    fullWidth: true,
    child: LayoutBuilder(
      builder: (context, box) {
        final selectedArtifact = artifact;
        if (selectedArtifact == null) {
          return Center(
            child: Text(
              tourText(
                context,
                'Artifact details are unavailable.',
                'تفاصيل القطعة الأثرية غير متاحة.',
              ),
              style: TextStyle(color: tourMuted),
            ),
          );
        }
        final relatedArtifacts = artifacts
            .where(
              (item) =>
                  item.museumId == selectedArtifact.museumId &&
                  item.id != selectedArtifact.id,
            )
            .toList();
        final compactPhone = box.maxWidth < 350;
        final imageWidth = compactPhone
            ? double.infinity
            : (box.maxWidth * .38).clamp(136.0, 300.0).toDouble();
        final imageHeight = compactPhone
            ? 170.0
            : (imageWidth * 1.44).clamp(190.0, 340.0).toDouble();
        final image = SizedBox(
          height: imageHeight,
          width: imageWidth,
          child: ArtifactPhoto(
            assetPath: selectedArtifact.imageAsset,
            color: Color(selectedArtifact.color),
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        );
        final info = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (isArabic(context)
                      ? selectedArtifact.arabicPeriod
                      : selectedArtifact.period)
                  .toUpperCase(),
              style: const TextStyle(
                color: tourGold,
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              isArabic(context)
                  ? selectedArtifact.arabicName
                  : selectedArtifact.name,
              style: TextStyle(
                color: tourCream,
                fontFamily: 'serif',
                fontSize: responsiveFontSize(context, 24),
                height: 1.08,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 3,
              children: List.generate(
                6,
                (_) => Container(
                  width: 8,
                  height: 6,
                  decoration: BoxDecoration(
                    color: tourGold.withValues(alpha: .72),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            InfoPair(
              label: 'Civilization',
              value: tourText(context, 'Ancient Egypt', 'مصر القديمة'),
            ),
            InfoPair(
              label: 'Period',
              value: isArabic(context)
                  ? selectedArtifact.arabicPeriod
                  : selectedArtifact.period,
            ),
            InfoPair(
              label: 'Dynasty',
              value: isArabic(context)
                  ? selectedArtifact.arabicDynasty
                  : selectedArtifact.dynasty,
            ),
            InfoPair(
              label: 'Material',
              value: isArabic(context)
                  ? selectedArtifact.arabicMaterial
                  : selectedArtifact.material,
            ),
            InfoPair(
              label: 'Discovery',
              value: isArabic(context)
                  ? selectedArtifact.arabicDiscovery
                  : selectedArtifact.discovery,
            ),
          ],
        );
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!compactPhone)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: info),
                      const SizedBox(width: 12),
                      image,
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [info, const SizedBox(height: 12), image],
                  ),
                const SizedBox(height: 12),
                LocationCard(
                  museumName: isArabic(context)
                      ? selectedArtifact.arabicMuseum
                      : selectedArtifact.museum,
                  onTap: () async {
                    final museum = Uri.encodeComponent(selectedArtifact.museum);

                    final url = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=$museum',
                    );

                    final success = await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );

                    if (!success && context.mounted) {
                      showToast(context, 'Could not open Google Maps.');
                    }
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        label: tourText(context, 'Listen', 'استمع'),
                        icon: Icons.headphones,
                        onPressed: () => showToast(
                          context,
                          tourText(
                            context,
                            'Text-to-speech is not connected yet.',
                            'ميزة الاستماع غير متصلة حاليًا.',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlineButton(
                        label: tourText(context, '✦  Restore', '✦  ترميم'),
                        onPressed: () => showToast(
                          context,
                          selectedArtifact.restoreAvailable
                              ? tourText(
                                  context,
                                  'Restoration is not connected yet.',
                                  'ميزة الترميم غير متصلة حاليًا.',
                                )
                              : tourText(
                                  context,
                                  'Restoration is not available for this artifact.',
                                  'الترميم غير متاح لهذه القطعة.',
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tourText(
                        context,
                        'Related artifacts',
                        'قطع أثرية مرتبطة',
                      ),
                      style: TextStyle(
                        color: tourCream,
                        fontFamily: 'serif',
                        fontSize: 21,
                      ),
                    ),
                    TextButton(
                      onPressed: () => pushScreen(
                        context,
                        AppRoute.artifactsScreen,
                        selectedArtifact.museumId,
                      ),
                      child: Text(
                        tourText(context, 'See all', 'عرض الكل'),
                        style: TextStyle(color: tourGold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 88,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: relatedArtifacts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, i) => SizedBox(
                      width: 64,
                      child: InkWell(
                        onTap: () => pushScreen(
                          context,
                          AppRoute.artifactDetailsScreen,
                          relatedArtifacts[i].id,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ArtifactPhoto(
                                assetPath: relatedArtifacts[i].imageAsset,
                                color: Color(relatedArtifacts[i].color),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              isArabic(context)
                                  ? relatedArtifacts[i].arabicName
                                  : relatedArtifacts[i].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: tourCream,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlineButton(
                  label: tourText(context, 'Ask Bast', 'اسأل باست'),
                  icon: Icons.chat_bubble_outline,
                  onPressed: () => showToast(
                    context,
                    tourText(
                      context,
                      'Ask Bast is not connected yet.',
                      'باست غير متصلة حاليًا.',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    ),
  );
}
