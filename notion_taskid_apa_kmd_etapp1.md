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

Tehingurea KMD tuup tuletatakse tehingu kaibemaksukoodist, votes tehingu konteksti jargi vastava valja:
- Muugidokument (muugiarve, kreeditarve, ettemaksuarve) -> "Muugi KM tuup" -> M_xxx
- Ostudokument (ostuarve, ostu kreeditarve) -> "Ostu KM tuup" -> O_xxx
- Poordmaksustatav soetus -> "Soetuse KM tuup" -> S_xxx
- Arvestuslik kanne -> "Arvestusliku kande KM tuup" -> A_xxx

Nii saab sama KM kood eri kontekstis anda erineva KMD tuubi. KM% (maksumaar) tuleb samuti KM koodilt.

**Veergude andmeallikad (vasakul veerg, paremal Directo andmeallikas):**
- KMD tuup -> tehingu KM koodi kaardi vastav valja vaartus (Muugi/Ostu/Soetuse/Arvestusliku kande KM tuup)
- KMD tuubi sisu -> KMDTYYP2026ap klassifikaatori kirjeldus (staatiline, tuubi jargi)
- KM% -> tehingurea maksumaar (KM koodilt)
- Deklareeritav summa -> tehingurea maksustatav vaartus (muugil kaibe summa; ostul/soetusel sisendkaibemaksu summa voi maksustatav vaartus vastavalt tuubile)
- KM (EUR) -> kaibemaksu summa (maksustatav vaartus x maar; voi tehingult)
- TP/Arve tunnus (identifierCategory) -> tuletatakse: 100 = Eesti jur. isik / teise LR KM-kohustuslane, 200 = fuusiline isik / mittekohustuslane, 300 = KM-grupi liige, 101 = salastatud arve, 102 = lihtsustatud arve, 103 = kogusumma alla 1000 EUR, 104 = segaarve
- Partneri reg/KMKR -> tehingupartneri (klient/hankija) registrikood voi KMKR number
- Partneri nimi -> partneri nimi (ainult kuvamiseks; XML-i EI lahe)
- Koodi taps. -> partneri koodi liik: ARIREGISTRIKOOD / KMKR_NUMBER / MRR_KOOD
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
2. Kuidas kaitleda kirjeid, mis ei mappu uheselt uhe KMD tuubi alla (nt segaarved) - kas jagatakse ridadeks juba andmete kogumisel?
3. Kui tehingu KM koodi kaardil on vastav KMD tuubi vali (nt Muugi KM tuup) taitmata - kas rida jaetakse aruandest valja, kuvatakse eraldi "maaramata" grupis voi antakse hoiatus?
4. TP/Arve tunnus (identifierCategory) - kas see tuletatakse automaatselt (partneri liik + arve omadused) voi votame mone valja otse dokumendilt? Kust tuleb 101/102/104 (salastatud/lihtsustatud/segaarve) info?
5. Partneri koodi taps. (ARIREGISTRIKOOD / KMKR_NUMBER / MRR_KOOD) - kas tuletatakse partneri kaardilt automaatselt?
