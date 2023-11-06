-- test preparation
USE PAC0076;


SELECT *
FROM organ
WHERE id_organ between 165 and 173;

SELECT *
FROM typ_organu;

SELECT COUNT(DISTINCT *)


    SELECT o1.id_osoba, o1.jmeno, prijmeni, org1.id_organ, COUNT( distinct h.id_hlasovani)
    FROM osoba o1
        JOIN zmatecne_hlasovani_poslanec zhp ON o1.id_osoba = zhp.id_osoba
        JOIN hlasovani h ON zhp.id_hlasovani = h.id_hlasovani
        JOIN organ org1 ON h.id_organ = org1.id_organ
    WHERE org1.id_organ between 165 AND 173 AND  o1.id_osoba = 4
    GROUP BY prijmeni, o1.jmeno, o1.id_osoba, org1.id_organ;


select osoba.id_osoba, osoba.jmeno, osoba.prijmeni, schuze.id_organ, count(distinct zhp.id_hlasovani) cnt
	from schuze
	join hlasovani on schuze.schuze = hlasovani.schuze and
					  schuze.id_organ = hlasovani.id_organ
	join zmatecne_hlasovani_poslanec zhp on hlasovani.id_hlasovani = zhp.id_hlasovani
	join osoba on osoba.id_osoba = zhp.id_osoba
	WHERE osoba.id_osoba = 4
	group by osoba.id_osoba, osoba.jmeno, osoba.prijmeni, schuze.id_organ
