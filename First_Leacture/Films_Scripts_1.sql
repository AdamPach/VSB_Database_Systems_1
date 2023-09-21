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