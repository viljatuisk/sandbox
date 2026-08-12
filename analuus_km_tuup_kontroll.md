# Analüüs: KM tüübi õigsuse kontrollimehhanism (APA KMD 2027)

**Seotud:** apa_kmd.html, ticket_apa_kmd_etapp1.txt
**Küsimus:** kuidas vältida olukorda, kus tehingul kasutatakse vale käibemaksukoodi ja rida satub aruandes valesse KM tüüp kategooriasse?

---

## 1. Probleem

**Praegune KMD (INF A ja B):** rida satub INF osasse ainult siis, kui täidetud on MITU sõltumatut tingimust korraga:
- Operatsioonikuupäev perioodis
- Kliendi/hankija kaardi väli Tüüp = "Ettevõte" või "Riigiasutus" ja Reg.nr korrektselt täidetud
- Arvel/kandel on KM kood (INF A) või sisendkäibemaksu konto (INF B), mis on aruande seadistuses märgitud A/B valikuga
- 1000 EUR piirmäär tehingupartneri kohta

Ehk kategoriseerimist "valvab" mitu allikat: **konto + KM kood + partneri tüüp + reg.nr**. Kui üks on vale, jääb rida sageli lihtsalt INF-ist välja (nähtav kõrvalekalle) või teine tingimus püüab vea kinni.

**Uus APA KMD:** INF A/B osa ei ole. Rea kategooria (M_101, O_101, S_101, A_101 ...) tuletatakse **AINULT käibemaksukoodile märgitud KM tüübist** (Müügi/Ostu/Soetuse/Arvestusliku kande KM tüüp). See on **üksik nõrk lüli**:

> Kui tehingul kasutatakse vale KM koodi (nt 0% ühendusesisese müügi kood tavalisel siseriiklikul 24% müügil), satub rida valesse KM tüüpi ja seega valesse deklaratsiooni kategooriasse. Ükski teine tingimus ei püüa viga automaatselt kinni.

**Järeldus:** on vaja Directo-poolset andmete kontrolli, mis kontrollib, et tehingul on kasutatud õige KM tüübiga käibemaksukoodi.

---

## 2. Miks see on oluline

- MTA saab andmed tehingute kaupa ja kategooriate lõikes. Vale kategooria = vale deklaratsioon.
- Vead avastatakse hilja (MTA tagasiside, audit) -> parandused, selgitused, riskid.
- Automaatne eelkontroll Directos hoiab vead kinni enne saatmist ja vähendab tugiküsimusi.

---

## 3. Kontrollimehhanism (kahetasandiline)

Kontroll on kõige tugevam, kui KM tüüpi ristvõrreldakse **sõltumatute tunnustega**, mis tehingul niikuinii olemas on (konto, määr, partner/riik, dokumendi liik, summa suund).

### TASAND 1 — Käibemaksukoodi seadistuse kontroll (master-andmed)

Kontrollitakse KM koodi kaarti (ühekordne, enne kasutamist):

| Kontroll | Reegel | Raskusaste |
|---|---|---|
| KM tüübi prefiks vs väli | "Müügi KM tüüp" väärtus peab algama M_; "Ostu KM tüüp" O_; "Soetuse KM tüüp" S_; "Arvestusliku kande KM tüüp" A_ | Viga |
| Määr vs KM tüüp | KM koodi määr (%) peab sobima KM tüübi lubatud määraga (nt 0%-tüüp ei tohi olla 24% koodil) | Viga |
| Tüüp olemas | Vähemalt üks KM tüüp väli peab olema täidetud, muidu kood ei mäpi aruandesse | Hoiatus |

See tasand välistab valesti seadistatud koodid enne, kui neid üldse tehingutel kasutatakse.

### TASAND 2 — Tehingu-tasandi ristkontroll (aruande "Kontrolli" nupp)

Iga tehingurea kohta võrreldakse määratud KM tüüpi sõltumatute tunnustega:

