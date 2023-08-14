USE sakila;

-- LAB | SQL Subqueries

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT
    f.title AS film_title,
    COUNT(i.inventory_id) AS number_of_copies
FROM
    film f
JOIN
    inventory i ON f.film_id = i.film_id
WHERE
    f.title = 'Hunchback Impossible'
GROUP BY
    f.film_id;

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT
    f.title AS film_title,
    f.length AS film_length
FROM
    film f
WHERE
    f.length > (
        SELECT AVG(length)
        FROM film
    );

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM
    actor a
WHERE
    a.actor_id IN (
        SELECT
            fa.actor_id
        FROM
            film_actor fa
        JOIN
            film f ON fa.film_id = f.film_id
        WHERE
            f.title = 'Alone Trip'
    );

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM
    actor a
WHERE
    a.actor_id IN (
        SELECT
            fa.actor_id
        FROM
            film_actor fa
        JOIN
            film f ON fa.film_id = f.film_id
        WHERE
            f.title = 'Alone Trip'
    );

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT
    first_name,
    last_name,
    email
FROM
    customer
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            address
        WHERE
            city_id IN (
                SELECT
                    city_id
                FROM
                    city
                WHERE
                    country_id = (
                        SELECT
                            country_id
                        FROM
                            country
                        WHERE
                            country = 'Canada'
                    )
            )
    );

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT
    actor_id,
    COUNT(actor_id) AS film_count
FROM
    film_actor
GROUP BY
    actor_id
ORDER BY
    film_count DESC
LIMIT 1;

SELECT
    f.title AS film_title
FROM
    film f
JOIN
    film_actor fa ON f.film_id = fa.film_id
WHERE
    fa.actor_id = (SELECT actor_id FROM film_actor GROUP BY actor_id ORDER BY COUNT(actor_id) DESC LIMIT 1);

-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT
    customer_id,
    SUM(amount) AS total_payment
FROM
    payment
GROUP BY
    customer_id
ORDER BY
    total_payment DESC
LIMIT 1;

SELECT
    f.title AS film_title
FROM
    film f
JOIN
    inventory i ON f.film_id = i.film_id
JOIN
    rental r ON i.inventory_id = r.inventory_id
JOIN
    payment p ON r.rental_id = p.rental_id
WHERE
    p.customer_id = (SELECT customer_id FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1);

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT
    c.customer_id AS client_id,
    SUM(p.amount) AS total_amount_spent,
    (
        SELECT AVG(total_amount_spent)
        FROM (
            SELECT
                c.customer_id,
                SUM(p.amount) AS total_amount_spent
            FROM
                payment p
            JOIN
                customer c ON p.customer_id = c.customer_id
            GROUP BY
                c.customer_id
        ) AS avg_total
    ) AS average_amount_spent
FROM
    payment p
JOIN
    customer c ON p.customer_id = c.customer_id
GROUP BY
    c.customer_id
HAVING
    total_amount_spent > (
        SELECT AVG(total_amount_spent)
        FROM (
            SELECT
                c.customer_id,
                SUM(p.amount) AS total_amount_spent
            FROM
                payment p
            JOIN
                customer c ON p.customer_id = c.customer_id
            GROUP BY
                c.customer_id
        ) AS avg_total
    );










