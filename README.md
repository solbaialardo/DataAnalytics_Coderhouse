RetailPro

Proyecto de análisis de ventas de una tienda de tecnología. Incluye el diseño de una base de datos relacional en SQL Server (Ventas_Tech_DB), consultas SQL para análisis comercial y la preparación de los datos para su visualización en PowerBI.

Objetivo

Construir un modelo de datos de ventas, cargarlo con datos de ejemplo y responder preguntas de negocio como:

¿Cuánto se factura por mes y cuál es el ticket promedio?
¿Qué productos generan la mayor parte de los ingresos?
¿Qué clientes y productos no tienen movimiento?
¿Qué canal de venta (online o presencial) aporta más facturación?
Herramientas utilizadas
SQL Server: motor de base de datos (T-SQL).
SQL Server Management Studio (SSMS): edición y ejecución de los scripts.
PowerBI: modelado y visualización de los datos.
GitHub: control de versiones y publicación del proyecto.
Estructura del repositorio
Tercer entregable, Ventas_Tech_DB.sql: crea la base de datos Ventas_Tech_DB, sus 7 tablas y carga los datos de ejemplo.
Cuarto entregable, Ventas_Tech_DB.sql: 4 consultas de análisis sobre la tabla ventas: resumen mensual, ranking de productos, clientes recurrentes y meses vs. promedio.
m5_consultas_joins.sql: 4 consultas con JOIN y UNION ALL: vista base para BI, clientes sin ventas, productos sin ventas y consolidado por canal.
Modelo de datos

La base Ventas_Tech_DB tiene una tabla de hechos (ventas) y tablas de dimensiones relacionadas por claves foráneas:

ventas: transacciones con cliente, producto, cantidad, precio, fecha, total y canal de venta.
clientes: datos del cliente, segmento (B2B / B2C) y territorio.
productos: catálogo con precio, costo unitario, stock y categoría.
categorias: categorías de producto.
territorios: país, región y zona.
compras: órdenes de compra a proveedores (fecha de orden y de ingreso).
inventario: registro de stock por producto y fecha de corte.

Relaciones principales:

territorios ──< clientes ──< ventas >── productos >── categorias
                                          │
                                          ├──< compras
                                          └──< inventario
Datos

Se cargan 5 clientes, 6 productos y 10 ventas realizadas en marzo de 2024. Según su origen:

Datos del curso: categorias, clientes, productos y ventas. Las tablas siguen el modelo oficial, pero les agregué columnas propias (por ejemplo segmento, id_territorio, costo_unitario y canal_venta).
Datos inventados por mí: territorios, compras e inventario. Son tablas que sumé al esquema y que hoy tienen solo 2 registros cada una.
Cómo ejecutar los scripts SQL
Requisitos
SQL Server (cualquier edición, incluida Express).
SQL Server Management Studio (SSMS).
Pasos
Cloná el repositorio o descargá los archivos .sql:
bash
git clone https://github.com/solbaialardo/NOMBRE-DEL-REPO.git
Abrí SSMS y conectate a tu instancia de SQL Server.
Abrí Tercer entregable, Ventas_Tech_DB.sql (Archivo → Abrir → Archivo).
Ejecutá el script completo con F5 (la primera vez). Esto va a crear la base Ventas_Tech_DB, eliminar las tablas si ya existían (DROP TABLE IF EXISTS), crear las 7 tablas con sus claves primarias y foráneas, e insertar los datos de ejemplo.
Verificá la carga ejecutando:
sql
USE Ventas_Tech_DB;
SELECT COUNT(*) AS total_ventas FROM ventas;  -- Debe devolver 10
Ejecutá los demás scripts en este orden: Cuarto entregable y luego m5_consultas_joins.sql.

Importante: ejecutá siempre primero el Tercer entregable, porque los demás scripts dependen de las tablas y datos que este crea.

Si querés volver a ejecutarlo: la instrucción CREATE DATABASE Ventas_Tech_DB; da error si la base ya existe. Antes de re-ejecutar, corré en una ventana nueva:

sql
USE master;
DROP DATABASE IF EXISTS Ventas_Tech_DB;
Consultas destacadas

Clientes sin ventas (LEFT JOIN)

sql
SELECT c.nombre, c.email, c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

Consolidado por canal (UNION ALL)

sql
SELECT origen_venta, SUM(total) AS total_origen
FROM (
    SELECT fecha_venta, total_venta AS total, 'Plataforma Web' AS origen_venta
    FROM ventas WHERE canal_venta = 'Online'
    UNION ALL
    SELECT fecha_venta, total_venta AS total, 'Tienda Física' AS origen_venta
    FROM ventas WHERE canal_venta = 'Presencial'
) AS consolidado
GROUP BY origen_venta;
Hallazgos clave
Facturación total de $6.444 en 10 pedidos, con un ticket promedio de $644,40.
El producto 1 (Laptop Pro 15) concentra el 55,9% de la facturación con solo 3 unidades vendidas.
Los 5 clientes son recurrentes (2 pedidos cada uno) y todos realizaron al menos una compra.
Los 6 productos del catálogo tienen ventas.
El canal online aporta $5.690 (88,3%) frente a $754 (11,7%) de la tienda física.
El 100% de las ventas ocurrió en marzo, por lo que el total del mes coincide con el promedio mensual.

Por ahora no se puede concluir que CRM no necesite campañas de activación ni que no haya productos para liquidar: con solo 10 ventas en un mes, los resultados son orientativos.

Limitaciones
Muestra pequeña: 10 ventas en un único mes (marzo de 2024). No permite analizar estacionalidad ni tendencias.
MONTH() sin YEAR(): las consultas agrupan por número de mes, así que si se cargan datos de más de un año, los meses iguales se sumarían entre sí. Habría que agrupar por año y mes.
Consolidado por canal: el UNION ALL solo contempla los valores 'Online' y 'Presencial'. Una venta con otro canal, o con canal vacío, no aparecería en el resultado.
