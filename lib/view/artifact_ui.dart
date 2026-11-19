import 'package:flutter/material.dart';

import '../utils/app_route.dart';
import '../utils/app_language.dart';
import 'artifact_data.dart';

const tourInk = Color(0xff111110);
const tourPanel = Color(0xff20201f);
const tourRaised = Color(0xff292825);
const tourGold = Color(0xffc49b50);
const tourCream = Color(0xfff1e9d8);
const tourMuted = Color(0xffa7a39b);

class TourPageShell extends StatelessWidget {
  const TourPageShell({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.centerTitle = false,
    this.showAppBar = true,
    this.fullWidth = false,
    this.resizeToAvoidBottomInset = true,
    this.maintainBottomViewPadding = false,
  });
  final String title;
  final Widget child;
  final Widget? trailing;
  final bool centerTitle;
  final bool showAppBar;
  final bool fullWidth;
  final bool resizeToAvoidBottomInset;
  final bool maintainBottomViewPadding;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: tourInk,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    appBar: showAppBar
        ? AppBar(
            backgroundColor: tourInk,
            foregroundColor: tourCream,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                if (MediaQuery.viewInsetsOf(context).bottom > 0) {
                  FocusManager.instance.primaryFocus?.unfocus();
                } else {
                  Navigator.maybePop(context);
                }
              },
              icon: const Icon(Icons.arrow_back, size: 20),
            ),
            title: Text(
              _localizedPageTitle(context, title),
              style: const TextStyle(fontFamily: 'serif', fontSize: 20),
            ),
            centerTitle: centerTitle,
            actions: [?trailing, const SizedBox(width: 8)],
          )
        : null,
    body: SafeArea(
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = fullWidth
              ? constraints.maxWidth
              : constraints.maxWidth >= 1000
              ? 920.0
              : 760.0;
          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: maxWidth,
              height: constraints.maxHeight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  fullWidth
                      ? (constraints.maxWidth < 360 ? 12 : 18)
                      : pagePadding(context),
                  8,
                  pagePadding(context),
                  16,
                ),
                child: child,
              ),
            ),
          );
        },
      ),
    ),
  );
}

class KeyboardFollower extends StatelessWidget {
  const KeyboardFollower({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Transform.translate(
    offset: Offset(0, -MediaQuery.viewInsetsOf(context).bottom),
    child: child,
  );
}

class ArtifactTile extends StatelessWidget {
  const ArtifactTile({super.key, required this.artifact});
  final Artifact artifact;
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: () =>
        pushScreen(context, AppRoute.artifactDetailsScreen, artifact.id),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: tourPanel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff39362f)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ArtifactPhoto(
              assetPath: artifact.imageAsset,
              color: Color(artifact.color),
              imageUrl: artifact.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic(context) ? artifact.arabicName : artifact.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: tourCream,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            isArabic(context) ? artifact.arabicPeriod : artifact.period,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: tourMuted, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}

class StatueArt extends StatelessWidget {
  const StatueArt({super.key, required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _StatuePainter(color),
    child: const SizedBox.expand(),
  );
}

class ArtifactPhoto extends StatelessWidget {
  const ArtifactPhoto({
    super.key,
    required this.assetPath,
    required this.color,
    this.imageUrl,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  final String assetPath;
  final Color color;
  final String? imageUrl;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: color.withValues(alpha: .18),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: tourGold.withValues(alpha: .3)),
    ),
    clipBehavior: Clip.antiAlias,
    child: imageUrl != null && imageUrl!.isNotEmpty
        ? Image.network(
            imageUrl!,
            fit: fit,
            alignment: alignment,
            filterQuality: FilterQuality.high,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) => _assetFallback(),
          )
        : _assetFallback(),
  );

  Widget _assetFallback() => Image.asset(
    assetPath,
    fit: fit,
    alignment: alignment,
    filterQuality: FilterQuality.high,
    width: double.infinity,
    height: double.infinity,
    errorBuilder: (context, error, stackTrace) => ColoredBox(
      color: color.withValues(alpha: .22),
      child: StatueArt(color: color),
    ),
  );
}

class _StatuePainter extends CustomPainter {
  _StatuePainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final scale = (size.width / 120).clamp(.4, 2.2).toDouble();
    final paint = Paint()..color = color;
    final dark = Paint()..color = const Color(0xff33291d);
    final face = Paint()..color = const Color(0xffd8b96d);
    final bodyTop = size.height * .1;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, size.height * .87),
        width: size.width * .62,
        height: 12 * scale,
      ),
      dark,
    );
    final headdress = Path()
      ..moveTo(cx - 21 * scale, bodyTop + 20 * scale)
      ..quadraticBezierTo(cx - 18 * scale, bodyTop, cx, bodyTop)
      ..quadraticBezierTo(
        cx + 18 * scale,
        bodyTop,
        cx + 21 * scale,
        bodyTop + 20 * scale,
      )
      ..lineTo(cx + 28 * scale, size.height * .68)
      ..quadraticBezierTo(
        cx,
        size.height * .83,
        cx - 28 * scale,
        size.height * .68,
      )
      ..close();
    canvas.drawPath(headdress, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, bodyTop + 36 * scale),
          width: 19 * scale,
          height: 28 * scale,
        ),
        Radius.circular(8 * scale),
      ),
      face,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        cx - 5 * scale,
        bodyTop + 50 * scale,
        10 * scale,
        size.height * .26,
      ),
      dark,
    );
    final lines = Paint()
      ..color = const Color(0xff5a472c)
      ..strokeWidth = 1.2 * scale;
    for (var i = 0; i < 4; i++) {
      final y = bodyTop + (55 + i * 12) * scale;
      canvas.drawLine(
        Offset(cx - 21 * scale, y),
        Offset(cx + 21 * scale, y),
        lines,
      );
    }
    canvas.drawCircle(Offset(cx, bodyTop + 7 * scale), 2.5 * scale, dark);
  }

  @override
  bool shouldRepaint(covariant _StatuePainter oldDelegate) =>
      oldDelegate.color != color;
}

