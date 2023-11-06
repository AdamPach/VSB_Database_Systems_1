use PAC0076;

-- How many times a person was a Member

SELECT jmeno, prijmeni, COUNT(*)
FROM osoba o
    LEFT JOIN poslanec p ON o.id_osoba = p.id_osoba
group by o.id_osoba,jmeno, prijmeni;

SELECT jmeno, prijmeni,
       (
           SELECT COUNT(*)
           FROM poslanec p
           WHERE o.id_osoba = p.id_osoba
           )
FROM osoba o;

--
SELECT o.pohlavi,
       COUNT(*) AS pocet_zastupcu,
        (CAST(COUNT(*) as FLOAT) / (SELECT COUNT(*) FROM osoba) * 100.0) as podil
FROM osoba o
GROUP BY o.pohlavi;

-- How many times a person marked vote as confusing

SELECT o.jmeno, o.prijmeni, COUNT(zhp.id_osoba) pocet_zmatecnych
FROM osoba o
    LEFT JOIN zmatecne_hlasovani_poslanec zhp ON o.id_osoba = zhp.id_osoba
GROUP BY o.jmeno, o.prijmeni
ORDER BY pocet_zmatecnych desc ;


SELECT DISTINCT org.nazev_organu_cz, org.od_organ, org.do_organ,
        (
            SELECT COUNT(*)
            FROM osoba
                JOIN poslanec p2 ON osoba.id_osoba = p2.id_osoba
            WHERE osoba.pohlavi = 'M'
                AND p2.id_organ = org.id_organ
            ) AS POCET_MUZU,
    (
        SELECT COUNT(*)
            FROM osoba
                JOIN poslanec p2 ON osoba.id_osoba = p2.id_osoba
            WHERE osoba.pohlavi = 'Ž'
                AND p2.id_organ = org.id_organ
                    ) + (
            SELECT COUNT(*)
            FROM osoba
                JOIN poslanec p2 ON osoba.id_osoba = p2.id_osoba
            WHERE osoba.pohlavi = 'Z'
                AND p2.id_organ = org.id_organ
        ) AS POCET_ZEN
FROM organ org
    JOIN typ_organu torg ON org.id_typ_org = torg.id_typ_org
WHERE torg.nazev_typ_org_cz = 'Parlament';


-- Shared document A4

SELECT p.id_organ
FROM osoba o
    JOIN dbo.poslanec p on o.id_osoba = p.id_osoba
WHERE o.jmeno = 'Andrej' and o.prijmeni = 'Babiš'

SELECT *
FROM osoba o
    JOIN dbo.poslanec p on o.id_osoba = p.id_osoba
WHERE p.id_organ = 173
ORDER BY p.id_kandidatka

SELECT id_kandidatka, count(*)
FROM poslanec
WHERE id_organ = 173
GROUP BY id_kandidatka

-- Tabulka Organ
SELECT DISTINCT tor.*
FROM organ
    JOIN typ_organu tor ON organ.id_typ_org = tor.id_typ_org
WHERE rodic_id_organ = 173


SELECT org.*
FROM typ_organu tor
    JOIN organ org ON tor.id_typ_org = org.id_typ_org
WHERE tor.nazev_typ_org_cz = 'Klub'
    AND org.rodic_id_organ = 173;

-- Tabulka funkce

SELECT funkce.nazev_funkce_cz, o.nazev_organu_cz
FROM funkce
    JOIN dbo.organ o on funkce.id_organ = o.id_organ
WHERE o.id_organ = 173

SELECT f.nazev_funkce_cz, org.nazev_organu_cz
FROM funkce f
    JOIN organ org ON f.id_organ = org.id_organ
WHERE rodic_id_organ = 173
    AND org.nazev_organu_cz = 'Poslanecký klub TOP 09'

SELECT f.nazev_funkce_cz, org.nazev_organu_cz
FROM funkce f
    JOIN organ org ON f.id_organ = org.id_organ
    JOIN typ_organu torg ON org.id_typ_org = torg.id_typ_org
WHERE rodic_id_organ = 173
    AND torg.nazev_typ_org_cz = 'Klub'

-- Tabulka zarazeni

SELECT org.nazev_organu_cz
FROM osoba o
    JOIN zarazeni z ON o.id_osoba = z.id_osoba
    JOIN organ org ON z.id_of = org.id_organ
        AND z.cl_funkce = 0
WHERE o.jmeno = 'Andrej'
    AND o.prijmeni = 'Babiš';

SELECT f.nazev_funkce_cz
FROM osoba o
    JOIN zarazeni z ON o.id_osoba = z.id_osoba
    JOIN funkce f ON z.id_of = f.id_funkce
        AND z.cl_funkce = 1
WHERE jmeno = 'Marek'
    AND prijmeni = 'Benda'


SELECT o.jmeno, o.prijmeni, f.id_organ, z.od_o
FROM osoba o
    JOIN dbo.zarazeni z on o.id_osoba = z.id_osoba
    JOIN funkce f ON z.id_of = f.id_funkce
        AND z.cl_funkce = 1
    JOIN typ_funkce tf ON f.id_typ_funkce = tf.id_typ_funkce
    JOIN typ_organu torg ON tf.id_typ_org = torg.id_typ_org
WHERE torg.id_typ_org = 11
    AND tf.typ_funkce_cz = 'Předseda'
ORDER BY z.od_o

SELECT org.id_organ, f.nazev_funkce_cz, z.od_o, z.do_o, o.jmeno, o.prijmeni
FROM osoba o
    JOIN zarazeni z ON o.id_osoba = z.id_osoba
    JOIN funkce f ON f.id_funkce = z.id_of
        AND z.cl_funkce = 1
    JOIN typ_funkce tf ON f.id_typ_funkce = tf.id_typ_funkce
    JOIN organ org ON f.id_organ = org.id_organ
WHERE tf.typ_funkce_cz = 'Místopředseda'
    AND org.id_organ = 173

SELECT *
FROM osoba
    JOIN zarazeni z ON osoba.id_osoba = z.id_osoba
    JOIN organ org ON z.id_of = org.id_organ
        AND z.cl_funkce = 0
WHERE org.nazev_organu_cz='Poslanecká sněmovna' AND year(org.od_organ)=2021 AND z.do_o is null;

-- Tabulka Schuze

SELECT COUNT(*) pocet_schuzi, COUNT(s.do_schuze) as ukoncene_schuze,
        AVG(datediff(day, s.od_schuze, s.do_schuze)) AS prum_schuze
FROM schuze s
WHERE s.id_organ = 173