ALTER TABLE producto DROP COLUMN prd_peso;
-- Información de compra de insumos y los proveedores corresponientes
DROP VIEW IF EXISTS vw_info_compra_insumos;
CREATE VIEW vw_info_compra_insumos AS 
SELECT prv_nit,prv_nombre,com_idrecibo,com_fecha, ins_codigo, ins_nombre, cin_costototal,cin_cantidad
FROM (compra NATURAL JOIN compra_insumos) NATURAL JOIN proveedor NATURAL JOIN insumo;
-- Información de la nomina de los trabajadores, junto a su información básica
DROP VIEW IF EXISTS vw_info_nomina;
CREATE VIEW vw_info_nomina AS 
SELECT tra_id,tra_nombre,nom_fecha,nom_periodo,nom_descuentos,nom_valorPago 
FROM trabajador NATURAL JOIN nomina;
-- Información de la venta y los clientes correspondientes
DROP VIEW IF EXISTS vw_info_venta;
CREATE VIEW vw_info_venta AS 
SELECT vnt_id,cli_id,vnt_direccion, geo_nombre,vnt_fecha,vnt_estado,prd_id, prd_nombre,vpn_cantidad,vpn_valorVenta 
FROM (cliente NATURAL JOIN venta) NATURAL JOIN venta_productos NATURAL JOIN geografia NATURAL JOIN producto;
-- Información de la produccion en un día
DROP VIEW IF EXISTS vw_info_produccion;
CREATE VIEW vw_info_produccion AS 
SELECT cdp_fecha,cdp_costoProduccion,prd_id,prd_cantidadProducida,prd_nombre
FROM (produccion NATURAL JOIN producto) NATURAL JOIN resultado_produccion_daily;
-- Cargo de cada uno de los trabajadores
DROP VIEW IF EXISTS vw_info_cargo_trabajador;
CREATE VIEW vw_info_cargo_trabajador 
AS SELECT * 
FROM cargo NATURAL JOIN trabajador WHERE cargo.car_id = trabajador.car_id;
-- Informacion del trabajador en una fecha de produccion para cierto producto
DROP VIEW IF EXISTS vw_info_produccion_trabajador;
CREATE VIEW vw_info_produccion_trabajador AS 
SELECT cdp_fecha , prd_id , prd_nombre, prd_cantidadProducida, tra_id, tra_nombre 
FROM (resultado_produccion_daily NATURAL JOIN produccion_trabajador_daily) NATURAL JOIN trabajador NATURAL JOIN producto;

-- Informacion del numero de compras que ha hecho un cliente
DROP VIEW IF EXISTS vw_info_cliente_numeroCompras;
CREATE VIEW vw_info_cliente_numeroCompras AS
SELECT cli_id,cli_nombre,cli_telefono,cli_correo, COUNT(cli_id) AS totalCompras
FROM venta NATURAL JOIN cliente 
GROUP BY cli_id;

-- Informacion de la produccion promedio porproducto
-- vw_info_produccion_promedio
