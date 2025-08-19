use sakila;

drop table if exists employee;

create table employee (
    employeeNumber int primary key auto_increment,
    firstName varchar(50) not null,
    lastName varchar(50) not null,
    email varchar(100) not null unique,
    jobTitle varchar(50) not null,
    hireDate date not null
);

-- Insert sample data
insert into employee (firstName, lastName, email, jobTitle, hireDate)
values ('John','Doe','jdoe@email.com','Manager','2020-01-01'),
       ('Jane','Smith','jsmith@email.com','Sales Rep','2021-05-10');

-- 1. Insert a new employee with null email (va a fallar porque email es NOT NULL)
insert into employee (firstName, lastName, email, jobTitle, hireDate)
values ('Mark','Null','', 'Clerk', '2022-03-15');
-- Explicación: No se puede porque email está definido como NOT NULL y UNIQUE.

-- 2- Run the first the query
update employee set employeeNumber = employeeNumber - 20;
-- What did happen? Explain. Then run this other
-- Explicación: Falla porque se rompe la PK, pueden quedar duplicados o valores negativos.

update employee set employeeNumber = employeeNumber + 20;
-- Explain this case also.
-- Explicación: Aumenta todos los IDs, no hay conflicto porque sigue siendo único.

-- 3. Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
alter table employee add column age int check (age between 16 and 70);

-- 4. Describe the referential integrity between tables film, actor and film_actor in sakila db.
-- film_actor.film_id -> film.film_id (FK)
-- film_actor.actor_id -> actor.actor_id (FK)
-- Esto asegura que no se pueda insertar una relación si no existe film o actor.

-- 5. Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. 
-- Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row 
-- (assume multiple users, other than root, can connect to MySQL and change this table).
alter table employee add column lastUpdate datetime;
alter table employee add column lastUpdateUser varchar(100);

delimiter //
create trigger employee_before_insert
before insert on employee
for each row
begin
    set new.lastUpdate = now();
    set new.lastUpdateUser = user();
end;
//
create trigger employee_before_update
before update on employee
for each row
begin
    set new.lastUpdate = now();
    set new.lastUpdateUser = user();
end;
//
delimiter ;

-- 6. Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.
SHOW TRIGGERS LIKE '%film_text%';
-- Explicación:
-- hay triggers que mantienen sincronizada la tabla film_text con film (para búsquedas fulltext).
-- Cada vez que se inserta/actualiza/elimina un film, los triggers aseguran que film_text se actualice en paralelo.
