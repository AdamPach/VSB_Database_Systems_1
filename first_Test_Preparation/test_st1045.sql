-- A 1

SELECT o1.id_osoba, o1.jmeno, o1.prijmeni,
  sum(datediff(month, z1.od_o, z1.do_o)) as pocet_mesicu_us,
  (
    select sum(datediff(month, z2.od_o, z2.do_o)) as pocet_mesicu_ods from osoba o2
    join zarazeni z2 on o2.id_osoba=z2.id_osoba
    join organ org2 on z2.id_of=org2.id_organ and z2.cl_funkce=0
    where org2.nazev_organu_cz='Poslanecká sněmovna' and o2.id_osoba=o1.id_osoba
	group by o2.id_osoba
  ) as pocet_mesicu_poslanec
FROM osoba o1
    JOIN zarazeni z1 ON o1.id_osoba = z1.id_osoba
    JOIN organ org1 ON z1.id_of = org1.id_organ AND z1.cl_funkce = 0
WHERE org1.nazev_organu_cz = 'Poslanecký klub Unie svobody'
    AND NOT EXISTS(
        SELECT 1
        FROM osoba o2
            JOIN zarazeni z2 ON o2.id_osoba = z2.id_osoba
            JOIN organ org2 ON z2.id_of = org2.id_organ AND z2.cl_funkce = 0
        WHERE o2.id_osoba = o1.id_osoba
            AND org2.nazev_organu_cz = 'Poslanecký klub Občanské demokratické strany'
            AND org2.rodic_id_organ = org1.rodic_id_organ
)
GROUP BY o1.id_osoba, o1.jmeno, o1.prijmeni;

-- 2 A
WITH tab AS (
SELECT DISTINCT o1.id_osoba, o1.jmeno, o1.prijmeni,
        (
            SELECT COUNT(*)
            FROM osoba o2
                JOIN poslanec p ON o2.id_osoba = p.id_osoba
                JOIN omluva oml ON p.id_poslanec = oml.id_poslanec
            WHERE o2.id_osoba = o1.id_osoba
                AND MONTH(oml.den) = 11
        ) AS pocet_listopad,
        (
            SELECT COUNT(*)
            FROM osoba o2
                JOIN poslanec p ON o2.id_osoba = p.id_osoba
                JOIN omluva oml ON p.id_poslanec = oml.id_poslanec
            WHERE o2.id_osoba = o1.id_osoba
                AND MONTH(oml.den) = 12
        ) AS pocet_prosinec
FROM osoba o1
    JOIN zarazeni z1 ON o1.id_osoba = z1.id_osoba
    JOIN organ org1 ON z1.id_of = org1.id_organ AND z1.cl_funkce = 0
WHERE org1.nazev_organu_cz = 'Poslanecký klub Občanské demokratické strany'
)
SELECT *
FROM tab
WHERE pocet_listopad > pocet_prosinec
    AND pocet_listopad > 16
ORDER BY pocet_listopad DESC

-- 3 A

SELECT o1.id_osoba, o1.jmeno, o1.prijmeni, org1.nazev_organu_cz ,COUNT(*) as pocet_klubu,
       (SELECT COUNT(*) FROM poslanec p1 WHERE p1.id_osoba = o1.id_osoba) AS pocet_mandatu
FROM osoba o1
    JOIN zarazeni z1 ON o1.id_osoba = z1.id_osoba
    JOIN organ org1 ON org1.id_organ = z1.id_of AND z1.cl_funkce = 0
    JOIN typ_organu torg1 ON org1.id_typ_org = torg1.id_typ_org
WHERE torg1.nazev_typ_org_cz = 'Klub'
GROUP BY o1.id_osoba, o1.jmeno, o1.prijmeni, org1.nazev_organu_cz
HAVING COUNT(*) > 6
ORDER BY pocet_klubu DESC;

-- 1 B

SELECT o1.id_osoba, o1.jmeno, o1.prijmeni,
       COALESCE(SUM(datediff(month, z1.od_o, z1.do_o)), SUM(datediff(month, z1.od_o, GETDATE()))) AS pocet_mesicu_top_09
FROM osoba o1
    JOIN zarazeni z1 ON o1.id_osoba = z1.id_osoba
    JOIN organ org1 ON org1.id_organ = z1.id_of AND z1.cl_funkce = 0
WHERE org1.nazev_organu_cz = 'Poslanecký klub TOP 09'
    AND NOT EXISTS(
        SELECT 1
        FROM osoba o2
            JOIN zarazeni z2 ON o2.id_osoba = z2.id_osoba
            JOIN organ org2 ON org2.id_organ = z2.id_of AND z2.cl_funkce = 0
        WHERE o1.id_osoba = o2.id_osoba
            AND org2.nazev_organu_cz = 'Poslanecký klub Občanské demokratické strany'
            AND org1.rodic_id_organ = org2.rodic_id_organ
)
GROUP BY o1.id_osoba, o1.jmeno, o1.prijmeni
ORDER BY pocet_mesicu_top_09 DESC