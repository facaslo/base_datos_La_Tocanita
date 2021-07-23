-- crear una cola para el conductor

DROP TABLE IF EXISTS colaventas;
CREATE TABLE colaVentas(
	vnt_id SMALLINT,
    crg_id INT, 
    vnt_estado VARCHAR(15)
);

-- Agregar venta
DROP PROCEDURE IF EXISTS procedimiento_Venta;
DELIMITER $$
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
    INSERT INTO venta_productos VALUES(id_venta, producto, cantidad, valorVenta);
    INSERT INTO colaVentas VALUES(id_venta, null, null);
END
$$
DELIMITER ;