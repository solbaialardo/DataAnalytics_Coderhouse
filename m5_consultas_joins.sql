
-- Entregable M5: Consultas con JOINs
-- Proyecto: Ventas_Tech_DB

-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: Consolidar todas las dimensiones del negocio (clientes, territorios, productos y categorías) 
-- con los hechos de ventas para alimentar el futuro dashboard en Power BI.

SELECT 
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN territorios t ON c.id_territorio = t.id_territorio
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

-- Hallazgo: Se generó una tabla plana perfecta para BI, donde se observa por ejemplo que "María López" 
-- (Segmento B2C, Región Centro) es quien compró el producto de mayor valor (Laptop Pro 15).


-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: Detectar clientes registrados en la base de datos que aún no han realizado ninguna compra 
-- para enviarles una campaña de activación desde CRM.

SELECT 
    c.nombre, 
    c.email, 
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: 0 clientes de los 5 registrados están sin compras. La tasa de activación es del 100%, 
-- por lo que CRM no necesita lanzar campañas de primera compra por el momento.


-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: Identificar artículos del catálogo que no tienen movimiento en el historial de ventas 
-- para que el área de producto evalúe promociones o discontinuación.

SELECT 
    p.nombre_producto, 
    cat.nombre_categoria, 
    p.precio
FROM productos p
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: 0 productos del catálogo aparecen sin ventas. Los 6 artículos de nuestro inventario 
-- tienen rotación comprobada; no hay stock "muerto" que requiera liquidación urgente.


-- Consulta 4: Consolidado por canal (UNION ALL)
-- Propósito: Comparar el rendimiento total (facturación) separando las ventas digitales de las presenciales,
-- creando la dimensión de origen al vuelo mediante literales de texto.

SELECT 
    origen_venta, 
    SUM(total) AS total_origen
FROM (
    SELECT 
        fecha_venta, 
        total_venta AS total, 
        'Plataforma Web' AS origen_venta
    FROM ventas 
    WHERE canal_venta = 'Online'
    
    UNION ALL
    
    SELECT 
        fecha_venta, 
        total_venta AS total, 
        'Tienda Física' AS origen_venta
    FROM ventas 
    WHERE canal_venta = 'Presencial'
) AS consolidado
GROUP BY origen_venta;

-- Hallazgo: El canal "Plataforma Web" domina ampliamente la facturación ($5.310), 
-- frente a "Tienda Física" que representa un ingreso significativamente menor ($754).
