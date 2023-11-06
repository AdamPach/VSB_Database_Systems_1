SELECT DISTINCT org.zkratka, org.nazev_organu_cz, obdobi.od_organ, COUNT(*) as pocet_poslancu
FROM organ org
    JOIN typ_organu torg ON org.id_typ_org = torg.id_typ_org
    JOIN organ obdobi ON org.rodic_id_organ = obdobi.id_organ
    JOIN poslanec p ON obdobi.id_organ = p.id_organ
WHERE torg.nazev_typ_org_cz = 'klub'
group by obdobi.od_organ, org.nazev_organu_cz, org.zkratka;


WITH pocet_poslancu AS (
    SELECT org_klub.zkratka, org_klub.nazev_organu_cz, psp.id_organ, COUNT (*) as pocet_poslancu
    FROM poslanec p
        JOIN zarazeni z ON p.id_osoba = z.id_osoba
        JOIN organ org_klub ON org_klub.id_organ = z.id_of AND z.cl_funkce = 0
        JOIN typ_organu typ_klub ON org_klub.id_typ_org = typ_klub.id_typ_org
        JOIN organ psp ON p.id_organ = psp.id_organ AND psp.id_organ = org_klub.rodic_id_organ
        WHERE typ_klub.nazev_typ_org_cz = 'klub'
    group by org_klub.zkratka, org_klub.nazev_organu_cz, psp.id_organ
    HAVING COUNT(*) >= 50
    )
SELECT zkratka, COUNT(*)
FROM pocet_poslancu
group by zkratka
HAVING COUNT(*) >= 2

WITH hlas AS (
    SELECT h.id_hlasovani, s.schuze, h.cislo,h.nazev_dlouhy
    FROM schuze s
        JOIN hlasovani h ON s.id_organ = h.id_organ and s.schuze = h.schuze
    WHERE s.id_organ = 171
)
SELECT *
FROM hlas h1
WHERE cislo = (
        SELECT MAX(cislo)
        FROM hlas h2
        WHERE h1.schuze= h2.schuze
    )



SELECT *
FROM osoba o
    JOIN poslanec p ON o.id_osoba = p.id_osoba
    JOIN hlasovani_poslanec hp ON p.id_poslanec = hp.id_poslanec
    JOIN hlasovani h ON hp.id_hlasovani = h.id_hlasovani
WHERE h.nazev_dlouhy like 'Návrh na vyslovení nedůvěry vládě%'
    AND p.id_organ = 172
    AND NOT EXISTS(
        SELECT *
        FROM poslanec p2
            JOIN hlasovani_poslanec hp2 ON p2.id_poslanec = hp2.id_poslanec
        WHERE p2.id_osoba = p.id_osoba
            AND p.id_organ = p2.id_organ
            AND hp2.vysledek = 'A'
)
    --AND hp.vysledek != 'A'

SELECT o1.*
FROM osoba o1
    JOIN poslanec p1 ON o1.id_osoba = p1.id_osoba
WHERE p1.id_organ = 172
    AND NOT EXISTS(
        SELECT *
        FROM poslanec p2
            JOIN hlasovani_poslanec hp ON p2.id_poslanec = hp.id_poslanec
            JOIN hlasovani h ON hp.id_hlasovani = h.id_hlasovani
        WHERE p2.id_osoba = o1.id_osoba AND p2.id_organ = p1.id_organ
            AND h.nazev_dlouhy like 'Návrh na vyslovení nedůvěry vládě%'
            AND hp.vysledek = 'A'
) AND EXISTS(
    SELECT *
    FROM hlasovani h
        JOIN hlasovani_poslanec hp ON h.id_hlasovani = hp.id_hlasovani
        JOIN poslanec p2 ON hp.id_poslanec = p2.id_poslanec
    WHERE p2.id_osoba = o1.id_osoba AND p2.id_organ = p1.id_organ
        AND h.nazev_dlouhy like 'Návrh na vyslovení nedůvěry vládě%'
)

