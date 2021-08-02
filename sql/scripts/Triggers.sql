
DROP TRIGGER IF EXISTS venta_new; 
DROP TRIGGER IF EXISTS venta_post; 
DROP TRIGGER IF EXISTS duplicados_cl;
DROP TRIGGER IF EXISTS actualizar_colaventas;
DROP TRIGGER IF EXISTS elim_cl;
DROP TRIGGER IF EXISTS elim_vnt;
-- DROP TRIGGER IF EXISTS act_cola;
DELIMITER $$
-- Agregar venta
CREATE TRIGGER venta_new
BEFORE INSERT ON venta
FOR EACH ROW
BEGIN
INSERT INTO cargamento VALUES (@idFurgon,curdate(),@placaFurgon);
END;
$$

-- NUEVA VENTA ---- Actualizacion de la tabla colaventas, cargamento y venta_productos
CREATE TRIGGER venta_post
AFTER INSERT ON venta
FOR EACH ROW 
BEGIN
INSERT INTO colaventas VALUES (NEW.vnt_id,NEW.crg_id,NEW.vnt_estado);
INSERT INTO venta_productos VALUES (NEW.vnt_id,@nitprod,@cant_vendida,@totalventa);
END;
$$
-- Cuando el conductor actualice en tabla colaventas se actualiza en tabla venta
CREATE TRIGGER actualizar_colaventas
BEFORE UPDATE ON colaventas
FOR EACH ROW
BEGIN
SET @venta_ide = NEW.vnt_id;
UPDATE venta SET vnt_estado = NEW.vnt_estado WHERE vnt_id = @venta_ide;
END;
$$

-- Borrar cliente  borrar de las ventas
CREATE TRIGGER elim_cl
BEFORE DELETE ON cliente
FOR EACH ROW
BEGIN
DELETE FROM venta WHERE cli_id = OLD.cli_id;
END;
$$

-- ELiminar venta
CREATE TRIGGER elim_vnt
BEFORE DELETE ON venta
FOR EACH ROW
BEGIN
DELETE FROM venta_productos WHERE vnt_id = OLD.vnt_id;
END;
$$

DELIMITER ;