class Viewfinder extends StatelessWidget {
  const Viewfinder({super.key, this.squareFrame = false});

  final bool squareFrame;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final w = box.maxWidth * .68;
      final h = squareFrame ? w : box.maxHeight * .55;
      return SizedBox(
        width: w,
        height: h,
        child: Stack(
          children: [
            _corner(Alignment.topLeft),
            _corner(Alignment.topRight),
            _corner(Alignment.bottomLeft),
            _corner(Alignment.bottomRight),
          ],
        ),
      );
    },
  );
  Widget _corner(Alignment alignment) => Align(
    alignment: alignment,
    child: SizedBox(
      width: 30,
      height: 30,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? const BorderSide(color: tourCream, width: 3)
                : BorderSide.none,
            bottom: alignment.y > 0
                ? const BorderSide(color: tourCream, width: 3)
                : BorderSide.none,
            left: alignment.x < 0
                ? const BorderSide(color: tourCream, width: 3)
                : BorderSide.none,
            right: alignment.x > 0
                ? const BorderSide(color: tourCream, width: 3)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: alignment == Alignment.topLeft
                ? const Radius.circular(7)
                : Radius.zero,
            topRight: alignment == Alignment.topRight
                ? const Radius.circular(7)
                : Radius.zero,
            bottomLeft: alignment == Alignment.bottomLeft
                ? const Radius.circular(7)
                : Radius.zero,
            bottomRight: alignment == Alignment.bottomRight
                ? const Radius.circular(7)
                : Radius.zero,
          ),
        ),
      ),
    ),
  );
}

class InfoPair extends StatelessWidget {
  const InfoPair({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _localizedInfoLabel(context, label),
          style: const TextStyle(color: tourMuted, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: tourCream, fontSize: 13)),
      ],
    ),
  );
}

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.museumName,
    required this.onTap,
  });

  final String museumName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: tourRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff403c32)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: tourGold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tourText(context, 'Where is it now?', 'مكانها الحالي'),
                  style: TextStyle(color: tourMuted, fontSize: 11),
                ),
                const SizedBox(height: 3),
                Text(
                  isArabic(context)
                      ? _arabicMuseumName(museumName)
                      : museumName,
                  style: const TextStyle(color: tourCream, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: tourGold),
        ],
      ),
    ),
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: tourCream,
        foregroundColor: tourInk,
        minimumSize: const Size(0, 48),
        shape: const StadiumBorder(),
      ),
    ),
  );
}

class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leading,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Widget? leading;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon:
          leading ??
          (icon == null ? const SizedBox.shrink() : Icon(icon, size: 17)),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: tourGold,
        side: const BorderSide(color: tourGold),
        minimumSize: const Size(0, 48),
        shape: const StadiumBorder(),
      ),
    ),
  );
}

class LanguagePill extends StatelessWidget {
  const LanguagePill({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: toggleAppLanguage,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: tourRaised,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${isArabic(context) ? 'AR' : 'EN'}  ⌄',
          style: const TextStyle(color: tourCream, fontSize: 12),
        ),
      ),
    ),
  );
}

String _localizedPageTitle(BuildContext context, String title) =>
    switch (title) {
      'Scan Artifact' => tourText(context, title, 'مسح قطعة أثرية'),
      'Artifact Details' => tourText(context, title, 'تفاصيل القطعة الأثرية'),
      'Related Artifacts' => tourText(context, title, 'القطع الأثرية المرتبطة'),
      'Where is it now?' => tourText(context, title, 'أين توجد الآن؟'),
      'Ask Bast' => tourText(context, title, 'اسأل باست'),
      'AI Reconstruction' => tourText(
        context,
        title,
        'إعادة البناء بالذكاء الاصطناعي',
      ),
      _ => title,
    };

String _localizedInfoLabel(BuildContext context, String label) =>
    switch (label) {
      'Civilization' => tourText(context, label, 'الحضارة'),
      'Period' => tourText(context, label, 'العصر'),
      'Dynasty' => tourText(context, label, 'الأسرة'),
      'Material' => tourText(context, label, 'الخامة'),
      'Discovery' => tourText(context, label, 'الاكتشاف'),
      _ => label,
    };

String _arabicMuseumName(String name) => switch (name) {
  'Egyptian Museum, Cairo' => 'المتحف المصري، القاهرة',
  'Grand Egyptian Museum, Giza' => 'المتحف المصري الكبير، الجيزة',
  _ => name,
};

double pagePadding(BuildContext context) =>
    MediaQuery.sizeOf(context).width < 360 ? 14 : 20;
double responsiveFontSize(BuildContext context, double size) =>
    (size * (MediaQuery.sizeOf(context).width / 390).clamp(.9, 1.35))
        .toDouble();

void pushScreen(BuildContext context, String route, Object arguments) =>
    Navigator.of(context).pushNamed(route, arguments: arguments);

void showToast(BuildContext context, String message) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));
