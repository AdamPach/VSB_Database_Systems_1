-- A 1

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

-- A 2

SELECT *
FROM (
        SELECT o.id_osoba, o.jmeno, o.prijmeni,
               COUNT(CASE WHEN MONTH(om.den) = 1 THEN 1 END) as pocet_leden,
               COUNT(CASE WHEN MONTH(om.den) = 2 THEN 1 END) as pocet_unor
        FROM osoba o
            JOIN poslanec p ON o.id_osoba = p.id_osoba
            JOIN omluva om ON p.id_poslanec = om.id_poslanec
        GROUP BY o.id_osoba, o.jmeno, o.prijmeni
     ) t
WHERE t.pocet_leden > 33 AND t.pocet_leden > t.pocet_unor
ORDER BY pocet_leden

WITH tab_omluvy AS (
    SELECT o.id_osoba, o.jmeno, o.prijmeni,
    (SELECT COUNT(*)
     FROM poslanec p1
        JOIN omluva om ON p1.id_poslanec = om.id_poslanec
     WHERE o.id_osoba = p1.id_osoba
        AND MONTH(om.den) = 1
     ) as omluvy_leden,
    (SELECT COUNT(*)
     FROM poslanec p1
        JOIN omluva om ON p1.id_poslanec = om.id_poslanec
     WHERE o.id_osoba = p1.id_osoba
        AND MONTH(om.den) = 2
     ) as omluvy_unor
FROM osoba o
)
SELECT *
FROM tab_omluvy
WHERE omluvy_leden > 33 AND omluvy_leden > omluvy_unor
ORDER BY omluvy_leden DESC

-- A 3
WITH tab_delegace AS(
SELECT o.id_osoba, o.jmeno, o.prijmeni, COUNT(*) AS pocet,
       (
            SELECT COUNT(*)
            FROM osoba o2
                JOIN zarazeni z2 ON o2.id_osoba = z2.id_osoba
                JOIN organ org2 ON z2.id_of = org2.id_organ AND z2.cl_funkce = 0
                JOIN typ_organu torg2 ON org2.id_typ_org = torg2.id_typ_org
            WHERE o.id_osoba = o2.id_osoba
                AND torg2.nazev_typ_org_cz = 'Delegace'
        ) AS pocet_delegaci
FROM osoba o
    JOIN zarazeni z1 ON o.id_osoba = z1.id_osoba
    JOIN funkce f1 ON z1.id_of = f1.id_funkce AND z1.cl_funkce = 1
    JOIN typ_funkce tf1 ON f1.id_typ_funkce = tf1.id_typ_funkce
    JOIN organ org1 ON f1.id_organ = org1.id_organ
    JOIN typ_organu torg1 ON org1.id_typ_org = torg1.id_typ_org
WHERE tf1.typ_funkce_cz = 'Místopředseda'
    AND torg1.nazev_typ_org_cz = 'Parlament'
GROUP BY o.id_osoba, o.jmeno, o.prijmeni
)
SELECT *
FROM tab_delegace
WHERE pocet >= 2
ORDER BY pocet DESC ;

-- 1 B

SELECT o1.id_osoba, o1.jmeno, o1.prijmeni, COUNT(*) as pocet_vybor,
       (
            SELECT COUNT(*)
            FROM osoba o2
                JOIN zarazeni z2 ON o2.id_osoba = z2.id_osoba
                JOIN organ org2 ON z2.id_of = org2.id_organ AND z2.cl_funkce = 0
                JOIN typ_organu torg2 ON org2.id_typ_org = torg2.id_typ_org
            WHERE torg2.nazev_typ_org_cz = 'Delegace'
                AND o1.id_osoba = o2.id_osoba
        ) AS pocet_delegaci
FROM osoba o1
    JOIN zarazeni z1 ON o1.id_osoba = z1.id_osoba
    JOIN organ org1 ON z1.id_of = org1.id_organ AND z1.cl_funkce = 0
    JOIN typ_organu torg1 ON org1.id_typ_org = torg1.id_typ_org
WHERE torg1.nazev_typ_org_cz = 'Výbor'
    AND NOT EXISTS(
        SELECT *
        FROM osoba o2
            JOIN zarazeni z2 ON o2.id_osoba = z2.id_osoba
            JOIN organ org2 ON z2.id_of = org2.id_organ AND z2.cl_funkce = 0
            JOIN typ_organu torg2 ON org2.id_typ_org = torg2.id_typ_org
        WHERE torg2.nazev_typ_org_cz = 'Delegace'
            AND o1.id_osoba = o2.id_osoba
            AND org1.rodic_id_organ = org2.rodic_id_organ
)
GROUP BY o1.id_osoba, o1.jmeno, o1.prijmeni, o1.prijmeni
HAVING COUNT(*) = 8
ORDER BY pocet_delegaci DESC;