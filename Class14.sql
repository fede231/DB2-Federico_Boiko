use sakila;
#1. Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.

select concat(c.first_name, ' ', c.last_name) as full_name,
       a.address,
       ci.city
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where co.country = 'Argentina';

#2. Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.

select f.title,
       l.name as language,
       case f.rating
            when 'G' then 'General Audiences – All ages admitted'
            when 'PG' then 'Parental Guidance Suggested – Some material may not be suitable for children'
            when 'PG-13' then 'Parents Strongly Cautioned – Some material may be inappropriate for children under 13'
            when 'R' then 'Restricted – Under 17 requires accompanying parent or adult guardian'
            when 'NC-17' then 'Adults Only – No one 17 and under admitted'
       end as rating_full
from film f
join language l on f.language_id = l.language_id;

#3. Write a search query that shows all the films (title and release year) an actor was part of. Assume the actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.

set @actor_name = trim('  toM hAnKs ');

select f.title, f.release_year
from film f
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
where concat(a.first_name, ' ', a.last_name) like concat('%', @actor_name, '%')
collate utf8mb4_general_ci;

#4. Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. There should be returned column with two possible values 'Yes' and 'No'.

select f.title,
       concat(c.first_name, ' ', c.last_name) as customer_name,
       case when r.return_date is not null then 'Yes' else 'No' end as returned
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join customer c on r.customer_id = c.customer_id
where month(r.rental_date) in (5, 6);

#5. Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.

# CAST: convierte un tipo de dato a otro
select cast(rental_date as date) as fecha_sola from rental limit 5;

# CONVERT: igual que CAST, pero también puede cambiar el charset
select convert(rental_date, date) as fecha_sola from rental limit 5;
select convert('Hola', char character set utf8);

# Dif: en MySQL casi no hay diferencia práctica si es sólo tipo de dato.
# CONVERT sirve también para conversión de caracteres.

#6. Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.

# Todas sirven para manejar valores NULL
# NVL: no existe en MySQL, es de Oracle
# ISNULL(expr): devuelve 1 si es NULL, 0 si no
# IFNULL(expr, valor): si expr es NULL, devuelve valor
# COALESCE(expr1, expr2, ...): devuelve el primer valor NO NULL
