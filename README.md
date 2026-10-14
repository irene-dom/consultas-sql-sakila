# Consultas SQL · Base de datos Sakila

Proyecto de lógica SQL del Bootcamp Data & Analytics (ThePower).

## Objetivo
Resolver las 64 consultas del enunciado sobre Sakila, la base de datos de una tienda de alquiler de películas, usando **PostgreSQL** y **DBeaver**.

## Contenido del repositorio
| Archivo | Qué contiene |
|---|---|
| `consultas_sakila.sql` | Las 64 consultas. Cada una lleva encima su número y su enunciado como comentario. |
| `esquema_sakila.png` | Diagrama entidad-relación de la base de datos, exportado desde DBeaver. |

## La base de datos
Sakila tiene 15 tablas. Las principales son:
- **film**: películas (título, duración, clasificación, precio de alquiler…).
- **actor** y **film_actor**: actores y en qué películas salen.
- **category** y **film_category**: categorías y a cuál pertenece cada película.
- **inventory**: copias físicas de cada película en cada tienda.
- **rental**: alquileres (qué copia, qué cliente, cuándo se alquila y cuándo se devuelve).
- **payment**: pagos de cada alquiler.
- **customer**, **staff** y **store**: clientes, empleados y tiendas.

![Esquema de la base de datos](esquema_sakila.png)

## Pasos seguidos
1. Instalé PostgreSQL y DBeaver, y creé la conexión a una base de datos nueva.
2. Cargué el script de la base de datos (`BBDD_Proyecto_shakila_sinuser.sql`) desde DBeaver.
3. Generé el diagrama del esquema (clic derecho sobre `public` → *View Diagram*) y lo exporté como imagen.
4. Escribí las consultas por bloques, comprobando en cada una que el resultado tuviera sentido:
   - **Bloque 1 (1–17):** consultas sobre una tabla: filtros (`WHERE`, `BETWEEN`, `ILIKE`, `IN`), ordenación y agregados (`COUNT`, `AVG`, `MIN`, `MAX`, `STDDEV`, `VARIANCE`).
   - **Bloque 2 (18–36):** relaciones entre tablas con `JOIN` (`INNER`, `LEFT`, `FULL OUTER`), agrupaciones con `GROUP BY` y `HAVING`, y subconsultas sencillas para comparar con la media.
   - **Bloque 3 (37–54):** `CROSS JOIN` razonado (ejercicio 44), una vista (`actor_num_peliculas`) y dos tablas temporales (`cliente_rentas_temporal` y `peliculas_alquiladas`).
   - **Bloque 4 (55–64):** subconsultas en el `WHERE` (con `NOT IN` y comparaciones con un valor calculado) y combinaciones con `CROSS JOIN`.

## Decisiones y buenas prácticas
- Alias cortos en las tablas (`f` para film, `a` para actor…) para que las consultas se lean mejor.
- `ILIKE` para buscar nombres y títulos sin depender de mayúsculas o minúsculas.
- `LEFT JOIN` cuando el enunciado pide incluir también los registros sin relación (películas sin actores, clientes sin alquileres…).
- `COUNT(DISTINCT …)` cuando hay que contar películas distintas y no alquileres (ejercicio 60).
- Ejercicio 4: la consulta es correcta, pero no devuelve filas porque `original_language_id` está vacío (NULL) en todas las películas.
- Ejercicio 44: el `CROSS JOIN` entre película y categoría no aporta valor; la explicación está debajo de la consulta.

## Autora
Irene Domínguez
