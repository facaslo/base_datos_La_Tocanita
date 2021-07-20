-- Consultar los dias en los que el furgon con placa PTM-264 realiza entregas
SELECT crg_fecha FROM cargamento WHERE LOWER(crg_placaFurgon) LIKE '%TM%';
-- Consultar los trabajadores que estuvieron trabajando el dia 16 de octubre
SELECT tra_nombre,tra_id FROM trabajador NATURAL JOIN produccion_trabajador_daily WHERE cdp_fecha="2020-10-16";
-- Consultar las fechas de las ventas que han sido canceladas , el documento del cliente que la cancelo, su nombre y telefono
SELECT vnt_fecha,cli_id,cli_nombre,cli_telefono FROM venta NATURAL JOIN cliente WHERE LOWER(vnt_estado) LIKE "%ance%";
-- Los clientes que han comprado mas de 490 unidades de cualquier producto
SELECT * FROM (venta NATURAL JOIN cliente) NATURAL JOIN venta_productos WHERE vpn_cantidad>490;
-- en que fecha se uso papa y cuanto se uso en ese dia de produccion
SELECT cdp_fecha,SUM(ipd_cantidadinsumo) FROM (compra NATURAL JOIN compra_insumos) JOIN produccion_insumos_daily ON com_fecha=cdp_fecha WHERE produccion_insumos_daily.ins_codigo = 1 AND compra_insumos.ins_codigo=1 GROUP BY cdp_fecha;
-- Productos que se tienen en bodega actualmente
SELECT prd_nombre,prd_cantidad FROM producto;
-- Dia y la cantidad de ventas que se hicieron
SELECT vnt_fecha,COUNT(crg_id) FROM venta GROUP BY vnt_fecha;
-- Seleccionar los clientes que han hecho mas de 4 compras
SELECT cli_id,cli_nombre,cli_telefono,cli_correo FROM venta NATURAL JOIN cliente GROUP BY cli_id HAVING count(vnt_id)>4;
-- Numero de trabajadores de la empresa
SELECT count(tra_id) FROM trabajador;
-- Promedio de produccion por dia 
SELECT cdp_fecha , AVG(rpd_cantidadProducida) FROM resultado_produccion_daily GROUP BY cdp_fecha;

