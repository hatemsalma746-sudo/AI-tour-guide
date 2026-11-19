# Artifact and reconstruction API handoff

The app must associate images with the stable `artifact.id`, not with a file name. Before and after images may have unrelated names and extensions because the API returns their URLs directly.

## Suggested artifact response

```json
{
  "id": "artifact.ramesses_ii_colossus",
  "museumId": "museum.grand_egyptian_giza",
  "name": "Colossus of Ramesses II",
  "nameArabic": "تمثال رمسيس الثاني",
  "periodKey": "new_kingdom",
  "period": "New Kingdom",
  "periodArabic": "الدولة الحديثة",
  "dynasty": "Nineteenth Dynasty",
  "dynastyArabic": "الأسرة التاسعة عشرة",
  "material": "Red granite",
  "materialArabic": "الجرانيت الأحمر",
  "discovery": "1820, Mit Rahina",
  "discoveryArabic": "١٨٢٠، ميت رهينة",
  "imageUrl": "https://cdn.example.org/artifacts/4f8a/original.webp",
  "museum": {
    "id": "museum.grand_egyptian_giza",
    "name": "Grand Egyptian Museum, Giza",
    "nameArabic": "المتحف المصري الكبير، الجيزة"
  },
  "relatedArtifactIds": ["artifact.akhenaten_colossus"],
  "reconstruction": {
    "beforeImageUrl": "https://cdn.example.org/reconstructions/abc/before.webp",
    "afterImageUrl": "https://cdn.example.org/reconstructions/abc/after.webp"
  }
}
```

`Artifact.fromJson` maps this response to the Flutter model. Flutter derives `reconstruction.status`: it is `ready` only when both image URLs are valid HTTP(S) URLs; otherwise it is `pending`. The backend does not need to send a status value, and Restore stays hidden until both URLs arrive. No image filename convention is required.

For Screen 19, the same artifact response can include `removalYear`, `removalInformation`, and `locationStory` (plus Arabic variants) when those facts are verified. If any field is absent, the screen shows an unavailable state instead of inventing it.

The same before/after URLs feed Screen 17's comparison slider. Network-image failures fall back to the artifact photo and do not break the screen. Use HTTPS URLs that remain valid long enough for the screen to load; for expiring signed URLs, the API should issue fresh URLs when returning the artifact/reconstruction response.

## Still needed during API integration

The project currently uses local preview fixtures for routes and artifact lookup. The backend integration must replace those fixtures with an API-backed repository that stores the parsed artifacts by `id`; related routes already pass stable IDs. The endpoint, authentication, error format, and exact backend JSON keys must be agreed with the backend team before the network layer can be connected.
