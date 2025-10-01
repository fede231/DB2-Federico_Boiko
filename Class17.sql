use sakila;

#1. Create two or three queries using address table in sakila db:
#   include postal_code in where (try with in/not it operator)
#   eventually join the table with city/country tables.
#   measure execution time.
#   Then create an index for postal_code on address table.
#   measure execution time again and compare with the previous ones.
#   Explain the results

select * from address where postal_code in ('28034', '10011', '33549');

select a.address, a.postal_code, c.city, co.country
from address a
join city c on a.city_id = c.city_id
join country co on c.country_id = co.country_id
where a.postal_code not in ('28034','10011');

# create index
create index idx_postal_code on address(postal_code);

# al crear el indice mysql usa el indice en lugar de recorrer toda la tabla
# entonces las consultas que filtran por postalcode se ejecutan mucho mas rapido
# la diferencia de tiempo se nota bastante en tablas grandes

#2. Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?

select * from actor where first_name = 'NICK';
select * from actor where last_name = 'WAHLBERG';

# cuando se busca por first_name se devuelven muchas filas porque hay mas nombres repetidos
# cuando se busca por last_name los resultados son mas unicos entonces la busqueda es mas rapida
# tambien si hay un indice en last_name la diferencia se nota aun mas

#3. Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.

select title, description from film where description like '%drama%';

select title, description from film_text where match(description) against('drama');

# like recorre toda la tabla y compara caracter por caracter por eso es mas lento
# match again usa un indice fulltext que hace la busqueda mucho mas rapida y eficiente
# ademas permite ranking de relevancia lo que LIKE no hace



