use sakila;

#1
select title, special_features 
from film 
where rating = 'PG-13';

#2
select length
from film;

#3
select title, rental_rate, replacement_cost
from film
where replacement_cost between 20.00 and 24.00;

#4
select f.title, c.name as category, f.rating
from film f
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
where f.special_features like '%Behind the Scenes%';

#5
select a.first_name, a.last_name
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id = f.film_id
where f.title = 'ZOOLANDER FICTION';

#6
select a.address, c.city, co.country
from store s
inner join address a on s.address_id = a.address_id
inner join city c on a.city_id = c.city_id
inner join country co on c.country_id = co.country_id
where s.store_id = 1;

#7
select f1.title as film_1, f2.title as film_2, f1.rating
from film f1
inner join film f2 on f1.rating = f2.rating and f1.film_id < f2.film_id
order by f1.rating;

#8
select f.title, m.first_name as manager_first_name, m.last_name as manager_last_name
from inventory i
inner join film f on i.film_id = f.film_id
inner join store s on i.store_id = s.store_id
inner join staff m on s.manager_staff_id = m.staff_id
where i.store_id = 2;