| # | Kontroll | Tingimus / kahtlus | Raskusaste |
|---|---|---|---|
| R1 | **Dokumendi kontekst vs KM tüüp** | Müügidokumendil kasutatud KM koodil peab olema "Müügi KM tüüp" täidetud (ost -> Ostu/Soetuse; kanne -> vastav). Kui puudub -> kood on vales kontekstis | Viga |
| R2 | **Konto klass vs KM tüüp perekond** | Müügitulu konto (4...) real peab KM tüüp olema M_; kulu/sisend konto (5...) real O_/S_. Vastuolu -> tõenäoliselt vale kood | Hoiatus |
| R3 | **Määr vs KM tüüp** | Rea KM% peab kuuluma KM tüübi lubatud määrade hulka (nt M_201/M_211/S_ = 0%; M_101 = 24/22/13/9%) | Hoiatus/Viga |
| R4 | **KM maa + KM asumaa + KMKR vs KM tüüp** | KM käitlustüüp tuletatakse partneri **KM maa** väljast ja peab ühtima KM koodi KM tüübiga; **KM asumaa** + KMKR annavad aruande riigitunnuse ja peavad olema omavahel kooskõlas. Vt täpsustus allpool | Hoiatus |
| R4c | **KM maa = välisriik -> ei kuulu Eesti KMD-sse** | Kui KM maa on konkreetne välisriik (nt Soome), deklareeritakse müük seal, mitte Eesti KMD-s. Eesti KM tüüp (M_101 jne) real -> viga | Viga |
| R5 | **Summa suund vs KM tüüp** | Müük (M_) tavaliselt käive kreeditis; ost/sisend (O_) deebetis. Ootamatu suund -> kontrolli | Hoiatus |
| R6 | **Kohustuslikud väljad tüübi kaupa** | Ühendusesisene -> ostja riik kohustuslik; kreeditarve (negatiivne) -> algse arve kuupäev; juriidiline partneri perioodi kogusumma >= 1000 EUR -> reg.nr kohustuslik | Viga |

**Loogika:** kui KM tüüp on üksinda "otsustaja", siis need reeglid annavad talle **teised sõltumatud tunnistajad**. Kui KM tüüp läheb vastuollu konto, määra, riigi või konteksti signaaliga, on suure tõenäosusega kasutatud vale KM koodi.

### R4 täpsustus: kolm riigivälja kliendi/hankija kaardil

Kliendi/hankija kaardil on kolm eri "maad" ja igal on kontrollis oma roll. Vale välja kasutamine annaks valehäireid, seega on oluline eristada:

| Väli | Tähendus | Roll R4 kontrollis |
|---|---|---|
| **Asumaa** | Partneri tegelik asukoha riik | EI kasutata KM kategoriseerimiseks. Ainult taust/info. Partner võib asuda ühes riigis, aga olla KM-kohustuslasena registreeritud teises |
| **KM maa** | Käibemaksukäsitluse piirkond/tüüp (siseriiklik / EÜ / väljaspool EÜ) | **Peamine käitlustüübi signaal.** Ristvõrreldakse KM koodi KM tüübiga |
| **KM asumaa** | Riik, kus partner on SELLE tehingu jaoks KM-kohustuslasena registreeritud | **Aruande "Riik" (ostja riigi tunnus) allikas** + KMKR prefiksi kontroll |

**Kontrolli loogika kahes osas:**

1. **Käitlustüüp: KM maa <-> KM tüüp** (peamine ristkontroll)
   - KM maa = siseriiklik -> KM tüüp peab olema siseriiklik (M_101, M_301 ...); MITTE ühendusesisene ega eksport
   - KM maa = EÜ (EL) -> KM tüüp peab olema ühendusesisene (M_201, M_202, M_203, M_204, M_205, M_206, M_207, S_101, S_102, S_103, O_401, O_402 ...)
   - KM maa = väljaspool EÜ -> KM tüüp peab olema eksport (M_208, M_209)
   - Kui KM maa ütleb üht ja KM koodi KM tüüp teist -> tõenäoliselt vale KM kood.

2. **Riigitunnus ja KMKR: KM asumaa <-> KMKR <-> aruande Riik**
   - Ühendusesiseste tüüpide korral: KM asumaa peab olema EL riik ja partneri KMKR täidetud; KMKR prefiks peab vastama KM asumaa riigikoodile (nt KM asumaa = FI -> KMKR algab "FI").
   - Aruande "Riik" (ostja riigi tunnus) võetakse **KM asumaast**, MITTE Asumaast.
   - Kui Asumaa ja KM asumaa erinevad (nt Asumaa väljaspool EL, aga KM asumaa EL riik), on see legitiimne (mitteresident, kes on EL-is KM-kohustuslasena registreeritud) - anda kõige rohkem nõrk info-hoiatus, mitte viga.

