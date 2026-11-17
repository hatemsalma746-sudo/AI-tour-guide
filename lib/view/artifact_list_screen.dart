import 'package:flutter/material.dart';

import '../utils/app_route.dart';
import '../utils/app_language.dart';
import 'artifact_data.dart';
import 'artifact_ui.dart';

class ArtifactListScreen extends StatefulWidget {
  const ArtifactListScreen({super.key, this.museumId = mockMuseumId});

  final String museumId;

  @override
  State<ArtifactListScreen> createState() => _ArtifactListScreenState();
}

class _ArtifactListScreenState extends State<ArtifactListScreen> {
  final _search = TextEditingController();
  String? _periodKey;

  static const _filters = <_PeriodFilter>[
    _PeriodFilter(null, 'All', 'الكل'),
    _PeriodFilter('predynastic', 'Predynastic', 'ما قبل الأسرات'),
    _PeriodFilter('old_kingdom', 'Old Kingdom', 'الدولة القديمة'),
    _PeriodFilter('new_kingdom', 'New Kingdom', 'الدولة الحديثة'),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TourPageShell(
      title: '',
      showAppBar: false,
      child: LayoutBuilder(
        builder: (context, box) {
          final filtered = artifacts.where((artifact) {
            final sameMuseum = artifact.museumId == widget.museumId;
            final samePeriod =
                _periodKey == null || artifact.periodKey == _periodKey;
            final matchesSearch =
                '${artifact.name} ${artifact.period} ${artifact.arabicName} ${artifact.arabicPeriod}'
                    .toLowerCase()
                    .contains(_search.text.toLowerCase());
            return sameMuseum && samePeriod && matchesSearch;
          }).toList();
          final columns = box.maxWidth >= 800
              ? 4
              : box.maxWidth >= 540
              ? 3
              : 2;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'القطع الأثرية',
                      style: TextStyle(
                        color: tourGold,
                        fontSize: 13,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  const LanguagePill(),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Row(
                  children: [
                    const Icon(Icons.chevron_left, color: tourCream, size: 27),
                    Text(
                      tourText(context, 'Artifacts', 'القطع الأثرية'),
                      style: TextStyle(
                        color: tourCream,
                        fontFamily: 'serif',
                        fontSize: responsiveFontSize(context, 27),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              Text(
                tourText(
                  context,
                  'Egyptian Museum · Cairo',
                  'المتحف المصري · القاهرة',
                ),
                style: TextStyle(color: tourMuted, fontSize: 12),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 44,
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: tourCream, fontSize: 14),
                  cursorColor: Colors.white,
                  cursorWidth: 2,
                  decoration: InputDecoration(
                    hintText: tourText(
                      context,
                      'Search artifacts',
                      'ابحث عن قطعة أثرية',
                    ),
                    hintStyle: const TextStyle(color: tourMuted),
                    filled: true,
                    fillColor: const Color(0xff252522),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 34,
                      minHeight: 42,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: tourMuted,
                      size: 15,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Color(0xff4b412e)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Color(0xff4b412e)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 9),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters
                      .map(
                        (filter) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              tourText(context, filter.label, filter.labelAr),
                            ),
                            selected: _periodKey == filter.key,
                            showCheckmark: false,
                            onSelected: (_) =>
                                setState(() => _periodKey = filter.key),
                            selectedColor: tourCream,
                            backgroundColor: tourRaised,
                            labelStyle: TextStyle(
                              color: _periodKey == filter.key
                                  ? tourInk
                                  : tourCream,
                              fontSize: 12,
                            ),
                            side: BorderSide.none,
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 11),
              Row(
                children: [
                  Text(
                    tourText(context, 'All artifacts', 'كل القطع الأثرية'),
                    style: TextStyle(
                      color: tourCream,
                      fontFamily: 'serif',
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    isArabic(context)
                        ? '${filtered.length} قطع'
                        : '${filtered.length} artifacts',
                    style: const TextStyle(color: tourMuted, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          tourText(
                            context,
                            'No artifacts found',
                            'لم يتم العثور على قطع',
                          ),
                          style: TextStyle(color: tourMuted),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 9,
                          mainAxisSpacing: 9,
                          childAspectRatio: box.maxWidth < 360 ? .72 : .76,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) =>
                            ArtifactTile(artifact: filtered[index]),
                      ),
              ),
              const SizedBox(height: 10),
              ActionButton(
                label: tourText(context, 'Scan an artifact', 'امسح قطعة أثرية'),
                icon: Icons.center_focus_strong,
                onPressed: () =>
                    pushScreen(context, AppRoute.scanScreen, widget.museumId),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PeriodFilter {
  const _PeriodFilter(this.key, this.label, this.labelAr);

  final String? key;
  final String label;
  final String labelAr;
}
