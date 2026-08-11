# APA KMD 2027 aruanne - I etapp - Notioni taskid

**Directo master sundmus:** Andmepohine KMD (APA KMD 2027) aruanne - I etapp
**Prototuup:** apa_kmd.html (GitHub: viljatuisk/sandbox)
**Detailne ticket:** ticket_apa_kmd_etapp1.txt

Iga alljargnev task on eraldi Notioni kirje. Arendaja markib staatuse (Tegemata / Toos / Valmis) Notionis. Kogu etapi arendus commititakse Directo master sundmuse raames.

---

## T1. Andmete kogumine ja KMD tuubi tuletamine

Aruanne kogub valitud perioodi tehingud ja toimingud Directost (muugi- ja ostuarved, kreedit- ja ettemaksuarved, poordmaksustatavad soetused, arvestuslikud kanded) ning grupeerib need KMD tuubi (KMDTYYP2026ap) jargi. Iga tehingurida laheb tabelisse uhe KMD tuubi reana.

**KMD tuubi maaramine (kaibemaksukoodi kaardilt):**

Arendaja on lisanud kaibemaksukoodi (KM kood) kaardile 4 uut valja, mille asetajaks on KM klassifikaatorite nimekiri (KMDTYYP2026ap: M_101, O_101, S_101, A_101 jne):
- Muugi KM tuup
- Ostu KM tuup
- Soetuse KM tuup
- Arvestusliku kande KM tuup

Igale dokumendile (muugiarve, ostuarve, kulutus, kanne) lisatakse vali KM tuup. Vaartus asetub automaatselt KMK kaardi kaudu, kuid kasutaja saab seda vajadusel dokumendil kasitsi muuta. KM tuup asetub jargmiselt (esitlus lk 9):
- Muugiarve -> KMK kaardi "Muugi KM tuup" -> nt M_101
- Ostuarve ja Kulutus -> KMK kaardi "Ostu KM tuup" -> nt O_101
- Ostuarve ja Kulutus (poordmaksustatav) -> KMK kaardi "Soetuse KM tuup" -> nt S_101
- Kanne (konto tuubi jargi): "Muugi KM tuup" (nt sularaha muugi koondkanne -> M_101), "Ostu KM tuup" (nt kulukanne -> O_101), "Arvestusliku kande KM tuup" (nt impordi maksustatava vaartuse muutmine -> A_101)

Nii saab sama KM kood eri kontekstis anda erineva KMD tuubi. KM% (maksumaar) tuleb samuti KM koodilt.

**Veergude andmeallikad (vasakul veerg, paremal Directo andmeallikas):**
- KMD tuup -> tehingu KM koodi kaardi vastav valja vaartus (Muugi/Ostu/Soetuse/Arvestusliku kande KM tuup)
- KMD tuubi sisu -> KMDTYYP2026ap klassifikaatori kirjeldus (staatiline, tuubi jargi)
- KM% -> tehingurea maksumaar (KM koodilt)
- Deklareeritav summa -> tehingurea maksustatav vaartus (muugil kaibe summa; ostul/soetusel sisendkaibemaksu summa voi maksustatav vaartus vastavalt tuubile)
- KM (EUR) -> kaibemaksu summa (maksustatav vaartus x maar; voi tehingult)
- TP/Arve tunnus (identifierCategory) -> EI ole lihtne otsing, vaid tuletatakse loogika alusel (vt allpool "TP/Arve tunnuse ja agregeerimise loogika"). Vaartused: 100 / 101 / 103 / 104 (juriidiline), 200 (fuusiline), 300 (KM-grupi liige)
- Partneri reg/KMKR -> tehingupartneri (klient/hankija) registrikood voi KMKR number (kliendi-/hankijakaardilt)
- Partneri nimi -> partneri nimi (ainult kuvamiseks; XML-i EI lahe)
- Koodi taps. -> partneri koodi liik: ARIREGISTRIKOOD / KMKR_NUMBER / MRR_KOOD (tuletatakse kliendi-/hankijakaardilt)
- Grupp kat -> 300, kui partner on KM-grupi liige
- Grupi liikme reg -> KM-grupi liikme registrikood voi mitteresidendi kood
- Grupi liikme koodi taps. -> grupi liikme koodi liik (ARIREGISTRIKOOD / KMKR_NUMBER / MRR_KOOD)
- Grupi liikme nimi -> grupi liikme nimi (ainult kuvamiseks; XML-i EI lahe)
- Riik -> ostja riigi tunnus (EL riigid, uhendusesiseste tehingute puhul)
- Riigi taps. -> riigi roll (RR_ostja)
- Arve nr -> dokumendi (arve) number
- Ettemaks nr -> ettemaksuarve number
- Kuupaev -> arve voi ettemaksuarve kuupaev
- Arve kogusumma km/ta -> arve kogusumma ilma kaibemaksuta
- Kreeditkp -> kreeditarve esialgse arve kuupaev

**TP/Arve tunnuse (identifierCategory) ja agregeerimise loogika (esitlus lk 10-11):**

Partneri andmed tulevad kliendi-/hankijakaardilt (olemasolevad valjad, kaarti sisuliselt muuta ei tule):
- Isiku tuup (juriidiline / fuusiline) -> maarab 100 vs 200
- KMKR -> naitab, kas tegemist valismaa isikuga (uhendusesisesed tehingud)
- "Salastatud" (uus vaartus Tuup valjas, arvel muudetav) -> 101 (partner esitatakse anonuumselt)

