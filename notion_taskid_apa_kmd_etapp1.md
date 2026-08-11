# APA KMD 2027 aruanne - I etapp - Notioni taskid

**Directo master sündmus:** Andmepõhine KMD (APA KMD 2027) aruanne - I etapp
**Prototüüp:** apa_kmd.html (GitHub: viljatuisk/sandbox)
**Detailne ticket:** ticket_apa_kmd_etapp1.txt

Iga alljärgnev task on eraldi Notioni kirje. Arendaja märgib staatuse (Tegemata / Töös / Valmis) Notionis. Kogu etapi arendus commititakse Directo master sündmuse raames.

Iga taski päises on "Notioni väljad" plokk (Kuupäev, Lisas, Lisatud, Prioriteet, Staatus, Sündmuse link, Teema), et Notioni AI saaks kirje omadused automaatselt täita. Sündmuse link viitab kõigil Directo master sündmusele.

---

## T1. Andmete kogumine ja KMD tüübi tuletamine

**Notioni väljad:**
- Staatus: Tegemata
- Prioriteet: Kõrge
- Teema: Andmed ja KMD tüüp
- Sündmuse link: https://login.directo.ee/ocra_gate/event.html?id=1270066
- Kuupäev: (määrata)
- Lisas: (täidab Notion)
- Lisatud: (täidab Notion automaatselt)

Aruanne kogub valitud perioodi tehingud ja toimingud Directost (müügi- ja ostuarved, kreedit- ja ettemaksuarved, pöördmaksustatavad soetused, arvestuslikud kanded) ning grupeerib need KMD tüübi (KMDTYYP2026ap) järgi. Iga tehingurida läheb tabelisse ühe KMD tüübi reana.

**KMD tüübi määramine (käibemaksukoodi kaardilt):**

Arendaja on lisanud käibemaksukoodi (KM kood) kaardile 4 uut välja, mille asetajaks on KM klassifikaatorite nimekiri (KMDTYYP2026ap: M_101, O_101, S_101, A_101 jne):
- Müügi KM tüüp
- Ostu KM tüüp
- Soetuse KM tüüp
- Arvestusliku kande KM tüüp

Igale dokumendile (müügiarve, ostuarve, kulutus, kanne) lisatakse väli KM tüüp. Väärtus asetub automaatselt KMK kaardi kaudu, kuid kasutaja saab seda vajadusel dokumendil käsitsi muuta. KM tüüp asetub järgmiselt (esitlus lk 9):
- Müügiarve -> KMK kaardi "Müügi KM tüüp" -> nt M_101
- Ostuarve ja Kulutus -> KMK kaardi "Ostu KM tüüp" -> nt O_101
- Ostuarve ja Kulutus (pöördmaksustatav) -> KMK kaardi "Soetuse KM tüüp" -> nt S_101
- Kanne (konto tüübi järgi): "Müügi KM tüüp" (nt sularaha müügi koondkanne -> M_101), "Ostu KM tüüp" (nt kulukanne -> O_101), "Arvestusliku kande KM tüüp" (nt impordi maksustatava väärtuse muutmine -> A_101)

Nii saab sama KM kood eri kontekstis anda erineva KMD tüübi. KM% (maksumäär) tuleb samuti KM koodilt.

**Veergude andmeallikad (vasakul veerg, paremal Directo andmeallikas):**
- KMD tüüp -> tehingu KM koodi kaardi vastav välja väärtus (Müügi/Ostu/Soetuse/Arvestusliku kande KM tüüp)
- KMD tüübi sisu -> KMDTYYP2026ap klassifikaatori kirjeldus (staatiline, tüübi järgi)
- KM% -> tehingurea maksumäär (KM koodilt)
- Deklareeritav summa -> tehingurea maksustatav väärtus (müügil käibe summa; ostul/soetusel sisendkäibemaksu summa või maksustatav väärtus vastavalt tüübile)
- KM (EUR) -> käibemaksu summa (maksustatav väärtus x määr; või tehingult)
- TP/Arve tunnus (identifierCategory) -> EI ole lihtne otsing, vaid tuletatakse loogika alusel (vt allpool "TP/Arve tunnuse ja agregeerimise loogika"). Väärtused: 100 / 101 / 103 / 104 (juriidiline), 200 (füüsiline), 300 (KM-grupi liige)
- Partneri reg/KMKR -> tehingupartneri (klient/hankija) registrikood või KMKR number (kliendi-/hankijakaardilt)
- Partneri nimi -> partneri nimi (ainult kuvamiseks; XML-i EI lähe)
- Koodi täps. -> partneri koodi liik: ARIREGISTRIKOOD / KMKR_NUMBER / MRR_KOOD (tuletatakse kliendi-/hankijakaardilt)
- Grupp kat -> 300, kui partner on KM-grupi liige
- Grupi liikme reg -> KM-grupi liikme registrikood või mitteresidendi kood
- Grupi liikme koodi täps. -> grupi liikme koodi liik (ARIREGISTRIKOOD / KMKR_NUMBER / MRR_KOOD)
- Grupi liikme nimi -> grupi liikme nimi (ainult kuvamiseks; XML-i EI lähe)
- Riik -> ostja riigi tunnus (EL riigid, ühendusesiseste tehingute puhul)
- Riigi täps. -> riigi roll (RR_ostja)
- Arve nr -> dokumendi (arve) number
- Ettemaks nr -> ettemaksuarve number
- Kuupäev -> arve või ettemaksuarve kuupäev
- Arve kogusumma km/ta -> arve kogusumma ilma käibemaksuta
- Kreeditkp -> kreeditarve esialgse arve kuupäev

