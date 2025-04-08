use sakila;

#1
select first_name, last_name from actor
where last_name in(select last_name from actor group by last_name having count(*)>1)
order by last_name, first_name;

#2
select actor_id, first_name, last_name from actor
where actor_id not in (select actor_id from film_actor where film_id is not null);

#3
select customer_id, first_name, last_name  from customer
where customer_id in (select customer_id from rental group by customer_id having count(*) =1);

#4
select customer_id, first_name, last_name from customer
where customer_id in (select customer_id from rental group by customer_id having count(*) > 1);

#5
select actor.actor_id, actor.first_name, actor.last_name from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
where film_id in (select film_id from film where title like "BETRAYED REAR" or title like "CATCH AMISTAD")
group by actor_id
order by actor_id;

#6
select actor.actor_id, actor.first_name, actor.last_name from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
where film_id in (select film_id from film where title like "BETRAYED REAR")
and actor.actor_id not in (select actor_id from film_actor where film_id in (select film_id from film where title like 'CATCH AMISTAD'))
group by actor.actor_id
order by actor.actor_id;

#7
select actor.actor_id, actor.first_name, actor.last_name from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
where film_id in (select film_id from film where title like 'BETRAYED REAR')
and actor.actor_id in (select actor_id from film_actor where film_id in (select film_id from film where title like 'CATCH AMISTAD'))
group by actor.actor_id
order by actor.actor_id;

#8
select actor.actor_id, actor.first_name, actor.last_name from actor
where actor.actor_id not in (select actor_id from film_actor where film_id in (select film_id from film where title like 'BETRAYED REAR' or title like 'CATCH AMISTAD'))
order by actor.actor_id;