**Kokkuvõte:** käitlustüübi õigsust kontrollib **KM maa vs KM tüüp**; riigitunnuse ja KMKR õigsust kontrollib **KM asumaa**. Asumaa jääb KM kontrollist välja.

### R4c: KM maa = välisriik -> müük ei kuulu Eesti KMD-sse

Eraldi (ja oluline) juht: kui kliendi/hankija kaardil on **KM maa = konkreetne välisriik** (nt "Soome"), tähendab see, et müük deklareeritakse **selles riigis** (ettevõttel on seal KM-registreering) ja see **ei tohiks Eesti APA KMD-s üldse olla**. Kui tehingul on kasutatud KM koodi, mis mäpib Eesti KMD tüüpi (nt M_101), satub rida siiski Eesti aruandesse - see on viga.

- Tähtis eristus: **KM maa = "EÜ"** (ühendusesisene) -> deklareeritakse Eestis 0% määraga (M_201 jne). **KM maa = "Soome"** (konkreetne välisriik) -> deklareeritakse Soomes, EI kuulu Eesti KMD-sse.
- Reegel R4c: kui KM maa on välisriigi KM-registreeringu maa ja real on Eesti KM tüüp -> **Viga** ("müük deklareeritakse [riik]-s, ei tohiks Eesti KMD-s olla").
- Näide prototüübis: MA10012, KM maa "Soome", KM kood M_101 -> R4c viga.

---

## 4. Väljund kasutajale

- **Kontrollaruanne / hoiatuste nimekiri** enne e-MTA-le saatmist (nagu praegu on "Kontrolli" nupp EMTA tagasiside jaoks, aga see käib LOKAALSELT Directos enne saatmist).
- Iga kahtlane rida: dokument/arve nr, KM tüüp, rikutud reegel, lühiselgitus ja soovitus (nt "Müügitulu kontol 4101 on ostu tüüp O_101 - kontrolli KM koodi").
- Kaks raskusastet:
  - **Viga** — blokeerib saatmise, kuni parandatud (nt R1, R6).
  - **Hoiatus** — lubab edasi, aga kuvab loendis (nt R2, R4), sest võib olla põhjendatud erand.
- Parandus: kasutaja muudab tehingul KM koodi (või KM tüüpi otse, kui see on dokumendil muudetav - vt esitlus lk 9).

---

## 5. Rakendamine Directos

- **Tasand 1** — KM koodi kaardi salvestamisel (valideerimine kohe seadistuses).
- **Tasand 2** — aruande lokaalne "Kontrolli KM tüüp" nupp, mis jookseb reeglid enne saatmist läbi ja kuvab hoiatuste nimekirja.
- **Prototüüp** — apa_kmd.html-i saab lisada demonstratsioonina "Kontrolli KM tüüp" nupu, mis markeerib kahtlased read (sarnaselt olemasoleva e-MTA vea-badge loogikaga).

---

## 6. Lahtised küsimused

1. Kas kontroll peaks olema **blokeeriv** (ei luba saata enne parandust) või ainult **hoiatav**? Ettepanek: R1 ja R6 blokeerivad, ülejaanud hoiatavad.
2. Konto klassi reegel (R2) - kas 4... = müük ja 5... = ost kehtib kliendi kontoplaanis alati, või on vaja seadistatavat vastavustabelit (konto -> lubatud KM tüüp perekond)?
3. Kas lubatud (KM tüüp -> KM määr) ja (KM tüüp -> EL/kolmas riik) vastavused tulevad MTA klassifikaatorist (KMDTYYP2026ap) automaatselt, või peab Directo neid ise hooldama?
4. Kas kontroll käib kõigi perioodi tehingute peal korraga (aruandes) või ka dokumendi salvestamisel (varajane hoiatus)?
4b. R4: millised on kliendi/hankija kaardi **KM maa** väärtused kliendi seadistuses (siseriiklik / EÜ / väljaspool EÜ vms) ja kuidas need täpselt mäpivad KM tüüp perekondadesse? Kas "Riik" aruandes tuleb kindlalt **KM asumaast** (mitte Asumaast)?
5. Millises etapis kontroll ehitatakse - see EI ole I etapp (kuvamine), vaid eraldi "Kontroll/valideerimine" etapp. Kas teha eraldi Directo master sündmus + Notioni taskid?