**TP/Arve tunnuse (identifierCategory) ja agregeerimise loogika (esitlus lk 10-11):**

Partneri andmed tulevad kliendi-/hankijakaardilt (olemasolevad väljad, kaarti sisuliselt muuta ei tule):
- Isiku tüüp (juriidiline / füüsiline) -> määrab 100 vs 200
- KMKR -> näitab, kas tegemist välismaa isikuga (ühendusesisesed tehingud)
- "Salastatud" (uus väärtus Tüüp väljas, arvel muudetav) -> 101 (partner esitatakse anonüümselt)

1000 EUR piirmäär - tehingupartneri PERIOODI kogusumma järgi:
- Füüsiline isik -> ALATI agregeeritult -> 200
- Juriidiline, partneri perioodi kogusumma < 1000 EUR -> agregeeritult, partneri andmeid ei esitata -> 103
- Juriidiline, kogusumma >= 1000 EUR -> detailselt arve kaupa, registrikood kohustuslik -> 100
- Segaarve (mitu KM käsitlust ühel arvel) -> lisatunnus 104, piirmäär kehtib endiselt

Arveridade koondamine:
- Sama KMD tüübiga read samalt arvelt summeeritakse ühte kirjesse (nt 10-realine arve 5x24% + 5x9% -> 2 kirjet).

Segaarve reegel (kasvõi üks maksustatav rida arvel):
- Kogu arve read tuleb esitada detailselt. Nt juriidiline, 22% käive 1000 EUR + maksuvaba 3000 EUR -> M_101 1000 EUR (104) + M_301 3000 EUR (104). Maksuvaba (M_301) tuleb detailselt segaarve tõttu.
- Sama kehtib, kui partneri MÕNE TEISE arve tõttu on perioodi kogusumma >= 1000 EUR.

---

## T2. Aruandetabel - Tehingupäevik

**Notioni väljad:**
- Staatus: Tegemata
- Prioriteet: Kõrge
- Teema: Aruandetabel
- Sündmuse link: https://login.directo.ee/ocra_gate/event.html?id=1270066
- Kuupäev: (määrata)
- Lisas: (täidab Notion)
- Lisatud: (täidab Notion automaatselt)

- Tehingute nimekiri kolmetasandilise grupeeringuga: KM sektsioon (nt "Standard- või soodusmääraga maksustatavad tehingud") -> alagrupp -> KMD tüüp (M_101, O_101 jne).
- Iga rida kuvab tehingu andmed KMD tüüpide lõikes.
- Vaikeveerud: #, KMD tüüp, KMD tüübi sisu, KM%, Deklareeritav summa, KM (EUR), TP/Arve tunnus, Partneri reg/KMKR, Partneri nimi, Koodi täps., Grupp kat, Grupi liikme reg, Grupi liikme koodi täps., Grupi liikme nimi, Riik, Riigi täps., Arve nr, Ettemaks nr, Kuupäev, Arve kogusumma km/ta, Kreeditkp.
- NB! KMK% (Directo käibemaksukood) veergu selles aruandes EI kuvata (Directo-sisene mõiste, MTA mudelis on ainult KM%/maksumäär).

---

## T3. "Vali tulbad" veergude valija

**Notioni väljad:**
- Staatus: Tegemata
- Prioriteet: Keskmine
- Teema: Aruandetabel / veerud
- Sündmuse link: https://login.directo.ee/ocra_gate/event.html?id=1270066
- Kuupäev: (määrata)
- Lisas: (täidab Notion)
- Lisatud: (täidab Notion automaatselt)

