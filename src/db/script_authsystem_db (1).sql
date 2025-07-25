create database auth_system;

use auth_system;

create table persona (
	id_persona varchar(50) primary key not null,
    nombres varchar(50) not null,
    apellidos varchar(50) not null,
    telefono varchar(8)
);

alter table persona add column fecha_creacion datetime default current_timestamp;

create table usuario (
	id_usuario varchar(50) primary key not null,
    email varchar(50) not null,
    contrasenia varchar(25) not null,
    _id_persona varchar(50) not null,
    foreign key (_id_persona) references persona(id_persona)
);

delimiter $$
create procedure sp_agregar_persona(in _nombres varchar(50), in _apellidos varchar(50), in _telefono varchar(8))
begin
	insert into persona (persona.id_persona, persona.nombres, persona.apellidos, persona.telefono)
    values(uuid(), _nombres, _apellidos, _telefono);
end$$

delimiter ;

call sp_agregar_persona('Brana', 'Mejía', '22160000');
select * from persona;

delimiter $$
create procedure sp_agregar_usuario(in _email varchar(50), in _contrasenia varchar(50), in _id_persona varchar(50))
begin
	insert into usuario (usuario.id_usuario, usuario.email, usuario.contrasenia, usuario._id_persona)
    values (uuid(), _email, _contrasenia, _id_persona);
end$$
delimiter ;


select * from usuario;

delimiter $$
create procedure sp_buscar_usuario (in _email varchar(50), in _contrasenia varchar(50))
begin
	select * from usuario where usuario.email = _email and usuario.contrasenia = _contrasenia;
end$$
delimiter ;

call sp_buscar_usuario('jbmontufar85@gmail.com','Kinal2025');

delimiter $$
create procedure sp_buscar_persona(out _id_persona varchar(50))
begin
	select persona.id_persona 
    into _id_persona
    from persona
    order by fecha_creacion desc limit 1;
end$$

delimiter ;
call sp_buscar_persona(@ultimo_id);
call sp_agregar_usuario('braulio@gmail.com', 'Kinal2025', @ultimo_id);


DELIMITER $$

CREATE PROCEDURE sp_validar_usuario(
    IN _email VARCHAR(50),
    IN _contrasenia VARCHAR(50)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuario WHERE email = _email) THEN
        SELECT 'NO_EMAIL' AS resultado;
    ELSEIF NOT EXISTS (SELECT 1 FROM usuario WHERE email = _email AND contrasenia = _contrasenia) THEN
        SELECT 'CONTRASENIA_INCORRECTA' AS resultado;
    ELSE
        SELECT 'OK' AS resultado, email FROM usuario WHERE email = _email;
    END IF;
END$$

DELIMITER ;


