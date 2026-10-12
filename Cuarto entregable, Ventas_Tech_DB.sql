
-- PRE-ENTREGA MÓDULO 4
-- Trabajamos solo con la tabla Ventas

-- Consulta 1: Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes.

SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- Consulta 2: Ranking de productos
-- Top 5 de id_producto por total facturado, mostrando unidades vendidas y total.

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;


-- Consulta 3: Clientes recurrentes
-- id_cliente que hayan realizado más de un pedido (cantidad y total gastado).

SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;


-- Consulta 4: Meses por encima/por debajo del promedio
-- Total facturado por mes etiquetado respecto al promedio mensual general.
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE 
        WHEN SUM(cantidad * precio_unitario) > (
            SELECT SUM(cantidad * precio_unitario) / COUNT(DISTINCT MONTH(fecha_venta)) 
            FROM ventas
        ) THEN 'Por encima'
        WHEN SUM(cantidad * precio_unitario) < (
            SELECT SUM(cantidad * precio_unitario) / COUNT(DISTINCT MONTH(fecha_venta)) 
            FROM ventas
        ) THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS rendimiento_mensual
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- Análisis y comentarios 

-- Fuerte concentración temporal. Revisando la Consulta 1 y 4, observamos que el 100% de las ventas registradas hasta ahora ocurrieron en el mes 3 (Marzo). 
-- Esto hace que el total facturado del mes coincida exactamente con el promedio mensual global.

-- Según la Consulta 2 (Ranking), el producto con el ID 1 
-- (Laptop Pro 15) es el líder absoluto en facturación, generando $3,600. 
-- Esto representa una porción altísima de los ingresos totales de la tienda con tan solo 3 unidades vendidas.

-- Alta retención de clientes: Según la Consulta 3, los 5 clientes registrados en la base de datos son recurrentes. 
-- Todos tienen exactamente 2 pedidos realizados, lo cual indica cierta fidelización. 