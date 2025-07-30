use sakila;
#1. Create a view named **list_of_customers**, it should contain the following columns:
  #- customer id
  #- customer full name, 
  #- address
  #- zip code
  #- phone 
  #- city
  #- country
  #- status (when active column is 1 show it as 'active', otherwise is 'inactive') 
  #- store id

create or replace view list_of_customers as
select c.customer_id, concat(c.first_name, ' ', c.last_name) as full_name, a.address, a.postal_code as zip_code, a.phone, ci.city, co.country,
  case when c.active = 1 then 'active' else 'inactive' end as status, c.store_id
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id;

#2. Create a view named **film_details**, it should contain the following columns:
#film id,  title, description,  category,  price,  length,  rating, actors  - as a string of all the actors separated by comma. Hint use GROUP_CONCAT

create or replace view film_details as
select f.film_id, f.title, f.description, c.name as categoria, f.rental_rate as precio, f.length, f.rating,
group_concat(concat(a.first_name, ' ', a.last_name) separator ', ') as actores
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
group by f.film_id;


#3. Create view **sales_by_film_category**, it should return 'category' and 'total_rental' columns.

create or replace view sales_by_film_category as
select c.name as categorias, count(r.rental_id) as total
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by c.name;

#4. Create a view called **actor_information** where it should return, actor id, first name, last name and the amount of films he/she acted on.

create or replace view actor_information as
select a.actor_id, a.first_name, a.last_name, count(fa.film_id) as cantidad_peliculas
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id;


#5. Analyze view **actor_info**, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each. 

#actor_info:

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `actor_info` AS
select
    `a`.`actor_id` AS `actor_id`,
    `a`.`first_name` AS `first_name`,
    `a`.`last_name` AS `last_name`,
    group_concat(distinct concat(`c`.`name`, ': ',(select group_concat(`f`.`title` order by `f`.`title` ASC separator ', ') from ((`film` `f` join `film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `film_actor` `fa` on((`f`.`film_id` = `fa`.`film_id`))) where ((`fc`.`category_id` = `c`.`category_id`) and (`fa`.`actor_id` = `a`.`actor_id`)))) order by `c`.`name` ASC separator '; ') AS `film_info`
from
    (((`actor` `a`
left join `film_actor` `fa` on
    ((`a`.`actor_id` = `fa`.`actor_id`)))
left join `film_category` `fc` on
    ((`fa`.`film_id` = `fc`.`film_id`)))
left join `category` `c` on
    ((`fc`.`category_id` = `c`.`category_id`)))
group by
    `a`.`actor_id`,
    `a`.`first_name`,
    `a`.`last_name`;

#La vista actor_info trae info agrupada por actor, muestra:
#Cantidad de peliculas, categorias en las que actuo y peliculas en las que estuvo
#Se usan left joins para no excluir actores sin peliculas y group_concat une los valores unicos de cada actor
#Count cuenta en cuantas peliculas participo cada uno y el group by agrupa todo por id

#6. Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc. 

#Las materialized views son como tablas que guardan el resultado de una consulta,
# se usan para mejorar el rendimiento si la query es pesada y no cambia tanto

#Algunas alternativas puede ser:
# Crear una tabla con los resultados
# Usar eventos o triggers para actualizarla
# Hacerlo desde la app o un cron que actualice

#DBMZ que soportan materialized views:
#Oracle (sí)
#PostgreSQL (sí)
#SQL Server (no directo, pero se puede simular con indexed views)
#MySQL (no nativo, pero se puede simular con tablas + triggers o jobs)
