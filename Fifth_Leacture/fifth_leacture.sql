USE SAKILA;
-- 1

-- WRONG SOLUTION
SELECT f.title, COALESCE(COUNT(fa.actor_id), 0), COALESCE(COUNT(fa.actor_id), 0)
FROM film f
    LEFT JOIN film_actor fa ON f.film_id = fa.film_id
    LEFT JOIN film_category fc ON f.film_id = fc.film_id
GROUP BY f.film_id, f.title

-- GOOD SOLUTION

-- May be on the test

SELECT title, (
        SELECT COUNT(*)
        FROM film_actor
        WHERE film_actor.film_id = film.film_id
    ) as POCET_HERCU, (
        SELECT COUNT(*)
        FROM film_category
        WHERE film_category.film_id = film.film_id
    )
FROM film

-- 6

SELECT *
FROM customer c
WHERE (
    SELECT COUNT(*)
    FROM payment
    WHERE c.customer_id = payment.customer_id
        AND payment.amount > 4
          ) >
      (
        SELECT COUNT(*)
        FROM payment
        WHERE c.customer_id = payment.customer_id
            AND payment.amount <= 4
    );

SELECT first_name, last_name, (
    SELECT COUNT(*)
    FROM payment
    WHERE c.customer_id = payment.customer_id
        AND payment.amount > 4
    ) as pocet_pres, (
    SELECT COUNT(*)
    FROM payment
    WHERE c.customer_id = payment.customer_id
            AND payment.amount <= 4
    ) as pocet_pod
FROM customer c

SELECT *
FROM (
    SELECT first_name, last_name, (
    SELECT COUNT(*)
    FROM payment
    WHERE c.customer_id = payment.customer_id
        AND payment.amount > 4
    ) as pocet_pres, (
    SELECT COUNT(*)
    FROM payment
    WHERE c.customer_id = payment.customer_id
            AND payment.amount <= 4
    ) as pocet_pod
FROM customer c
) pocty
WHERE pocet_pres > pocet_pod;

-- 7

WITH horrors_comedies AS (
SELECT first_name, last_name,
       (
       SELECT COUNT(*)
       FROM film_actor
            JOIN dbo.film f on f.film_id = film_actor.film_id
            JOIN dbo.film_category fc on f.film_id = fc.film_id
            JOIN dbo.category c on c.category_id = fc.category_id
       WHERE c.name = 'HORROR' AND actor.actor_id = film_actor.actor_id
       ) as horror_count,
    (
        SELECT COUNT(*)
       FROM film_actor
            JOIN dbo.film f on f.film_id = film_actor.film_id
            JOIN dbo.film_category fc on f.film_id = fc.film_id
            JOIN dbo.category c on c.category_id = fc.category_id
       WHERE c.name = 'COMEDY' AND actor.actor_id = film_actor.actor_id
    ) as comedies_count
FROM actor
) SELECT *
    FROM horrors_comedies
    WHERE comedies_count > 2 * horror_count

SELECT *
FROM film f1
WHERE NOT EXISTS(
    SELECT *
    FROM film f2
    WHERE f2.length > f1.length
);

SELECT *
FROM film
WHERE length = (SELECT MAX(length) FROM film)


-- 14

-- CAN BE ON THE TEST
SELECT *
FROM film f1
WHERE f1.length = (SELECT MAX(f2.length) FROM film f2 WHERE f1.rating = f2.rating);

-- 16
SELECT a.first_name, a.last_name, f.title, f.length
FROM actor a
    LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
    LEFT JOIN film f ON fa.film_id = f.film_id
WHERE f.length = (
        SELECT MAX(f2.length)
        FROM film f2
            LEFT JOIN film_actor fa2 ON f2.film_id = fa2.film_id
        WHERE a.actor_id = fa2.actor_id
    );

-- 19

SELECT *
FROM customer
WHERE EXISTS(
    SELECT *
    FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
    WHERE r.customer_id = customer.customer_id
        AND f.length = (SELECT MAX(f2.length) FROM film f2)
) AND EXISTS(
    SELECT *
    FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
    WHERE r.customer_id = customer.customer_id
        AND f.length = (SELECT MIN(f2.length) FROM film f2)
);

