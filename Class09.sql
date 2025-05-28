USE sakila;
#Get the amount of cities per country in the database. Sort them by country, country_id.
#Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of #cities to the lowest
#Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films.
#Show the ones who spent more money first .
#Which film categories have the larger film duration (comparing average)?
#Order by average in descending order
#Show sales per film rating

#1
select co.country_id, co.country, count(ci.city_id) as city_count
from country co
join city ci on co.country_id = ci.country_id
group by co.country_id, co.country
order by co.country, co.country_id;
#2
select co.country_id, co.country, count(ci.city_id) as city_count
from country co
join city ci on co.country_id = ci.country_id
group by co.country_id, co.country
having count(ci.city_id) > 10
order by city_count desc;
#3
select 
  c.first_name, 
  c.last_name, 
  a.address, 
  count(r.rental_id) as total_rented,
  sum(p.amount) as total_spent
from customer c
join address a on c.address_id = a.address_id
join rental r on c.customer_id = r.customer_id
join payment p on r.rental_id = p.rental_id
group by c.customer_id, c.first_name, c.last_name, a.address
order by total_spent desc;
#4
select 
  cat.name as category, 
  avg(f.length) as avg_duration
from film f
join film_category fc on f.film_id = fc.film_id
join category cat on fc.category_id = cat.category_id
group by cat.name
order by avg_duration desc;
#5
select 
  f.rating, 
  sum(p.amount) as total_sales
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by f.rating
order by total_sales desc;