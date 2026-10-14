-- =============================================================
-- DataProject: Lógica Consultas SQL · Base de datos Sakila (PostgreSQL)
-- Bootcamp Data & Analytics (ThePower)
-- Autora: Irene Domínguez
-- Cada consulta lleva encima su número y su enunciado (resumido).
-- =============================================================


-- =============================================================
-- BLOQUE 1 · Consultas sobre una tabla, filtros y agregados
-- =============================================================

-- 1. Crea el esquema de la BBDD.
-- El esquema (diagrama entidad-relación) se ha generado en DBeaver:
-- clic derecho sobre el esquema "public" → View Diagram → exportar como imagen.
-- Está en el repositorio como "esquema_sakila.png".


-- 2. Muestra los nombres de todas las películas con clasificación por edades 'R'.
SELECT title
FROM film
WHERE rating = 'R';


-- 3. Encuentra los nombres de los actores con actor_id entre 30 y 40.
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id BETWEEN 30 AND 40;


-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT title
FROM film
WHERE language_id = original_language_id;
-- Nota: si original_language_id está vacío (NULL) en todas las películas,
-- la consulta no devuelve filas, porque NULL no es igual a ningún valor.


-- 5. Ordena las películas por duración de forma ascendente.
SELECT title, length
FROM film
ORDER BY length ASC;


-- 6. Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido.
SELECT first_name, last_name
FROM actor
WHERE last_name ILIKE '%allen%';


-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla film
--    y muestra la clasificación junto al recuento.
SELECT rating, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating
ORDER BY total_peliculas DESC;


-- 8. Encuentra el título de todas las películas que son 'PG-13' o tienen una
--    duración mayor a 3 horas.
SELECT title, rating, length
FROM film
WHERE rating = 'PG-13'
   OR length > 180;


-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT ROUND(VARIANCE(replacement_cost), 2) AS varianza,
       ROUND(STDDEV(replacement_cost), 2)   AS desviacion_tipica
FROM film;


-- 10. Encuentra la mayor y menor duración de una película.
SELECT MAX(length) AS duracion_maxima,
       MIN(length) AS duracion_minima
FROM film;


-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT r.rental_id, r.rental_date, p.amount
FROM rental AS r
JOIN payment AS p ON p.rental_id = r.rental_id
ORDER BY r.rental_date DESC
OFFSET 2
LIMIT 1;


-- 12. Encuentra el título de las películas que no sean ni 'NC-17' ni 'G' en cuanto
--     a su clasificación.
SELECT title, rating
FROM film
WHERE rating NOT IN ('NC-17', 'G');


-- 13. Encuentra el promedio de duración de las películas para cada clasificación
--     y muestra la clasificación junto con el promedio.
SELECT rating, ROUND(AVG(length), 2) AS duracion_media
FROM film
GROUP BY rating
ORDER BY duracion_media DESC;


-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT title, length
FROM film
WHERE length > 180;


-- 15. ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(amount) AS ingresos_totales
FROM payment;


-- 16. Muestra los 10 clientes con mayor valor de id.
SELECT customer_id, first_name, last_name
FROM customer
ORDER BY customer_id DESC
LIMIT 10;


-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película 'Egg Igby'.
SELECT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN film AS f        ON f.film_id = fa.film_id
WHERE f.title ILIKE 'Egg Igby';


-- =============================================================
-- BLOQUE 2 · JOINs, medias y agrupaciones
-- =============================================================

-- 18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT title
FROM film
ORDER BY title;


-- 19. Encuentra el título de las películas que son comedias y tienen una duración
--     mayor a 180 minutos.
SELECT f.title, f.length
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c       ON c.category_id = fc.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180;


-- 20. Encuentra las categorías de películas con un promedio de duración superior a
--     110 minutos y muestra el nombre de la categoría junto con el promedio.
SELECT c.name AS categoria, ROUND(AVG(f.length), 2) AS duracion_media
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN film AS f           ON f.film_id = fc.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110
ORDER BY duracion_media DESC;


-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT ROUND(AVG(rental_duration), 2) AS media_dias_alquiler
FROM film;


-- 22. Crea una columna con el nombre y apellidos de todos los actores.
SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM actor;


-- 23. Muestra los números de alquiler por día, ordenados por cantidad de alquiler
--     de forma descendente.
SELECT DATE(rental_date) AS dia, COUNT(*) AS total_alquileres
FROM rental
GROUP BY DATE(rental_date)
ORDER BY total_alquileres DESC;


-- 24. Encuentra las películas con una duración superior al promedio.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC;


-- 25. Averigua el número de alquileres registrados por mes.
SELECT TO_CHAR(rental_date, 'YYYY-MM') AS mes, COUNT(*) AS total_alquileres
FROM rental
GROUP BY TO_CHAR(rental_date, 'YYYY-MM')
ORDER BY mes;


