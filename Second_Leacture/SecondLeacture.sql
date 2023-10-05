use PAC0076;

SELECT *
FROM city c
    JOIN country ON c.country_id = country.country_id;

-- 5
SELECT customer.first_name, customer.last_name, city.city
FROM customer
    JOIN address ON customer.address_id = address.address_id
    JOIN city ON address.city_id = city.city_id
WHERE city.city = 'Cuman';

-- 6
SELECT first_name, last_name, city
FROM customer
    JOIN address ON customer.address_id = address.address_id
    JOIN city ON address.city_id = city.city_id;


-- 8

SELECT film.title, actor.first_name, actor.last_name
FROM film
    JOIN film_actor ON film.film_id = film_actor.film_id
    JOIN actor ON film_actor.actor_id = actor.actor_id
ORDER BY film.title;

-- 9

SELECT actor.first_name, actor.last_name, film.title
FROM film
    JOIN film_actor ON film.film_id = film_actor.film_id
    JOIN actor ON film_actor.actor_id = actor.actor_id
ORDER BY actor.first_name, actor.last_name;

-- 10

SELECT film.title, category.name
FROM film
    JOIN film_category ON film.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'HORROR';

-- 11
SELECT store.store_id, staff.first_name, staff.last_name, store_address.address as store_address, manager_address.address as manager_address
FROM store
    JOIN address store_address ON store.address_id = store_address.address_id
    JOIN staff ON store.manager_staff_id = staff.staff_id
    JOIN address manager_address ON staff.address_id = manager_address.address_id;

-- 12

SELECT film.film_id, film.title, film_category.category_id, film_actor.actor_id
FROM film
    JOIN film_category on film.film_id = film_category.film_id
    JOIN film_actor on film.film_id = film_actor.film_id
WHERE film.film_id = 1
ORDER BY film.film_id

-- 13

SELECT DISTINCT film_actor.actor_id, film_category.category_id
FROM film
    JOIN film_category on film.film_id = film_category.film_id
    JOIN film_actor on film.film_id = film_actor.film_id
WHERE film.film_id = 1
ORDER BY film_actor.actor_id;

SELECT DISTINCT film.title
FROM film
    JOIN inventory ON film.film_id = inventory.film_id;

SELECT *
FROM language
    LEFT JOIN film ON language.language_id = film.language_id;

SELECT *
FROM film
    LEFT JOIN language native_language ON film.original_language_id = native_language.language_id
    JOIN language transtaled_language ON film.language_id = transtaled_language.language_id