- Aruandetabeli tööriistareal kruvikeeraja nupp, mis avab veergude valija paneeli.
- Paneelis: otsingukast ("Otsi"), veergude nimekiri linnukestega, "Taasta algseaded" nupp.
- Kasutaja saab veerge nähtavaks teha / peita linnukesega.
- Veergude asukohti EI SAA ümber järjestada (lohistamist ei ole). Järjekord on fikseeritud.
- Otsing filtreerib veergude nimekirja nime järgi.
- Valik jääb kasutajale meelde (püsiv seade).

---

## T4. Filtrid

**Notioni väljad:**
- Staatus: Tegemata
- Prioriteet: Kõrge
- Teema: Filtrid
- Sündmuse link: https://login.directo.ee/ocra_gate/event.html?id=1270066
- Kuupäev: (määrata)
- Lisas: (täidab Notion)
- Lisatud: (täidab Notion automaatselt)

- Periood algus / Periood lõpp: eraldi alguse ja lõpu kuupäev, et saaks valida ka suvalise vahemiku (nt 10 päeva). Kaks sisestusviisi:
  a) Kalendrist valik (kalendriikoon väli).
  b) Directo kiirsisestus tekstiväljal: kuu number, nt "3" => 01.03-31.03 jooksev aasta; "!3" => eelmise aasta märts; tavaline kuupäev pp.kk.aaaa sisestatakse otse.
- Rippmenüüd (nt KM tüüp): avanevad ja käituvad nagu prototüübis.
- Otsing: vabatekstiotsing partneri, arve numbri, koodi jm järgi.
- Saatja nimi ja Registrikood EI ole filtreeritavad - need tulevad ettevõtte seadistusest (aruandes nähtamatud, kuid vajalikud hilisemas XML-i etapis).
- Pankrotiperioodi tunnus asub Seadistuste all (mitte filtrites).

---

## T5. Aruandetabeli juhtnupud (voldikud)

**Notioni väljad:**
- Staatus: Tegemata
- Prioriteet: Madal
- Teema: Aruandetabel / voldikud
- Sündmuse link: https://login.directo.ee/ocra_gate/event.html?id=1270066
- Kuupäev: (määrata)
- Lisas: (täidab Notion)
- Lisatud: (täidab Notion automaatselt)

- Sulge kõik / Ava kõik voldikud.
- Sulge alamgrupid / Ava alamgrupid.
- "KMD tüübi kommentaar" veeru näitamine/peitmine käib "Vali tulbad" alt.

---

## T6. Kokku KM määrade lõikes

**Notioni väljad:**
- Staatus: Tegemata
- Prioriteet: Keskmine
- Teema: Koondarvestus
- Sündmuse link: https://login.directo.ee/ocra_gate/event.html?id=1270066
- Kuupäev: (määrata)
- Lisas: (täidab Notion)
- Lisatud: (täidab Notion automaatselt)

- Aruande üles kuvatakse koondrida KM määrade lõikes (M - Müük, A - Arv. kanded, S - Pöördmaks, O - Sisend-KM jne).
- Arvutab kokku tasuda / tagasi saada summa.
- Võrdlus bilansiga EI tule selles etapis - see jääb järgmisse etappi.

---

## Lahtised küsimused (enne arendust üle vaadata)

1. Kust I etapis andmed tulevad - kas reaalsest Directo tehingute/kannete baasist reaalajas, või eeldame esialgu piiratud andmehulka (nt üks maksustamisperiood)?
2. Kas kogu agregeerimisloogika (1000 EUR piirmäär partneri perioodi kogusumma järgi, arveridade koondamine, segaarve detailselt) tuleb juba selles etapis, või alles XML-i etapis? (Loogika ise: vt T1 ja esitlus lk 11.)
3. Kui tehingu KM koodi kaardil on vastav KMD tüübi väli (nt Müügi KM tüüp) täitmata - kas rida jäetakse aruandest välja, kuvatakse eraldi "määramata" grupis või antakse hoiatus?
4. LAHENDATUD (esitlus lk 10-11): identifierCategory tuletatakse automaatselt (isiku tüüp 100/200, Salastatud 101, 1000 EUR piirmäär 103/100, segaarve 104). Lahtine: kas 102 (lihtsustatud arve) on selles etapis kasutusel ja kust see tuleb?
5. LAHENDATUD (esitlus lk 10): partneri andmed ja koodi täps. tulevad kliendi-/hankijakaardilt (isiku tüüp + KMKR). Lahtine: täpne eristus ARIREGISTRIKOOD vs KMKR_NUMBER vs MRR_KOOD.
