use sakila

#1. Find all the film titles that are not in the inventory.

select title from film
where film_id not in (select film_id from inventory)




#2. Find all the films that are in the inventory but were never rented.
    #Show title and inventory_id.
    #This exercise is complicated.
    #hint: use sub-queries in FROM and in WHERE or use left join and ask if one of the fields is null

select f.title, inv.inventory_id from film f 
join inventory inv on inv.film_id = f.film_id
and inv.inventory_id not in (select inventory_id from rental)



#3. Generate a report with:
    #customer (first, last) name, store id, film title,
    #when the film was rented and returned for each of these customers
    #order by store_id, customer last_name


select c.first_name, c.last_name, c.store_id, f.title, r.rental_date, r.return_date from rental r 
join customer c on r.customer_id = c.customer_id 
join inventory i on r.inventory_id = i.inventory_id 
join film f on i.film_id = f.film_id 
order by c.store_id, c.last_name;



#4. Show sales per store (money of rented films)
    #show store's city, country, manager info and total sales (money)
    #(optional) Use concat to show city and country and manager first and last name

select c.city, co.country, st.first_name, st.last_name, sum(p.amount) as ventas from payment p 
join staff st on p.staff_id = st.staff_id
join store s on st.store_id = s.store_id 
join address a on s.address_id = a.address_id 
join city c on a.city_id = c.city_id 
join country co on c.country_id = co.country_id 
group by c.city, co.country, st.first_name, st.last_name;


#5. Which actor has appeared in the most films?

select a.first_name, a.last_name, count(fa.film_id) as cantidad_peliculas from actor a 
join film_actor fa on a.actor_id = fa.actor_id 
group by a.actor_id, a.first_name, a.last_name
order by cantidad_peliculas desc 
limit 1;