-- 26. Encuentra el promedio, la desviación estándar y la varianza del total pagado.
SELECT ROUND(AVG(amount), 2)      AS media,
       ROUND(STDDEV(amount), 2)   AS desviacion_tipica,
       ROUND(VARIANCE(amount), 2) AS varianza
FROM payment;


-- 27. ¿Qué películas se alquilan por encima del precio medio?
SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC, title;


-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT actor_id, COUNT(film_id) AS total_peliculas
FROM film_actor
GROUP BY actor_id
HAVING COUNT(film_id) > 40
ORDER BY total_peliculas DESC;


-- 29. Obtén todas las películas y, si están disponibles en el inventario, muestra
--     la cantidad disponible.
SELECT f.film_id, f.title, COUNT(i.inventory_id) AS copias_en_inventario
FROM film AS f
LEFT JOIN inventory AS i ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;


-- 30. Obtén los actores y el número de películas en las que ha actuado.
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY total_peliculas DESC;


-- 31. Obtén todas las películas y muestra los actores que han actuado en ellas,
--     incluso si algunas películas no tienen actores asociados.
SELECT f.title, a.first_name, a.last_name
FROM film AS f
LEFT JOIN film_actor AS fa ON fa.film_id = f.film_id
LEFT JOIN actor AS a       ON a.actor_id = fa.actor_id
ORDER BY f.title;


-- 32. Obtén todos los actores y muestra las películas en las que han actuado,
--     incluso si algunos actores no han actuado en ninguna película.
SELECT a.first_name, a.last_name, f.title
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
LEFT JOIN film AS f        ON f.film_id = fa.film_id
ORDER BY a.last_name, a.first_name;


-- 33. Obtén todas las películas que tenemos y todos los registros de alquiler.
SELECT f.title, r.rental_id, r.rental_date
FROM film AS f
FULL OUTER JOIN inventory AS i ON i.film_id = f.film_id
FULL OUTER JOIN rental AS r    ON r.inventory_id = i.inventory_id
ORDER BY f.title, r.rental_date;


-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_gastado
FROM customer AS c
JOIN payment AS p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;


-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name ILIKE 'Johnny';


-- 36. Renombra la columna "first_name" como Nombre y "last_name" como Apellido.
SELECT first_name AS "Nombre",
       last_name  AS "Apellido"
FROM actor;


-- =============================================================
-- BLOQUE 3 · CROSS JOIN, vistas y tablas temporales
-- =============================================================

-- 37. Encuentra el id del actor más bajo y más alto en la tabla actor.
SELECT MIN(actor_id) AS id_minimo,
       MAX(actor_id) AS id_maximo
FROM actor;


-- 38. Cuenta cuántos actores hay en la tabla "actor".
SELECT COUNT(*) AS total_actores
FROM actor;


-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY last_name ASC, first_name ASC;


-- 40. Selecciona las primeras 5 películas de la tabla "film".
SELECT film_id, title
FROM film
ORDER BY film_id
LIMIT 5;


-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo
--     nombre. ¿Cuál es el nombre más repetido?
SELECT first_name, COUNT(*) AS veces
FROM actor
GROUP BY first_name
ORDER BY veces DESC, first_name;
-- El nombre más repetido es el de la primera fila. Si se quiere solo ese:
SELECT first_name, COUNT(*) AS veces
FROM actor
GROUP BY first_name
ORDER BY veces DESC
LIMIT 1;


-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT r.rental_id, r.rental_date, c.first_name, c.last_name
FROM rental AS r
JOIN customer AS c ON c.customer_id = r.customer_id
ORDER BY r.rental_date;


-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos
--     que no tienen alquileres.
SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
ORDER BY c.customer_id, r.rental_date;


-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta
--     consulta? ¿Por qué? Deja la respuesta después de la consulta.
SELECT f.title, c.name AS categoria
FROM film AS f
CROSS JOIN category AS c;
-- Respuesta: no aporta valor. Un CROSS JOIN combina cada película con TODAS las
-- categorías (1.000 películas × 16 categorías = 16.000 filas), sin tener en cuenta
-- a qué categoría pertenece de verdad cada película. La relación real entre
-- películas y categorías está en la tabla film_category, así que para saber la
-- categoría de cada película hay que usar un JOIN a través de esa tabla.


-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa    ON fa.actor_id = a.actor_id
JOIN film_category AS fc ON fc.film_id = fa.film_id
JOIN category AS c       ON c.category_id = fc.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name, a.first_name;


-- 46. Encuentra todos los actores que no han participado en películas.
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
WHERE fa.actor_id IS NULL;


-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que
--     han participado.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY total_peliculas DESC;


