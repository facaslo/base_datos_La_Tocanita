DROP TRIGGER IF EXISTS venta_new; 
DROP TRIGGER IF EXISTS venta_post; 
DROP TRIGGER IF EXISTS duplicados_cl;
DROP TRIGGER IF EXISTS actualizar_colaventas;
DROP TRIGGER IF EXISTS elim_cl;
DROP TRIGGER IF EXISTS elim_vnt;
DROP TRIGGER IF EXISTS elim_vnt_post;
DROP TRIGGER IF EXISTS elim_prove;
DROP TRIGGER IF EXISTS elim_compra;
DROP TRIGGER IF EXISTS insum_act;
DROP TRIGGER IF EXISTS insum_act_mas;
DROP TRIGGER IF EXISTS elim_trabajador;
DROP TRIGGER IF EXISTS elim_producto;
DROP TRIGGER IF EXISTS elim_produccion;

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

-- NUEVA VENTA ---- Actualizacion de la tabla colaventas y venta_productos
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

CREATE TRIGGER elim_vnt_post
AFTER DELETE ON venta
FOR EACH ROW
BEGIN
DELETE FROM colaventas WHERE vnt_id = OLD.vnt_id;
END;
$$

-- BORRAR PORVEEDOR
CREATE TRIGGER elim_prove
AFTER DELETE ON proveedor
FOR EACH ROW
BEGIN
DELETE FROM compra WHERE prv_nit = OLD.prv_nit;
END;
$$

-- Borrar compra
CREATE TRIGGER elim_compra
BEFORE DELETE ON compra
FOR EACH ROW
BEGIN
DELETE FROM compra_insumos WHERE com_idrecibo = old.com_idrecibo;
END;
$$

-- Actualizar tabla insumo cuando se borra una produccion diaria

CREATE TRIGGER insum_act
AFTER DELETE ON produccion_insumos_daily
FOR EACH ROW
BEGIN
DECLARE resta INT DEFAULT 0;
SET resta = old.ipd_cantidadinsumo;
UPDATE insumo SET ins_cantidad = ins_cantidad - resta WHERE ins_codigo = old.ins_codigo;
END;
$$

-- Actualizar tabla insumo cuando se INSERTE una produccion diaria
CREATE TRIGGER insum_act_mas
AFTER INSERT ON produccion_insumos_daily
FOR EACH ROW
BEGIN
DECLARE suma INT DEFAULT 0;
SET suma = new.ipd_cantidadinsumo;
UPDATE insumo SET ins_cantidad = ins_cantidad + suma WHERE ins_codigo = new.ins_codigo;
END;
$$

-- Eliminar trabajador
CREATE TRIGGER elim_trabajador
BEFORE DELETE ON trabajador
FOR EACH ROW
BEGIN
DELETE FROM nomina WHERE tra_id = old.tra_id;
DELETE FROM produccion_trabajador_daily WHERE tra_id = old.tra_id;
END;
$$

-- Borrar registro de la tabla producto
CREATE TRIGGER elim_producto
BEFORE DELETE ON producto
FOR EACH ROW
BEGIN
DELETE FROM resultado_produccion_daily WHERE prd_id = old.prd_id;
DELETE FROM produccion_insumos_daily WHERE prd_id = old.prd_id;
DELETE FROM venta_productos WHERE vpn_id = old.prd_id;
END;
$$

-- Borrar registro de la tabla produccion
CREATE TRIGGER elim_produccion
BEFORE DELETE ON produccion
FOR EACH ROW
BEGIN
DELETE FROM produccion_trabajador_daily WHERE cdp_fecha = old.cdp_fecha;
DELETE FROM produccion_insumos_daily WHERE cdp_fecha = old.cdp_fecha;
DELETE FROM resultado_produccion_daily WHERE cdp_fecha = old.cdp_fecha;
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS agregar_prod;
DELIMITER $$
CREATE TRIGGER agregar_prod
AFTER INSERT ON produccion
FOR EACH ROW
BEGIN
INSERT INTO produccion_insumos_daily VALUES (new.cdp_fecha,@idInsumo,@pr_nit,@cantInsumo);
INSERT INTO resultado_produccion_daily VALUES (new.cdp_fecha,@pr_nit,@cantprod);
INSERT INTO produccion_trabajador_daily VALUES (new.cdp_fecha,@traID);
INSERT INTO produccion_trabajador_daily VALUES (new.cdp_fecha,@traide);
END;
$$