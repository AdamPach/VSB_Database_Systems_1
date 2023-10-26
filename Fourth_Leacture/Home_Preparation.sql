
-- 8 IN
SELECT film_id, title
FROM film
WHERE film_id NOT IN (
        SELECT film_id
        FROM film_actor
            JOIN dbo.actor a on film_actor.actor_id = a.actor_id
        WHERE a.first_name = 'PENELOPE' AND a.last_name = 'GUINESS'
    );

-- EXISTS

SELECT film_id, title
FROM film
WHERE NOT EXISTS (
       SELECT 1
       FROM film_actor
            JOIN dbo.actor a on a.actor_id = film_actor.actor_id
       WHERE a.first_name = 'PENELOPE' AND a.last_name = 'GUINESS' AND film_actor.film_id = film.film_id
    );

-- 9

SELECT first_name, last_name
FROM customer
WHERE EXISTS(
    SELECT *
    FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
    WHERE f.title = 'ENEMY ODDS' AND r.customer_id = customer.customer_id
) AND EXISTS(
    SELECT *
    FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
    WHERE f.title = 'POLLOCK DELIVERANCE' AND r.customer_id = customer.customer_id
) AND EXISTS(
    SELECT *
    FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
    WHERE f.title = 'FALCON VOLUME' AND r.customer_id = customer.customer_id
);

-- 10

SELECT customer_id, first_name, last_name
FROM customer
WHERE EXISTS(
    SELECT *
    FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
    WHERE f.title = 'GRIT CLOCKWORK'
        AND r.customer_id = customer.customer_id
        AND MONTH(rental_date) = 5
) AND EXISTS(
    SELECT *
    FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
    WHERE f.title = 'GRIT CLOCKWORK'
        AND r.customer_id = customer.customer_id
        AND MONTH(rental_date) = 6
);

-- 13

SELECT film_id, title
FROM film f1
WHERE EXISTS(
    SELECT *
    FROM actor a
        JOIN film_actor fa ON a.actor_id = fa.actor_id
        JOIN film f2 ON fa.film_id = f2.film_id
    WHERE a.first_name = 'BURT'
        AND a.last_name = 'POSEY'
        AND f1.length < f2.length
);

-- 14

SELECT first_name, last_name
FROM actor a
WHERE EXISTS(
    SELECT *
    FROM film f
        JOIN film_actor fa ON f.film_id = fa.film_id
    WHERE f.length < 50 AND a.actor_id = fa.actor_id
);

-- ANY SOLUTION

SELECT first_name, last_name
FROM actor
WHERE 50 > ANY (
        SELECT length
        FROM film
            JOIN film_actor fa ON film.film_id = fa.film_id
        WHERE fa.actor_id = actor.actor_id
    );


-- 19

SELECT COUNT(*)
FROM film f1
WHERE NOT EXISTS(
    SELECT *
    FROM actor a
        JOIN film_actor fa ON a.actor_id = fa.actor_id
        JOIN film f2 ON fa.film_id = f2.film_id
    WHERE a.first_name = 'BURT' AND a.last_name = 'POSEY' AND f1.length >= f2.length
)

SELECT COUNT(*)
FROM film
WHERE length < ALL (
SELECT film.length
FROM
actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE actor.first_name = 'BURT' AND actor.last_name = 'POSEY'
)

-- 20

SELECT first_name, last_name
FROM actor a
WHERE NOT EXISTS(
    SELECT *
    FROM film
        JOIN film_actor fa ON film.film_id = fa.film_id
    WHERE a.actor_id = fa.actor_id AND film.length >= 180
) AND a.actor_id IN (SELECT actor_id FROM film_actor);
