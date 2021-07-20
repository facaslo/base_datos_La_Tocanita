
-- Agregar cliente
DROP PROCEDURE IF EXISTS procedimiento_agregarCliente;
DELIMITER $$ 
CREATE PROCEDURE procedimiento_agregarCliente(
	IN id_cliente BIGINT(10),
    IN nombre_cliente VARCHAR(45),
    IN telefono_cliente BIGINT(10),
    IN correo_cliente VARCHAR(60)
    )
BEGIN
	INSERT INTO cliente VALUES (id_cliente, nombre_cliente, telefono_cliente, correo_cliente);
END
$$

-- CALL procedimiento_agregarCliente(12, 'Big chungus', 333333333, 'bigchungus@gmail.com') $$
-- agregar geografia
DROP PROCEDURE IF EXISTS procedimiento_agregarGeografia $$
CREATE PROCEDURE procedimiento_agregarGeografia(
	IN codigo_geografia INT,
	IN nombre_geografia VARCHAR(45)
	)        
BEGIN
	INSERT INTO geografia VALUES (codigo_geografia, nombre_geografia);
END
$$

DROP PROCEDURE IF EXISTS procedimiento_agregarCargamento $$
CREATE PROCEDURE procedimiento_agregarGeografia(
	IN fecha DATE,
	IN placaFurgon VARCHAR(45)
	)        
BEGIN
	INSERT INTO geografia VALUES (codigo_geografia, nombre_geografia);
END
$$

-- crear una cola para el conductor
DROP TABLE IF EXISTS colaventas $$
CREATE TABLE colaVentas(
	vnt_id SMALLINT,
    crg_id INT, 
    vnt_estado VARCHAR(15)
	);
$$

-- Agregar venta
DROP PROCEDURE IF EXISTS procedimiento_Venta $$

CREATE PROCEDURE procedimiento_Venta(
	IN id_venta SMALLINT, 
    IN id_cliente BIGINT,
    IN codigoPostal INT,
    IN direccion VARCHAR(45),
    IN producto TINYINT,
    IN cantidad INT,
    IN valorVenta INT
	)   
BEGIN
	
	INSERT INTO venta VALUES (id_venta, id_cliente, codigoPostal, -1 , direccion, curdate(), 'No entregado');
    INSERT INTO venta_productos (id_venta, producto, cantidad, )
END
$$
