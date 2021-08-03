create table historia(
his_id int primary key auto_increment,
his_fecha datetime,
his_cuenta varchar (50),
his_tabla varchar (50),
his_acción varchar (15) check ( his_acción in
('Insercion','Borrado','Actualización'))
);

DELIMITER &&
CREATE TRIGGER tr_his_car_up AFTER UPDATE ON cargamento
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'cargamento','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_car_del AFTER DELETE ON cargamento
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'cargamento','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_car_in BEFORE INSERT ON cargamento
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'cargamento','Insercion');
END; 
&&
DELIMITER ;
-- /////////////////
DELIMITER &&
CREATE TRIGGER tr_his_cargo_up AFTER UPDATE ON cargo
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'cargo','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_cargo_del AFTER DELETE ON cargo
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'cargo','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_cargo_in BEFORE INSERT ON cargo
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'cargo','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_cliente_up AFTER UPDATE ON cliente
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'cliente','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_cliente_del AFTER DELETE ON cliente
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'cliente','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_cliente_in BEFORE INSERT ON cliente
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'cliente','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_colaventas_up AFTER UPDATE ON colaventas
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'colaventas','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_colaventas_del AFTER DELETE ON colaventas
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'colaventas','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_colaventas_in BEFORE INSERT ON colaventas
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'colaventas','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_compra_up AFTER UPDATE ON compra
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'compra','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_compra_del AFTER DELETE ON compra
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'compra','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_compra_in BEFORE INSERT ON compra
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'compra','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_compra_insumos_up AFTER UPDATE ON compra_insumos
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'compra_insumos','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_compra_insumos_del AFTER DELETE ON compra_insumos
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'compra_insumos','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_compra_insumos_in BEFORE INSERT ON compra_insumos
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'compra_insumos','Insercion');
END; 
&&
DELIMITER ;
-- //////////

DELIMITER &&
CREATE TRIGGER tr_his_geografia_up AFTER UPDATE ON geografia
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'geografia','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_geografia_del AFTER DELETE ON geografia
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'geografia','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_geografia_in BEFORE INSERT ON geografia
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'geografia','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_insumo_up AFTER UPDATE ON insumo
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'insumo','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_insumo_del AFTER DELETE ON insumo
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'insumo','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_insumo_in BEFORE INSERT ON insumo
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'insumo','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_nomina_up AFTER UPDATE ON nomina
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'nomina','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_nomina_del AFTER DELETE ON nomina
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'nomina','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_nomina_in BEFORE INSERT ON nomina
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'nomina','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_produccion_up AFTER UPDATE ON produccion
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'produccion','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_produccion_del AFTER DELETE ON produccion
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'produccion','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_produccion_in BEFORE INSERT ON produccion
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'produccion','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_produccion_insumos_daily_up AFTER UPDATE ON produccion_insumos_daily
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'produccion_insumos_daily','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_produccion_insumos_daily_del AFTER DELETE ON produccion_insumos_daily
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'produccion_insumos_daily','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_produccion_insumos_daily_in BEFORE INSERT ON produccion_insumos_daily
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'produccion_insumos_daily','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_produccion_trabajador_daily_up AFTER UPDATE ON produccion_trabajador_daily
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'produccion_trabajador_daily','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_produccion_trabajador_daily_del AFTER DELETE ON produccion_trabajador_daily
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'produccion_trabajador_daily','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_produccion_trabajador_daily_in BEFORE INSERT ON produccion_trabajador_daily
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'produccion_trabajador_daily','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_producto_up AFTER UPDATE ON producto
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'producto','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_producto_del AFTER DELETE ON producto
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'producto','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_producto_in BEFORE INSERT ON producto
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'producto','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_proveedor_up AFTER UPDATE ON proveedor
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'proveedor','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_proveedor_del AFTER DELETE ON proveedor
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'proveedor','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_proveedor_in BEFORE INSERT ON proveedor
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'proveedor','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_resultado_produccion_daily_up AFTER UPDATE ON resultado_produccion_daily
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'resultado_produccion_daily','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_resultado_produccion_daily_del AFTER DELETE ON resultado_produccion_daily
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'resultado_produccion_daily','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_resultado_produccion_daily_in BEFORE INSERT ON resultado_produccion_daily
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'resultado_produccion_daily','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_trabajador_up AFTER UPDATE ON trabajador
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'trabajador','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_trabajador_del AFTER DELETE ON trabajador
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'trabajador','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_trabajador_in BEFORE INSERT ON trabajador
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'trabajador','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_venta_up AFTER UPDATE ON venta
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'venta','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_venta_del AFTER DELETE ON venta
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'venta','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_venta_in BEFORE INSERT ON venta
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'venta','Insercion');
END; 
&&
DELIMITER ;
-- //////////
DELIMITER &&
CREATE TRIGGER tr_his_venta_productos_up AFTER UPDATE ON venta_productos
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'venta_productos','Actualización');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_venta_productos_del AFTER DELETE ON venta_productos
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'venta_productos','Borrado');
END; 
&&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER tr_his_venta_productos_in BEFORE INSERT ON venta_productos
FOR EACH ROW BEGIN
INSERT INTO historia (his_fecha,his_cuenta,his_tabla,his_acción) values (now(),user(),'venta_productos','Insercion');
END; 
&&
DELIMITER ;
-- //////////


