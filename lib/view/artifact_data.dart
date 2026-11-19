class Artifact {
  const Artifact({
    required this.id,
    required this.museumId,
    required this.name,
    required this.periodKey,
    required this.period,
    required this.dynasty,
    required this.material,
    required this.discovery,
    required this.color,
    required this.imageAsset,
    this.imageUrl,
    this.relatedArtifactIds = const [],
    this.reconstruction,
    this.nameArabic,
    this.periodArabic,
    this.dynastyArabic,
    this.materialArabic,
    this.discoveryArabic,
    this.locationStory,
    this.arabicLocationStory,
    this.removalYear,
    this.removalInformation,
    this.arabicRemovalInformation,
    this.museum = 'Egyptian Museum, Cairo',
    this.museumArabic,
  });

  factory Artifact.fromJson(Map<String, dynamic> json) {
    final museumValue = json['museum'];
    final museumData = museumValue is Map
        ? Map<String, dynamic>.from(museumValue)
        : <String, dynamic>{};
    final relatedValue = json['relatedArtifactIds'] ?? json['relatedArtifacts'];
    final relatedIds = relatedValue is List
        ? relatedValue
              .map((value) {
                if (value is Map) return value['id']?.toString() ?? '';
                return value.toString();
              })
              .where((id) => id.isNotEmpty)
              .toList()
        : const <String>[];
    final reconstructionValue = json['reconstruction'];
    final reconstructionData = reconstructionValue is Map
        ? ArtifactReconstruction.fromJson(
            Map<String, dynamic>.from(reconstructionValue),
          )
        : null;
    final color = _parseArtifactColor(json['color']);

    return Artifact(
      id: json['id']?.toString() ?? '',
      museumId:
          json['museumId']?.toString() ?? museumData['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      periodKey: json['periodKey']?.toString() ?? '',
      period: json['period']?.toString() ?? '',
      dynasty: json['dynasty']?.toString() ?? '',
      material: json['material']?.toString() ?? '',
      discovery: json['discovery']?.toString() ?? '',
      color: color,
      imageAsset: json['imageAsset']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      relatedArtifactIds: relatedIds,
      reconstruction: reconstructionData,
      nameArabic: json['nameArabic']?.toString(),
      periodArabic: json['periodArabic']?.toString(),
      dynastyArabic: json['dynastyArabic']?.toString(),
      materialArabic: json['materialArabic']?.toString(),
      discoveryArabic: json['discoveryArabic']?.toString(),
      locationStory: json['locationStory']?.toString(),
      arabicLocationStory: json['arabicLocationStory']?.toString(),
      removalYear: json['removalYear']?.toString(),
      removalInformation: json['removalInformation']?.toString(),
      arabicRemovalInformation: json['arabicRemovalInformation']?.toString(),
      museum:
          json['museumName']?.toString() ??
          museumData['name']?.toString() ??
          (museumValue is String ? museumValue : 'Egyptian Museum, Cairo'),
      museumArabic:
          json['museumNameArabic']?.toString() ??
          museumData['nameArabic']?.toString(),
    );
  }

  final String id;
  final String museumId;
  final String name;
  final String periodKey;
  final String period;
  final String dynasty;
  final String material;
  final String discovery;
  final int color;
  final String imageAsset;
  final String? imageUrl;
  final List<String> relatedArtifactIds;
  final ArtifactReconstruction? reconstruction;
  final String? nameArabic;
  final String? periodArabic;
  final String? dynastyArabic;
  final String? materialArabic;
  final String? discoveryArabic;
  final String? locationStory;
  final String? arabicLocationStory;
  final String? removalYear;
  final String? removalInformation;
  final String? arabicRemovalInformation;
  final String museum;
  final String? museumArabic;

  bool get restoreAvailable => reconstruction?.isReady ?? false;

  String get arabicName => nameArabic ?? switch (id) {
    'artifact.narmer_palette' => 'لوحة نارمر',
    'artifact.statue_khafre' => 'تمثال خفرع',
    'artifact.rahotep_nofret' => 'تمثالا رحوتب ونوفرت',
    'artifact.akhenaten_colossus' => 'تمثال أخناتون الضخم',
    'artifact.ramesses_ii_colossus' => 'تمثال رمسيس الثاني',
    _ => name,
  };

  String get arabicPeriod => periodArabic ?? switch (periodKey) {
    'predynastic' => 'ما قبل الأسرات المتأخر',
    'old_kingdom' => 'الدولة القديمة',
    'new_kingdom' => 'الدولة الحديثة',
    _ => period,
  };

  String get arabicDynasty => dynastyArabic ?? switch (dynasty) {
    'First Dynasty' => 'الأسرة الأولى',
    'Fourth Dynasty' => 'الأسرة الرابعة',
    'Eighteenth Dynasty' => 'الأسرة الثامنة عشرة',
    'Nineteenth Dynasty' => 'الأسرة التاسعة عشرة',
    _ => dynasty,
  };

  String get arabicMaterial => materialArabic ?? switch (material) {
    'Slate' => 'الأردواز',
    'Diorite' => 'الديوريت',
    'Limestone' => 'الحجر الجيري',
    'Sandstone' => 'الحجر الرملي',
    'Red granite' => 'الجرانيت الأحمر',
    _ => material,
  };

  String get arabicDiscovery => discoveryArabic ?? switch (id) {
    'artifact.narmer_palette' => '١٨٩٨، هيراكونبوليس',
    'artifact.statue_khafre' => 'هضبة الجيزة',
    'artifact.rahotep_nofret' => 'مصطبة ميدوم',
    'artifact.akhenaten_colossus' => 'الكرنك، ١٩٢٥',
    'artifact.ramesses_ii_colossus' => '١٨٢٠، ميت رهينة',
    _ => discovery,
  };

  String get arabicMuseum => museumArabic ?? switch (museum) {
    'Egyptian Museum, Cairo' => 'المتحف المصري، القاهرة',
    'Grand Egyptian Museum, Giza' => 'المتحف المصري الكبير، الجيزة',
    _ => museum,
  };
}

class ArtifactReconstruction {
  const ArtifactReconstruction({
    this.beforeImageUrl,
    this.afterImageUrl,
  });

  final String? beforeImageUrl;
  final String? afterImageUrl;

  String get status => hasImagePair ? 'ready' : 'pending';

  bool get hasImagePair =>
      _isHttpImageUrl(beforeImageUrl) && _isHttpImageUrl(afterImageUrl);

  bool get isReady => status == 'ready';

  factory ArtifactReconstruction.fromJson(Map<String, dynamic> json) =>
      ArtifactReconstruction(
        beforeImageUrl: json['beforeImageUrl']?.toString(),
        afterImageUrl: json['afterImageUrl']?.toString(),
      );
}

bool _isHttpImageUrl(String? value) {
  if (value == null || value.trim().isEmpty) return false;
  final uri = Uri.tryParse(value.trim());
  return uri != null &&
      uri.host.isNotEmpty &&
      (uri.scheme == 'https' || uri.scheme == 'http');
}

int _parseArtifactColor(Object? value) {
  if (value is int) return value <= 0xffffff ? 0xff000000 | value : value;
  var colorText = value?.toString().replaceFirst('#', '') ?? '';
  if (colorText.startsWith('0x')) colorText = colorText.substring(2);
  final parsed = int.tryParse(colorText, radix: 16);
  if (parsed == null) return 0xffbd9551;
  return colorText.length <= 6 ? 0xff000000 | parsed : parsed;
}

const mockMuseumId = 'museum.grand_egyptian_giza';

// Preview fixtures use the same related-ID contract the backend can return.
const artifacts = <Artifact>[
  Artifact(
    id: 'artifact.narmer_palette',
    museumId: mockMuseumId,
    name: 'Narmer Palette',
    periodKey: 'predynastic',
    period: 'Late Predynastic',
    dynasty: 'First Dynasty',
    material: 'Slate',
    discovery: '1898, Hierakonpolis',
    color: 0xffbd9551,
    imageAsset: 'assets/images/artifacts/narmer_palette.jpg',
    relatedArtifactIds: ['artifact.akhenaten_colossus', 'artifact.statue_khafre'],
  ),
  Artifact(
    id: 'artifact.statue_khafre',
    museumId: mockMuseumId,
    name: 'Statue of Khafre',
    periodKey: 'old_kingdom',
    period: 'Old Kingdom',
    dynasty: 'Fourth Dynasty',
    material: 'Diorite',
    discovery: 'Giza Plateau',
    color: 0xff287c83,
    imageAsset: 'assets/images/artifacts/statue_khafre.jpg',
    relatedArtifactIds: ['artifact.rahotep_nofret', 'artifact.narmer_palette'],
  ),
  Artifact(
    id: 'artifact.rahotep_nofret',
    museumId: mockMuseumId,
    name: 'Statue of Rahotep and Nofret',
    periodKey: 'old_kingdom',
    period: 'Old Kingdom',
    dynasty: 'Fourth Dynasty',
    material: 'Limestone',
    discovery: 'Mastaba of Meidum',
    color: 0xffbb8730,
    imageAsset: 'assets/images/artifacts/rahotep_nofret.jpg',
    relatedArtifactIds: ['artifact.statue_khafre'],
  ),
  Artifact(
    id: 'artifact.akhenaten_colossus',
    museumId: mockMuseumId,
    name: 'Colossal Statue of Akhenaten',
    periodKey: 'new_kingdom',
    period: 'New Kingdom',
    dynasty: 'Eighteenth Dynasty',
    material: 'Sandstone',
    discovery: 'Karnak, 1925',
    color: 0xff8e764c,
    imageAsset: 'assets/images/artifacts/akhenaten.jpg',
    relatedArtifactIds: ['artifact.ramesses_ii_colossus', 'artifact.narmer_palette'],
  ),
  Artifact(
    id: 'artifact.ramesses_ii_colossus',
    museumId: mockMuseumId,
    name: 'Colossus of Ramesses II',
    periodKey: 'new_kingdom',
    period: 'New Kingdom',
    dynasty: 'Nineteenth Dynasty',
    material: 'Red granite',
    discovery: '1820, Mit Rahina',
    color: 0xffc09a58,
    imageAsset: 'assets/images/artifacts/ramesses_ii.jpg',
    relatedArtifactIds: [
      'artifact.akhenaten_colossus',
      'artifact.narmer_palette',
      'artifact.statue_khafre',
    ],
    museum: 'Grand Egyptian Museum, Giza',
  ),
];

Artifact? artifactForId(Object? id) {
  if (id is! String) return null;
  for (final artifact in artifacts) {
    if (artifact.id == id) return artifact;
  }
  return null;
}