-- 48. Crea una vista llamada "actor_num_peliculas" que muestre los nombres de los
--     actores y el número de películas en las que han participado.
CREATE OR REPLACE VIEW actor_num_peliculas AS
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- Comprobación de la vista:
SELECT * FROM actor_num_peliculas ORDER BY total_peliculas DESC;


-- 49. Calcula el número total de alquileres realizados por cada cliente.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;


-- 50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT c.name AS categoria, SUM(f.length) AS duracion_total_minutos
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c       ON c.category_id = fc.category_id
WHERE c.name = 'Action'
GROUP BY c.name;


-- 51. Crea una tabla temporal llamada "cliente_rentas_temporal" para almacenar el
--     total de alquileres por cliente.
DROP TABLE IF EXISTS cliente_rentas_temporal;
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Comprobación de la tabla temporal:
SELECT * FROM cliente_rentas_temporal ORDER BY total_alquileres DESC;


-- 52. Crea una tabla temporal llamada "peliculas_alquiladas" que almacene las
--     películas que han sido alquiladas al menos 10 veces.
DROP TABLE IF EXISTS peliculas_alquiladas;
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS veces_alquilada
FROM film AS f
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r    ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- Comprobación de la tabla temporal:
SELECT * FROM peliculas_alquiladas ORDER BY veces_alquilada DESC;


-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente
--     'Tammy Sanders' y que aún no se han devuelto. Ordena los resultados
--     alfabéticamente por título.
SELECT f.title
FROM rental AS r
JOIN customer AS c  ON c.customer_id = r.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f      ON f.film_id = i.film_id
WHERE c.first_name ILIKE 'Tammy'
  AND c.last_name  ILIKE 'Sanders'
  AND r.return_date IS NULL
ORDER BY f.title;


-- 54. Encuentra los nombres de los actores que han actuado en al menos una película
--     de la categoría 'Sci-Fi'. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa    ON fa.actor_id = a.actor_id
JOIN film_category AS fc ON fc.film_id = fa.film_id
JOIN category AS c       ON c.category_id = fc.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name, a.first_name;


-- =============================================================
-- BLOQUE 4 · Subconsultas
-- =============================================================

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas
--     que se alquilaron después de que la película 'Spartacus Cheaper' se alquilara
--     por primera vez. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN inventory AS i   ON i.film_id = fa.film_id
JOIN rental AS r      ON r.inventory_id = i.inventory_id
WHERE r.rental_date > (
        SELECT MIN(r2.rental_date)
        FROM rental AS r2
        JOIN inventory AS i2 ON i2.inventory_id = r2.inventory_id
        JOIN film AS f2      ON f2.film_id = i2.film_id
        WHERE f2.title ILIKE 'Spartacus Cheaper'
      )
ORDER BY a.last_name, a.first_name;


-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna
--     película de la categoría 'Music'.
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
        SELECT fa.actor_id
        FROM film_actor AS fa
        JOIN film_category AS fc ON fc.film_id = fa.film_id
        JOIN category AS c       ON c.category_id = fc.category_id
        WHERE c.name = 'Music'
      )
ORDER BY a.last_name, a.first_name;


-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT DISTINCT f.title
FROM film AS f
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r    ON r.inventory_id = i.inventory_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days'
ORDER BY f.title;


-- 58. Encuentra el título de todas las películas que son de la misma categoría que
--     'Animation'.
SELECT f.title
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
WHERE fc.category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Animation'
      )
ORDER BY f.title;


-- 59. Encuentra los nombres de las películas que tienen la misma duración que la
--     película 'Dancing Fever'. Ordena los resultados alfabéticamente por título.
SELECT title, length
FROM film
WHERE length = (
        SELECT length
        FROM film
        WHERE title ILIKE 'Dancing Fever'
      )
ORDER BY title;


-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas
--     distintas. Ordena los resultados alfabéticamente por apellido.
SELECT c.first_name, c.last_name, COUNT(DISTINCT i.film_id) AS peliculas_distintas
FROM customer AS c
JOIN rental AS r    ON r.customer_id = c.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name, c.first_name;


-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el
--     nombre de la categoría junto con el recuento de alquileres.
SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquileres
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN inventory AS i      ON i.film_id = fc.film_id
JOIN rental AS r         ON r.inventory_id = i.inventory_id
GROUP BY c.name
ORDER BY total_alquileres DESC;


-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT c.name AS categoria, COUNT(f.film_id) AS peliculas_2006
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN film AS f           ON f.film_id = fc.film_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY peliculas_2006 DESC;


-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT s.staff_id, s.first_name, s.last_name, st.store_id
FROM staff AS s
CROSS JOIN store AS st
ORDER BY s.staff_id, st.store_id;


-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra
--     el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS peliculas_alquiladas
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY peliculas_alquiladas DESC;
