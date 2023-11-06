use PAC0076;
--10

SELECT first_name, last_name
FROM customer c1
WHERE (
    SELECT COUNT(*)
    FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
        JOIN film_actor fa ON f.film_id = fa.film_id
        JOIN actor a ON fa.actor_id = a.actor_id
    WHERE a.first_name = 'TOM' AND a.last_name = 'MCKELLEN'
        AND c1.customer_id = r.customer_id
          ) > (
    SELECT COUNT(*)
    FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film_actor fa ON i.film_id = fa.film_id
        JOIN actor a ON fa.actor_id = a.actor_id
    WHERE a.first_name = 'GROUCHO' AND a.last_name = 'SINATRA'
        AND c1.customer_id = r.customer_id
    )

-- 15

SELECT c.first_name, c.last_name, f.title
FROM customer c
    JOIN rental r1 ON c.customer_id = r1.customer_id
    JOIN inventory i ON r1.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
WHERE r1.rental_date = (
        SELECT MAX(r2.rental_date)
        FROM rental r2
        WHERE r2.customer_id = c.customer_id
    );

SELECT c.first_name, c.last_name, f.title
FROM customer c
    JOIN rental r1 ON c.customer_id = r1.customer_id
    JOIN inventory i ON r1.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
WHERE NOT EXISTS (
        SELECT *
        FROM rental r2
        WHERE c.customer_id = r2.customer_id
            AND r2.rental_date > r1.rental_date
    );

SELECT c.first_name, c.last_name, f.title
FROM customer c
    JOIN rental r1 ON c.customer_id = r1.customer_id
    JOIN inventory i ON r1.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
WHERE EXISTS(
    SELECT *
    FROM film f2
        JOIN film_actor fa ON f2.film_id = fa.film_id
        JOIN actor a ON fa.actor_id = a.actor_id
    WHERE a.first_name = 'PENELOPE' AND a.last_name = 'GUINESS'
        AND f.film_id = f2.film_id
) AND NOT EXISTS(
    SELECT *
    FROM rental r2
        JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    WHERE c.customer_id = r2.customer_id
        AND r2.rental_date > r1.rental_date
        AND EXISTS(
            SELECT *
            FROM film f3
                JOIN film_actor fa ON f3.film_id = fa.film_id
                JOIN actor a ON fa.actor_id = a.actor_id
         WHERE a.first_name = 'PENELOPE' AND a.last_name = 'GUINESS'
            AND i2.film_id = f3.film_id
    )
)
ORDER BY c.customer_id;

SELECT customer.customer_id, first_name, last_name, film.title
FROM
customer
JOIN rental r1 ON customer.customer_id = r1.customer_id
JOIN inventory i1 ON r1.inventory_id = i1.inventory_id
JOIN film ON i1.film_id = film.film_id
WHERE
film.film_id IN (
SELECT film_id
FROM film_actor JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE actor.first_name = 'PENELOPE' AND actor.last_name = 'GUINESS'
) AND r1.rental_date = (
SELECT MAX(rental_date)
FROM rental r2 JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
WHERE r1.customer_id = r2.customer_id AND i2.film_id IN (
SELECT film_id
FROM film_actor JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE actor.first_name = 'PENELOPE' AND actor.last_name = 'GUINESS'
)
)
ORDER BY customer.customer_id