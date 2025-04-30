USE sakila;
#Find the films with less duration, show the title and rating.
#Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
#Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
#Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.

#1
select title, rating ,length from film 
 where length <= all (select length from film);
#2
select title from film 
 where length = (select MIN(length) from film) 
 and (select COUNT(*) from film 
 where length = (select MIN(length) from film)) = 1;
#3
	#min
		select c.customer_id, c.first_name, c.last_name, a.address, min(p.amount) as pago minimo from customer c
		join address a on c.address_id = a.address_id
		join payment p on c.customer_id = p.customer_id
		group by c.customer_id, c.first_name, c.last_name, a.address;
	#all
		select distinct c.customer_id, c.first_name, c.last_name, a.address, p.amount from customer c
		join address a on c.address_id = a.address_id
		join payment p on c.customer_id = p.customer_id
		where p.amount <= all (select amount from payment where customer_id = c.customer_id);
#4
select c.customer_id, c.first_name, c.last_name, a.address,
	(select p1.amount from payment p1 
    where p1.customer_id = c.customer_id and p1.amount <= all (select amount from payment where customer_id = c.customer_id) limit 1) as pago_minimo,
    (select p2.amount from payment p2 
    where p2.customer_id = c.customer_id and p2.amount >= all (select amount from payment where customer_id = c.customer_id)limit 1) as pago_maximo
from customer c join address a on c.address_id = a.address_id;






