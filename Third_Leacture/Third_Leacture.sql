use PAC0076;

--1

SELECT rating, COUNT(*) AS POCET_FILMU
FROM film
GROUP BY rating;

--5

SELECT year(payment_date) AS YEAR, MONTH(payment_date) AS MONTH, SUM(amount)
FROM payment
GROUP BY year(payment_date), month(payment_date)
ORDER BY YEAR, MONTH;

-- 6

SELECT store_id, count(inventory_id) AS pocet
FROM inventory
GROUP BY store_id
HAVING COUNT(*) > 2300;

-- 10

SELECT language_id, COUNT(film_id) AS POCET_FILMU
FROM film
GROUP BY language_id;

-- 11

SELECT l.name, COUNT (film_id)
FROM film join dbo.language l on film.language_id = l.language_id
GROUP BY l.language_id, l.name

-- 12

SELECT l.name, COUNT (film_id)
FROM film RIGHT JOIN dbo.language l on film.language_id = l.language_id
GROUP BY l.language_id, l.name

-- 13

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS COUTN_OF_RENTAL
FROM rental r
    RIGHT JOIN dbo.customer c on c.customer_id = r.customer_id
GROUP BY c.first_name, c.customer_id, c.last_name
HAVING COUNT(r.rental_id) > 30
ORDER BY COUTN_OF_RENTAL;

-- 16

SELECT c.first_name, c.last_name, COALESCE(SUM(p.amount), 0) AS SUM_AMOUNT,
       MIN(p.amount) AS MIN_PAYMENT, MAX(p.amount) AS MAX_PAYMENT, AVG(p.amount) AS AVG_PAYMENT
FROM customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id
    LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name;

SELECT l.name, COUNT(f.film_id) AS COUNT_OF_MOVIES
FROM language l
    LEFT JOIN dbo.film f on l.language_id = f.language_id AND
                            f.length > 350
GROUP BY l.language_id, l.name

-- 24

SELECT c.first_name, c.last_name, COALESCE(SUM(p.amount), 0) AS AMOUNT
FROM customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id AND
                          MONTH(rental_date) = 6
    LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name;