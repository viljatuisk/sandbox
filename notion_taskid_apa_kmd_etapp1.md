# APA KMD 2027 aruanne - I etapp - Notioni taskid

**Directo master sundmus:** Andmepohine KMD (APA KMD 2027) aruanne - I etapp
**Prototuup:** apa_kmd.html (GitHub: viljatuisk/sandbox)
**Detailne ticket:** ticket_apa_kmd_etapp1.txt

Iga alljargnev task on eraldi Notioni kirje. Arendaja markib staatuse (Tegemata / Toos / Valmis) Notionis. Kogu etapi arendus commititakse Directo master sundmuse raames.

---

## T1. Andmete kogumine ja KMD tuubi tuletamine

**Kirjeldus:** Koguda valitud perioodi tehingud ja toimingud (muugi- ja ostuarved, kreedit- ja ettemaksuarved, poordmaksustatavad soetused, arvestuslikud kanded) ning tuletada igale reale KMD tuup KM koodi kaardi uutest valjadest konteksti jargi (Muugi/Ostu/Soetuse/Arvestusliku kande KM tuup).

**Definition of Done:**
- [ ] Tehingud kogutakse valitud perioodi kohta koigist asjakohastest dokumenditüüpidest
- [ ] KMD tuup tuletatakse KM koodi kaardi valjast konteksti jargi: muuk -> M_, ost -> O_, soetus -> S_, arvestuslik kanne -> A_
- [ ] KM% (maksumaar) tuleb KM koodilt
- [ ] Iga veeru andmed tulevad oigest allikast (vt ticket sektsioon ANDMETE PARITOLU)
- [ ] Partneri ja grupi liikme nimi kuvatakse, aga ei kuulu andmemudelisse XML jaoks

---

## T2. Aruandetabel - Tehingupaevik (pohitabel + grupeering)

**Kirjeldus:** Kuvada kogutud tehingud tabelina kolmetasandilise grupeeringuga ja vaikeveergudega.

**Definition of Done:**
- [ ] Kolmetasandiline grupeering: KM sektsioon -> alagrupp -> KMD tuup (M_101 jne)
- [ ] Vaikeveerud oiges jarjekorras: #, KMD tuup, KMD tuubi sisu, KM%, Deklareeritav summa, KM (EUR), TP/Arve tunnus, Partneri reg/KMKR, Partneri nimi, Koodi taps., Grupp kat, Grupi liikme reg, Grupi liikme koodi taps., Grupi liikme nimi, Riik, Riigi taps., Arve nr, Ettemaks nr, Kuupaev, Arve kogusumma km/ta, Kreeditkp
- [ ] KMK% (Directo kaibemaksukood) veergu EI kuvata

---

## T3. "Vali tulbad" veergude valija

**Kirjeldus:** Aruandetabeli tooriistareal veergude valija, millega saab veerge peita/naidata. Veergude jarjekorda EI SAA muuta.

**Definition of Done:**
- [ ] Kruvikeeraja nupp avab veergude valija paneeli
- [ ] Linnukesega saab veeru peita ja tagasi tuua
- [ ] Veerge EI SAA lohistades umber jarjestada (jarjekord fikseeritud)
- [ ] Otsingukast filtreerib veergude nimekirja
- [ ] "Taasta algseaded" taastab vaikeveerud
- [ ] Valitud veergude komplekt jaab kasutajale meelde (pusiv)

---

## T4. Filtrid - periood, otsing, KM tuup

**Kirjeldus:** Filtripaneel perioodi, otsingu ja KM tuubi jargi.

**Definition of Done:**
- [ ] Periood algus/lopp - kalendrivalik (ikoonist)
- [ ] Periood kiirsisestus: kuu number (nt 3 = 01.03-31.03 jooksev aasta), !N = eelmise aasta sama kuu
- [ ] Suvaline vahemik sisestatav (nt 10 paeva)
- [ ] Otsing partneri / arve numbri / koodi jargi
- [ ] KM tuubi filter
- [ ] Saatja nimi ja Registrikood EI ole filtrites (tulevad ettevotte seadistusest)
- [ ] Pankrotiperioodi tunnus asub Seadistuste all, mitte filtrites

---

## T5. Aruandetabeli juhtnupud (voldikud)

**Kirjeldus:** Grupitasandite avamine/sulgemine.

**Definition of Done:**
- [ ] Sulge koik / Ava koik voldikud
- [ ] Sulge alamgrupid / Ava alamgrupid

---

## T6. Kokku KM maarade loikes (koondrida)

**Kirjeldus:** Aruande koondrida KM maarade loikes koos tasuda/tagasi saada arvutusega.

**Definition of Done:**
- [ ] Koondrida KM maarade loikes (M - Muuk, A - Arv. kanded, S - Poordmaks, O - Sisend-KM)
- [ ] Arvutab kokku tasuda / tagasi saada summa
- [ ] Vordlus bilansiga EI ole selles etapis (jaab jargmisse etappi)

---

## Lahtised kusimused (enne arendust ule vaadata)

1. Kust andmed tulevad - reaalne Directo baas voi piiratud andmehulk (uks periood)?
2. Segaarved (mitu KMD tuupi uhel arvel) - kas jagatakse ridadeks kogumisel?
3. Mis juhtub, kui KM koodi kaardil vastav KMD tuubi vali on taitmata (valja jatta / eraldi "maaramata" grupp / hoiatus)?
4. TP/Arve tunnus (identifierCategory) - automaatne tuletus voi dokumendilt? Kust 101/102/104?
5. Partneri koodi taps. (ARIREGISTRIKOOD / KMKR_NUMBER / MRR_KOOD) - automaatne tuletus partneri kaardilt?
