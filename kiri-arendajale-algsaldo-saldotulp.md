# Muudatus: Detailvaates Algsaldo/Lõppsaldo → Saldo tulpa (märgiga)

## Probleem

Detailvaates kuvatakse konto **Algsaldo** (grupipäise real) ja **Lõppsaldo**
(grupi kokkuvõtte real) väärtus praegu **Deebeti tulbas**. Negatiivse aktivakonto
puhul annab see kujul `−3 272,64` **Deebeti all miinusmärgiga**, mis on eksitav.

## Miks see vale on

Selles aruandes on tulpadel selge tähendus:

- **Deebet ja Kreedit = perioodi käive** (rea liikumised). Tõestus: KOKKU rea
  Deebet on perioodi deebetkäive — algsaldot sinna ei liideta.
- **Saldo tulp = jooksev saldo, märgiga** (nt `−3 249,64`, `−3 248,50`…).

**Algsaldo ja Lõppsaldo on saldod, mitte käive** — seega ei kuulu nad
käibetulpadesse (Deebet/Kreedit). Saldo väärtuse koht on **Saldo tulp**, kus
märk (±) näitab suunda: negatiivne = kreeditsaldo.

## Kuidas teised teevad

- **Vana Directo** näitab Algsaldot ühe **märgiga väärtusena** (mitte pooltesse
  jaotatuna) — sama loogika.
- **Teised ERP-id** (SAP FBL3N, MS Dynamics BC, NetSuite, Xero/QuickBooks) teevad
  kontokaardi/detailaruandes samamoodi: **märgiga jooksev saldo**, Deebet/Kreedit
  = ainult käive.

## Lahendus

**Detailvaade:** Algsaldo ja Lõppsaldo väärtus liigub **Deebeti tulbast → Saldo
tulpa**, märgiga. Deebet ja Kreedit jäävad neil ridadel **tühjaks**.

## Oluline: Saldeerimata vaade jääb erinevaks (ja see on õige)

Deebet/kreedit-poolte loogika (aktiva miinussaldo → Kreediti poolel) **kuulub**
**Saldeerimata vaatesse**, mis on proovibilansi-tüüpi (bruto) esitus. Seal
näidataksegi Alg- ja Lõppsaldo **Deebet ja Kreedit tulpadesse jaotatuna**
(loomulikul poolel, plussina) — ja prototüübis see juba töötab nii
(`data-algsaldo-dr/-cr`, `data-loppsaldo-dr/-cr`).

Kokkuvõttes:

| Vaade | Alg-/Lõppsaldo kuva |
|---|---|
| **Detailvaade** (netto, kande-detailid) | märgiga arv **Saldo** tulbas |
| **Saldeerimata** (bruto, proovibilanss) | **Deebet + Kreedit** tulpadesse jaotatud |

## Märkus

Lõpliku kuvakonventsiooni peaks kinnitama raamatupidaja (maja sisereeglid).
Prototüübis (`pearaamat-prototyyp-versioon2.html`) on muudatus sisse viidud ja
näitab soovitud lõpptulemust.
