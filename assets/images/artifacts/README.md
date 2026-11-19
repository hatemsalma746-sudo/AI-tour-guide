# صور شاشة المقارنة قبل وبعد

ضع صور المقارنة في المجلدين `before` و`after` داخل هذا المجلد. تمت إضافة المجلدين إلى `pubspec.yaml` بالفعل.

استخدم نفس اسم ملف الصورة الأساسية لكل قطعة داخل المجلدين. اسم القطعة يُستخرج تلقائيًا من بياناتها؛ لا تضف `before` أو `after` إلى اسم ملف الصورة:

مثال: صورة القطعة الأساسية اسمها `ramesses_ii.jpg`، لذلك ضع صورة قبل في `before/ramesses_ii.png` وصورة بعد في `after/ramesses_ii.webp`. يختار التطبيق الامتداد الموجود تلقائيًا من `.jpg` أو `.jpeg` أو `.png` أو `.webp` أو `.gif` أو `.bmp` أو `.wbmp`.

شاشة الترميم تستخدم صورة `before` على اليسار وصورة `after` على اليمين، ويمكن سحب الفاصل بينهما حتى الطرفين. إذا لم تُضف إحدى الصورتين، تعرض الشاشة الصورة الأساسية للقطعة تلقائيًا؛ جهة «قبل» تظهر بتأثير داكن مؤقت. لا حاجة لتغيير كود الشاشة عند إضافة الصور.

زر `Restore` في تفاصيل القطعة يظهر تلقائيًا فقط عندما يجد التطبيق صورة مطابقة في المجلدين معًا `before` و`after`. حذف إحدى الصورتين يخفي الزر بعد إعادة تشغيل التطبيق.

## صور `after` المؤقتة للاختبار

الصور الموجودة حاليًا داخل `after` صور مجانية لقطع مختلفة، وُضعت فقط لاختبار اختلاف جهة المقارنة وظهور زر Restore. ليست صور ترميم حقيقية. استبدلها بصور الترميم الصحيحة عند توفرها.

| الملف داخل `after` | الصورة الأصلية المستخدمة | الترخيص |
| --- | --- | --- |
| `narmer_palette.jpg` | `statue_khafre.jpg` | CC0 1.0 |
| `statue_khafre.jpg` | `rahotep_nofret.jpg` | CC0 1.0 |
| `rahotep_nofret.jpg` | `akhenaten.jpg` | ملكية عامة |
| `akhenaten.jpg` | `ramesses_ii.jpg` | CC BY-SA 4.0 |
| `ramesses_ii.jpg` | `narmer_palette.jpg` | CC0 1.0 |

## الصور الأساسية الحالية ومصادرها

| الملف | القطعة | المصدر والترخيص |
| --- | --- | --- |
| `narmer_palette.jpg` | لوحة نارمر | [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:The_Narmer_Palette_(53250074700).jpg)، Mustang Joe، CC0 1.0 |
| `statue_khafre.jpg` | تمثال خفرع | [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Statue_of_Khafre_(Kefren),_Diorite,_Giza,_4th_Dynasty,_c._2500_BC_(9797372103).jpg)، Gary Todd، CC0 1.0 |
| `rahotep_nofret.jpg` | رحوتب ونوفرت | [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Rahotep_and_Nofret.JPG)، A. Parrot، CC0 1.0 |
| `akhenaten.jpg` | تمثال أخناتون الضخم | [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Akenaton.jpg)، qwelk، ملكية عامة |
| `ramesses_ii.jpg` | تمثال رمسيس الثاني في ميت رهينة | [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:The_power_Ramses_II.jpg)، Adelbayoumi، CC BY-SA 4.0 |

عند استخدام صورة مرخّصة، احتفظ ببيانات صاحبها وترخيصها مع المشروع. صورة رمسيس مرخّصة CC BY-SA 4.0، ويلزم ذكر المصدر والترخيص إذا عُدّلت أو أُعيد توزيعها.
