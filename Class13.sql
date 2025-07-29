#1. Add a new customer
    #To store 1
	#For address use an existing address. The one that has the biggest address_id in 'United States'

insert into customer (store_id, first_name, last_name, email, address_id, active)
values (1, 'Luciano', 'marquez', 'marquezluciano10@gmail.com', (select max(a.address_id) from address a
        join city c on a.city_id = c.city_id
        join country co on c.country_id = co.country_id
        where co.country = 'United States'),1 );

#2. Add a rental
   	#Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
   	#Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
   	#Select any staff_id from Store 2.

insert into rental (rental_date, inventory_id, customer_id, staff_id)
values (now(), (select max(i.inventory_id) from inventory i
        join film f on i.film_id = f.film_id
        where f.title = 'DUDE BLINDNESS'),
        (select customer_id from customer
        order by customer_id desc limit 1),
        (select staff_id from staff
        where store_id = 2 limit 1));

#3. Update film year based on rating
   	#For example if rating is 'G' release date will be '2001'
   	#You can choose the mapping between rating and year.
   	#Write as many statements are needed.

update film set release_year = 2001 where rating = 'G';
update film set release_year = 2003 where rating = 'NC-17';
update film set release_year = 2005 where rating = 'PG-13';
update film set release_year = 2007 where rating = 'PG';
update film set release_year = 2009 where rating = 'R';

#4. Return a film
   	#Write the necessary statements and queries for the following steps.
   	#Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
   	#Use the id to return the film.

update rental set return_date = now()
where rental_id = (select rental_id from (select rental_id from rental
        where return_date is null
        order by rental_date desc limit 1) as ultimo);

#5. Try to delete a film
   	#Check what happens, describe what to do.
   	#Write all the necessary delete statements to entirely remove the film from the DB.

#Buscar film_id (usamos subconsulta como ejemplo)
select film_id from film where title = 'CRAFT OUTFIELD';

#Eliminar pagos relacionados a rentas de ese film
delete from payment
where rental_id in (select rental_id from rental
    where inventory_id in (select inventory_id from inventory
        where film_id = (select film_id from film where title = 'CRAFT OUTFIELD')));

#Eliminar rentals de ese film
delete from rental
where inventory_id in (select inventory_id from inventory
    where film_id = (select film_id from film where title = 'CRAFT OUTFIELD'));

#Eliminar copias de inventario
delete from inventory
where film_id = (select film_id from film where title = 'CRAFT OUTFIELD');

#Eliminar relaciones actor-film
delete from film_actor
where film_id = (select film_id from film where title = 'CRAFT OUTFIELD');

#Eliminar relaciones categoría-film
delete from film_category
where film_id = (select film_id from film where title = 'CRAFT OUTFIELD');

#Finalmente eliminar el film
delete from film
where title = 'CRAFT OUTFIELD';

#6. Rent a film
   	#Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
   	#Add a rental entry
   	#Add a payment entry
   	#Use sub-queries for everything, except for the inventory id that can be used directly in the queries.

#Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
select i.inventory_id from inventory i
left join rental r on i.inventory_id = r.inventory_id and r.return_date is null
where r.rental_id is null limit 1;

#Add a rental entry
insert into rental (rental_date, inventory_id, customer_id, staff_id)
values (now(), 777, 
(select customer_id from customer order by customer_id desc limit 1),
(select staff_id from staff
        where store_id = (select store_id from inventory where inventory_id = 777)limit 1));

#Add a payment entry
insert into payment (customer_id, staff_id, rental_id, amount, payment_date)
values (
(select customer_id from customer order by customer_id desc limit 1),
(select staff_id from staff 
where store_id = (select store_id from inventory i join store s on i.store_id = s.store_id where i.inventory_id = 777)limit 1),
(select rental_id from rental where inventory_id = 777 order by rental_date desc limit 1), 7.99, now());

