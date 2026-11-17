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
    this.museum = 'Egyptian Museum, Cairo',
    this.restoreAvailable = false,
  });

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
  final String museum;
  final bool restoreAvailable;

  String get arabicName => switch (id) {
    'artifact.narmer_palette' => 'لوحة نارمر',
    'artifact.statue_khafre' => 'تمثال خفرع',
    'artifact.rahotep_nofret' => 'تمثالا رحوتب ونوفرت',
    'artifact.akhenaten_colossus' => 'تمثال أخناتون الضخم',
    'artifact.ramesses_ii_colossus' => 'تمثال رمسيس الثاني',
    _ => name,
  };

  String get arabicPeriod => switch (periodKey) {
    'predynastic' => 'ما قبل الأسرات المتأخر',
    'old_kingdom' => 'الدولة القديمة',
    'new_kingdom' => 'الدولة الحديثة',
    _ => period,
  };

  String get arabicDynasty => switch (dynasty) {
    'First Dynasty' => 'الأسرة الأولى',
    'Fourth Dynasty' => 'الأسرة الرابعة',
    'Eighteenth Dynasty' => 'الأسرة الثامنة عشرة',
    'Nineteenth Dynasty' => 'الأسرة التاسعة عشرة',
    _ => dynasty,
  };

  String get arabicMaterial => switch (material) {
    'Slate' => 'الأردواز',
    'Diorite' => 'الديوريت',
    'Limestone' => 'الحجر الجيري',
    'Sandstone' => 'الحجر الرملي',
    'Red granite' => 'الجرانيت الأحمر',
    _ => material,
  };

  String get arabicDiscovery => switch (id) {
    'artifact.narmer_palette' => '١٨٩٨، هيراكونبوليس',
    'artifact.statue_khafre' => 'هضبة الجيزة',
    'artifact.rahotep_nofret' => 'مصطبة ميدوم',
    'artifact.akhenaten_colossus' => 'الكرنك، ١٩٢٥',
    'artifact.ramesses_ii_colossus' => '١٨٢٠، ميت رهينة',
    _ => discovery,
  };

  String get arabicMuseum => switch (museum) {
    'Egyptian Museum, Cairo' => 'المتحف المصري، القاهرة',
    'Grand Egyptian Museum, Giza' => 'المتحف المصري الكبير، الجيزة',
    _ => museum,
  };
}

const mockMuseumId = 'museum.grand_egyptian_giza';

// Contract-shaped preview fixtures until museum data is supplied by the backend.
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
    museum: 'Grand Egyptian Museum, Giza',
    restoreAvailable: true,
  ),
];

Artifact? artifactForId(Object? id) {
  if (id is! String) return null;
  for (final artifact in artifacts) {
    if (artifact.id == id) return artifact;
  }
  return null;
}
