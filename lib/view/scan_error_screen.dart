import 'package:flutter/material.dart';
import '../utils/app_route.dart';
import '../utils/app_language.dart';
import 'artifact_data.dart';
import 'artifact_ui.dart';

class ScanErrorScreen extends StatelessWidget {
  const ScanErrorScreen({super.key, this.museumId = mockMuseumId});

  final String museumId;

  @override
  Widget build(BuildContext context) => TourPageShell(
    title: 'Scan Artifact',
    centerTitle: true,
    trailing: IconButton(
      tooltip: tourText(context, 'Flash', 'الفلاش'),
      onPressed: () {},
      icon: const Icon(Icons.flash_on, color: tourGold),
    ),
    child: LayoutBuilder(
      builder: (context, box) => Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 480,
                  maxHeight: 520,
                ),
                child: AspectRatio(
                  aspectRatio: box.maxWidth > 600 ? 1.2 : .92,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const RadialGradient(
                        colors: [Color(0xff42382b), Color(0xff211f1c), tourInk],
                      ),
                      border: Border.all(color: const Color(0xff484036)),
                    ),
                    child: const Center(child: Viewfinder()),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 560),
            padding: EdgeInsets.fromLTRB(
              22,
              24,
              22,
              MediaQuery.paddingOf(context).bottom + 16,
            ),
            decoration: BoxDecoration(
              color: tourPanel,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xff443c2d)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  tourText(
                    context,
                    'We’re not sure what this is',
                    'لسنا متأكدين من ماهية هذه القطعة',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: tourCream,
                    fontFamily: 'serif',
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tourText(
                    context,
                    'Try a closer, well-lit photo, or browse the museum’s artifacts instead.',
                    'جرّب صورة أقرب وبإضاءة أفضل، أو تصفح قطع المتحف.',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: tourMuted, height: 1.4),
                ),
                const SizedBox(height: 18),
                ActionButton(
                  label: tourText(context, 'Try again', 'حاول مرة أخرى'),
                  onPressed: () =>
                      pushScreen(context, AppRoute.scanScreen, museumId),
                ),
                const SizedBox(height: 10),
                OutlineButton(
                  label: tourText(
                    context,
                    'Browse artifacts',
                    'تصفح القطع الأثرية',
                  ),
                  onPressed: () =>
                      pushScreen(context, AppRoute.artifactsScreen, museumId),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