WITH tab AS (SELECT obdobi.id_organ as obdobi, obdobi.od_organ, org1.zkratka, COUNT(*) AS pocet_poslancu
             FROM poslanec p1
                      JOIN zarazeni z1 ON p1.id_osoba = z1.id_osoba
                      JOIN organ org1 ON z1.id_of = org1.id_organ
                 AND z1.cl_funkce = 0
                      JOIN organ obdobi ON org1.rodic_id_organ = obdobi.id_organ
                 AND p1.id_organ = obdobi.id_organ
                      JOIN typ_organu torg ON org1.id_typ_org = torg.id_typ_org
             WHERE torg.nazev_typ_org_cz = 'Klub'
             GROUP BY obdobi.od_organ, obdobi.id_organ, org1.zkratka, org1.id_organ
             HAVING COUNT(*) >= 50)
SELECT obdobi, od_organ, COUNT(*)
FROM tab
GROUP BY od_organ, obdobi
HAVING COUNT(*) >= 2;


WITH hlasov AS (
SELECT h.id_hlasovani, s.schuze, h.cislo, h.nazev_dlouhy
FROM schuze s
    JOIN hlasovani h ON s.id_organ = h.id_organ AND s.schuze = h.schuze
WHERE s.id_organ = 168)
SELECT *
FROM hlasov h1
WHERE NOT EXISTS(
    SELECT 1
    FROM hlasov h2
    WHERE h1.schuze = h2.schuze
        AND h2.cislo > h1.cislo
)
ORDER BY h1.schuze

SELECT o1.id_osoba, o1.jmeno, o1.prijmeni, COUNT(*) as count,
    sum(datediff(month, z1.od_o, z1.do_o)) as pocet_mesicu_ve_vlade
FROM osoba o1
    JOIN zarazeni z1 ON o1.id_osoba = z1.id_osoba
    JOIN organ org1 ON z1.id_of = org1.id_organ AND z1.cl_funkce = 0
WHERE nazev_organu_cz = 'Vláda České republiky'
    AND NOT EXISTS(
        SELECT *
        FROM osoba o2
            JOIN poslanec p1 ON o2.id_osoba = p1.id_osoba
            JOIN organ org2 ON p1.id_organ = org2.id_organ
        WHERE o1.id_osoba = o2.id_osoba
            AND z1.od_o between org2.od_organ and org2.do_organ
)
GROUP BY o1.id_osoba, o1.jmeno, o1.prijmeni
HAVING COUNT(*) >= 3


select o1.id_osoba, o1.jmeno, o1.prijmeni, count(*) as pocet_jmenovani,
        sum(datediff(month, z1.od_o, z1.do_o)) as pocet_mesicu_ve_vlade from osoba o1
join zarazeni z1 on o1.id_osoba=z1.id_osoba
join organ org1 on z1.id_of=id_organ and z1.cl_funkce=0
where org1.nazev_organu_cz like 'Vláda České republiky'
and not exists
(
  select 1 from osoba o2
  join zarazeni z2 on o2.id_osoba=z2.id_osoba
  join organ org2 on z2.id_of=org2.id_organ and z2.cl_funkce=0
  where org2.nazev_organu_cz like 'Poslanecká sněmovna' and
	    (o1.id_osoba = o2.id_osoba and z1.od_o between org2.od_organ and org2.do_organ)
)
group by o1.id_osoba,o1.jmeno,o1.prijmeni
having count(*) > 2
order by pocet_jmenovani desc

SELECT osoba.*
FROM osoba
    JOIN zarazeni z ON osoba.id_osoba = z.id_osoba
    JOIN organ org ON org.id_organ = z.id_of AND z.cl_funkce = 0
WHERE id_organ = 173

SELECT osoba.*
FROM osoba
    JOIN poslanec p1 ON osoba.id_osoba = p1.id_osoba
    JOIN organ org ON org.id_organ = p1.id_organ
WHERE org.id_organ = 173