DROP DATABASE IF EXISTS imdb;
CREATE database IF NOT EXISTS imdb;
use imdb;
DROP TABLE IF EXISTS film_actor;
DROP TABLE IF EXISTS film;
DROP TABLE IF EXISTS actor;

create table film(
	film_id int auto_increment,
    title varchar(70),
    description varchar(200),
    release_year year,
    primary key (film_id)
);

create table actor(
	actor_id int auto_increment,
    first_name varchar(70),
    last_name varchar(200),
    primary key (actor_id)
);

create table film_actor(
	actor_id int,
    film_id int,
    primary key (actor_id,  film_id)
);

alter table film add column last_update timestamp default current_timestamp on update current_timestamp;
alter table actor add column last_update timestamp default current_timestamp on update current_timestamp;

alter table film_actor
add constraint fk_film_actor_actor
foreign key (actor_id) references actor(actor_id)
on delete cascade;

alter table film_actor
add constraint fk_film_actor_film
foreign key (film_id) references film(film_id)
on delete cascade;



insert into actor (first_name, last_name) values ('leonardo', 'dicaprio');
insert into actor (first_name, last_name) values ('tom', 'holland');
insert into actor (first_name, last_name) values ('scarlett', 'johansson');

insert into film (title, description, release_year) values ('inception', 'a mind-bending thriller', 2010);
insert into film (title, description, release_year) values ('titanic', 'a romantic tragedy aboard the rms titanic', 1997);
insert into film (title, description, release_year) values ('avengers: endgame', 'the final battle against thanos', 2019);
insert into film (title, description, release_year) values ('spider-man: no way home', 'peter parker faces multiverse chaos', 2021);

insert into film_actor (actor_id, film_id) values (1, 1);
insert into film_actor (actor_id, film_id) values (1, 2);
insert into film_actor (actor_id, film_id) values (2, 4);
insert into film_actor (actor_id, film_id) values (2, 3);
insert into film_actor (actor_id, film_id) values (3, 3);

