-- 1

SELECT f.title, count(fa.actor_id) as ACTORS, count(ca.category_id)
FROM film f
    left join dbo.film_actor fa on f.film_id = fa.film_id
    left join film_category ca on f.film_id = ca.film_id
group by f.film_id, f.title


SELECT film_id, title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = 1
    );

SELECT film_id, title
FROM film
WHERE EXISTS(
    SELECT 1
    FROM film_actor
    WHERE film_actor.film_id = film.film_id and film_actor.actor_id = 1
);

-- 3

SELECT film_id, title
FROM film f
WHERE EXISTS(
  SELECT 1
  FROM film_actor fa
  WHERE f.film_id = fa.film_id
    AND fa.actor_id = 1
) AND EXISTS(
    SELECT 1
  FROM film_actor fa
  WHERE f.film_id = fa.film_id
    AND fa.actor_id = 10
);

-- 4

SELECT film_id, title
FROM film f
WHERE EXISTS(
  SELECT 1
  FROM film_actor fa
  WHERE f.film_id = fa.film_id
    AND fa.actor_id = 1
) OR EXISTS(
    SELECT 1
  FROM film_actor fa
  WHERE f.film_id = fa.film_id
    AND fa.actor_id = 10
);

-- 5

SELECT film_id
FROM film
WHERE film_id NOT IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = 1
);

-- 6

SELECT film_id, title
FROM film
WHERE
film_id IN (
SELECT film_id FROM film_actor
WHERE actor_id = 1 OR actor_id = 10
)
AND NOT
(
film_id IN (
SELECT film_id FROM film_actor WHERE actor_id = 1
)
AND
film_id IN (
SELECT film_id FROM film_actor WHERE actor_id = 10
)
)

--7

SELECT film_id, title
FROM film
WHERE EXISTS(
    SELECT 1
    FROM film_actor
        JOIN dbo.actor a on a.actor_id = film_actor.actor_id
    WHERE a.first_name = 'PENELOPE' AND a.last_name = 'GUINESS'
) AND EXISTS(
    SELECT 1
    FROM film_actor
        JOIN dbo.actor a on a.actor_id = film_actor.actor_id
    WHERE a.first_name = 'CHRISTIAN' AND a.last_name = 'GABLE'
);

SELECT film_id, title
FROM film
WHERE NOT EXISTS(
    SELECT 1
    FROM film_actor
        JOIN dbo.actor a on a.actor_id = film_actor.actor_id
    WHERE a.first_name = 'PENELOPE'
      AND a.last_name = 'GUINESS'
      AND film_actor.film_id = film.film_id
);

-- 12

SELECT *
FROM film
WHERE length < ANY(
        SELECT length
        FROM film
            JOIN film_actor fa on film.film_id = fa.film_id
            JOIN actor a on fa.actor_id = a.actor_id
        WHERE a.first_name = 'BURT' AND last_name = 'POSEY'
    );

SELECT *
FROM film f1
WHERE EXISTS(
    SELECT length
        FROM film f2
            JOIN film_actor fa on f2.film_id = fa.film_id
            JOIN actor a on fa.actor_id = a.actor_id
        WHERE a.first_name = 'BURT' AND last_name = 'POSEY' AND f1.length < f2.length
);

-- 19

SELECT title
FROM film
WHERE length < ALL (
    SELECT film.length
    FROM actor
        JOIN film_actor ON actor.actor_id = film_actor.actor_id
        JOIN film ON film_actor.film_id = film.film_id
    WHERE actor.first_name = 'BURT' AND actor.last_name = 'POSEY'
);

SELECT *
FROM film f1
WHERE NOT EXISTS(
    SELECT length
        FROM film f2
            JOIN film_actor fa on f2.film_id = fa.film_id
            JOIN actor a on fa.actor_id = a.actor_id
        WHERE a.first_name = 'BURT' AND last_name = 'POSEY' AND f1.length <= f2.length
);

-- 15

SELECT DISTINCT f1.title
FROM
    rental r1
        JOIN inventory i1 ON r1.inventory_id = i1.inventory_id
        JOIN film f1 ON i1.film_id = f1.film_id
WHERE
    EXISTS (
        SELECT *
        FROM
            rental r2
            JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
        WHERE i2.film_id = i1.film_id AND r1.rental_id != r2.rental_id
)

-- 16
SELECT DISTINCT f1.title
FROM
    rental r1
        JOIN inventory i1 ON r1.inventory_id = i1.inventory_id
        JOIN film f1 ON i1.film_id = f1.film_id
WHERE
    EXISTS (
        SELECT *
        FROM
            rental r2
            JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
        WHERE i2.film_id = i1.film_id AND r1.customer_id != r2.customer_id
);

SELECT first_name, last_name
FROM actor
WHERE NOT EXISTS(
    SELECT 1
    FROM film f
        JOIN dbo.film_actor fa on f.film_id = fa.film_id
    WHERE fa.actor_id = actor.actor_id AND f.length > 180
) AND actor_id IN (SELECT actor_id FROM film_actor)