1000 EUR piirmaar - tehingupartneri PERIOODI kogusumma jargi:
- Fuusiline isik -> ALATI agregeeritult -> 200
- Juriidiline, partneri perioodi kogusumma < 1000 EUR -> agregeeritult, partneri andmeid ei esitata -> 103
- Juriidiline, kogusumma >= 1000 EUR -> detailselt arve kaupa, registrikood kohustuslik -> 100
- Segaarve (mitu KM kasitlust uhel arvel) -> lisatunnus 104, piirmaar kehtib endiselt

Arveridade koondamine:
- Sama KMD tuubiga read samalt arvelt summeeritakse uhte kirjesse (nt 10-realine arve 5x24% + 5x9% -> 2 kirjet).

Segaarve reegel (kasvoi uks maksustatav rida arvel):
- Kogu arve read tuleb esitada detailselt. Nt juriidiline, 22% kaive 1000 EUR + maksuvaba 3000 EUR -> M_101 1000 EUR (104) + M_301 3000 EUR (104). Maksuvaba (M_301) tuleb detailselt segaarve tottu.
- Sama kehtib, kui partneri MONE TEISE arve tottu on perioodi kogusumma >= 1000 EUR.

---

## T2. Aruandetabel - Tehingupaevik

- Tehingute nimekiri kolmetasandilise grupeeringuga: KM sektsioon (nt "Standard- voi soodusmaaraga maksustatavad tehingud") -> alagrupp -> KMD tuup (M_101, O_101 jne).
- Iga rida kuvab tehingu andmed KMD tuupide loikes.
- Vaikeveerud: #, KMD tuup, KMD tuubi sisu, KM%, Deklareeritav summa, KM (EUR), TP/Arve tunnus, Partneri reg/KMKR, Partneri nimi, Koodi taps., Grupp kat, Grupi liikme reg, Grupi liikme koodi taps., Grupi liikme nimi, Riik, Riigi taps., Arve nr, Ettemaks nr, Kuupaev, Arve kogusumma km/ta, Kreeditkp.
- NB! KMK% (Directo kaibemaksukood) veergu selles aruandes EI kuvata (Directo-sisene moiste, MTA mudelis on ainult KM%/maksumaar).

---

## T3. "Vali tulbad" veergude valija

- Aruandetabeli tooriistareal kruvikeeraja nupp, mis avab veergude valija paneeli.
- Paneelis: otsingukast ("Otsi"), veergude nimekiri linnukestega, "Taasta algseaded" nupp.
- Kasutaja saab veerge nahtavaks teha / peita linnukesega.
- Veergude asukohti EI SAA umber jarjestada (lohistamist ei ole). Jarjekord on fikseeritud.
- Otsing filtreerib veergude nimekirja nime jargi.
- Valik jaab kasutajale meelde (pusiv seade).

---

## T4. Filtrid

- Periood algus / Periood lopp: eraldi alguse ja lopu kuupaev, et saaks valida ka suvalise vahemiku (nt 10 paeva). Kaks sisestusviisi:
  a) Kalendrist valik (kalendriikoon vali).
  b) Directo kiirsisestus tekstivaljal: kuu number, nt "3" => 01.03-31.03 jooksev aasta; "!3" => eelmise aasta marts; tavaline kuupaev pp.kk.aaaa sisestatakse otse.
- Rippmenuud (nt KM tuup): avanevad ja kaituvad nagu prototuubis.
- Otsing: vabatekstiotsing partneri, arve numbri, koodi jm jargi.
- Saatja nimi ja Registrikood EI ole filtreeritavad - need tulevad ettevotte seadistusest (aruandes nahtamatud, kuid vajalikud hilisemas XML-i etapis).
- Pankrotiperioodi tunnus asub Seadistuste all (mitte filtrites).

---

## T5. Aruandetabeli juhtnupud (voldikud)

- Sulge koik / Ava koik voldikud.
- Sulge alamgrupid / Ava alamgrupid.
- "KMD tuubi kommentaar" veeru naitamine/peitmine kaib "Vali tulbad" alt.

---

## T6. Kokku KM maarade loikes

- Aruande ules kuvatakse koondrida KM maarade loikes (M - Muuk, A - Arv. kanded, S - Poordmaks, O - Sisend-KM jne).
- Arvutab kokku tasuda / tagasi saada summa.
- Vordlus bilansiga EI tule selles etapis - see jaab jargmisse etappi.

---

## Lahtised kusimused (enne arendust ule vaadata)

1. Kust I etapis andmed tulevad - kas reaalsest Directo tehingute/kannete baasist reaalajas, voi eeldame esialgu piiratud andmehulka (nt uks maksustamisperiood)?
2. Kas kogu agregeerimisloogika (1000 EUR piirmaar partneri perioodi kogusumma jargi, arveridade koondamine, segaarve detailselt) tuleb juba selles etapis, voi alles XML-i etapis? (Loogika ise: vt T1 ja esitlus lk 11.)
3. Kui tehingu KM koodi kaardil on vastav KMD tuubi vali (nt Muugi KM tuup) taitmata - kas rida jaetakse aruandest valja, kuvatakse eraldi "maaramata" grupis voi antakse hoiatus?
4. LAHENDATUD (esitlus lk 10-11): identifierCategory tuletatakse automaatselt (isiku tuup 100/200, Salastatud 101, 1000 EUR piirmaar 103/100, segaarve 104). Lahtine: kas 102 (lihtsustatud arve) on selles etapis kasutusel ja kust see tuleb?
5. LAHENDATUD (esitlus lk 10): partneri andmed ja koodi taps. tulevad kliendi-/hankijakaardilt (isiku tuup + KMKR). Lahtine: tapne eristus ARIREGISTRIKOOD vs KMKR_NUMBER vs MRR_KOOD.
