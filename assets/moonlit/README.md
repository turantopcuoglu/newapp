# Original approved artwork

These PNG files are byte-for-byte copies of the approved design boards. No new image generation or replacement illustration was used for this implementation. `ReferenceCrop` in `lib/screens/wellness/moonlit_assets.dart` renders source rectangles from the original boards; Flutter supplies the interactive text, controls and layout.

| Asset | Source under `docs/design/moonlit-theme/screens/` | SHA-256 |
|---|---|---|
| daily.png | 01-gunluk-rehber-v2.png | 31DFFD17B83916DB31142BC8FA64CEA046261FFAFF3A95EF07EC1208ABD9FDE5 |
| food.png | 02-besin-ve-tarif.png | 99F2D75CD7ACE0378BCC11C4E1D40EDDB8F2A59681056E7CF02B0C1099679C73 |
| ritual.png | 03-nefes-ve-uyku.png | 452C3F458794956DFD20A06995E9F9F055BEF67A7B455E959C92A0184235434C |
| journey.png | 04-gelisim-ve-profil.png | 1B59B22ABF757D39E941302080C9670DD2A30F2FF57C5702983A4FC737075193 |

The application uses the original food photography, ingredient bowls, crescent, horizon and breathing orb. `journey.png` remains bundled as the matching progress/profile reference; those screens use native controls and the shared original horizon. Crop coordinates are relative to the boards' 1536 × 1024 canvas. SHA-256 equality with all four sources was checked on 2026-09-07.
