SELECT *
FROM film;

SELECT email
FROM customer
WHERE active = 0;

SELECT title, description
FROM film
WHERE rating = 'G'
ORDER BY title desc;

SELECT *
FROM payment
WHERE payment_date >= '2006-01-01' AND amount < 2;

SELECT description
FROM film
WHERE rating IN ('G', 'PG', 'PG-13');

SELECT description
FROM film
WHERE rating NOT IN ('G', 'PG', 'PG-13');

SELECT *
FROM film
WHERE length > 50 and (rental_duration = 3 or rental_duration = 5);

SELECT title
FROM film
WHERE (title like '%RAINBOW%' OR title like 'TEXAS%') AND length > 70;

SELECT title
FROM film
WHERE
    description like '%And%' AND
    length BETWEEN 80 AND 90 AND
    rental_duration % 2 = 1;

SELECT DISTINCT special_features
FROM film
WHERE replacement_cost BETWEEN 14 and 16
ORDER BY special_features;

SELECT *
FROM address
WHERE postal_code IS NOT NULL;

SELECT count(*) AS POCET
FROM film;

SELECT count(rating) as pocet
FROM film;

SELECT COUNT(DISTINCT postal_code) AS Pocet_Vsech, COUNT(postal_code) AS Pocet_adres_psc
FROM address;