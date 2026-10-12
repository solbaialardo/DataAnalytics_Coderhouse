CREATE DATABASE Ventas_Tech_DB;

USE Ventas_Tech_DB;

-- DROP TABLES 
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS compras;
DROP TABLE IF EXISTS inventario;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS territorios;
DROP TABLE IF EXISTS categorias;


-- CREATE TABLES
-- Tabla agregada a mi esquema
CREATE TABLE territorios (
    id_territorio VARCHAR(10) PRIMARY KEY,
    pais VARCHAR(50),
    region VARCHAR(50),
    zona VARCHAR(50)
);

-- Tabla del modelo oficial
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);

-- Tabla del modelo ofical pero modificada para mi esquema
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL,
    segmento VARCHAR(50),
    id_territorio VARCHAR(10),
    FOREIGN KEY (id_territorio) REFERENCES territorios(id_territorio)
);

-- Tabla del modelo ofical pero modificada para mi esquema
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo TINYINT DEFAULT 1,
    subcategoria VARCHAR(50),
    costo_unitario DECIMAL(10,2),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Tabla del modelo ofical pero modificada para mi esquema
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    total_venta DECIMAL(10,2),
    canal_venta VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Tabla agregada a mi esquema
CREATE TABLE compras (
    id_compras INT PRIMARY KEY,
    id_producto INT,
    fecha_orden DATE NOT NULL,
    fecha_ingreso DATE,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Tabla agregada a mi esquema
CREATE TABLE inventario (
    id_registro INT PRIMARY KEY,
    id_producto INT,
    fecha_corte DATE NOT NULL,
    cantidad_stock INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- INSERT DATA 
-- Datos inventados para mi modelo
INSERT INTO territorios VALUES ('T01', 'Argentina', 'Norte', 'NOA');
INSERT INTO territorios VALUES ('T02', 'Argentina', 'Centro', 'CABA');

-- Datos dados en el curso
INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

INSERT INTO clientes VALUES (1, 'María López', 'maria@mail.com', 'Buenos Aires', '2024-01-05', 'B2C', 'T02');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz', 'carlos@mail.com', 'Córdoba', '2024-01-10', 'B2B', 'T02');
INSERT INTO clientes VALUES (3, 'Ana Gómez', 'ana@mail.com', 'Rosario', '2024-02-01', 'B2C', 'T02');
INSERT INTO clientes VALUES (4, 'Pedro Sanz', 'pedro@mail.com', 'Mendoza', '2024-02-15', 'B2B', 'T01');
INSERT INTO clientes VALUES (5, 'Laura Torres', 'laura@mail.com', 'Tucumán', '2024-03-01', 'B2C', 'T01');

INSERT INTO productos VALUES (1, 'Laptop Pro 15', 1, 1200.00, 15, 1, 'Laptops', 800.00);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico', 2, 28.00, 80, 1, 'Periféricos', 10.00);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"', 1, 450.00, 12, 1, 'Monitores', 300.00);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro', 3, 120.00, 35, 1, 'Auriculares', 70.00);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB', 4, 130.00, 18, 1, 'Almacenamiento', 80.00);
INSERT INTO productos VALUES (6, 'Teclado Mecánico', 2, 95.00, 40, 1, 'Periféricos', 45.00);

-- Ventas (Cantidad * Precio Unitario = Total Venta)
INSERT INTO ventas VALUES (1, 1, 1, 2, 1200.00, '2024-03-05', 2400.00, 'Online');
INSERT INTO ventas VALUES (2, 2, 2, 5, 28.00, '2024-03-06', 140.00, 'Presencial');
INSERT INTO ventas VALUES (3, 3, 3, 1, 450.00, '2024-03-07', 450.00, 'Online');
INSERT INTO ventas VALUES (4, 1, 4, 2, 120.00, '2024-03-08', 240.00, 'Online');
INSERT INTO ventas VALUES (5, 4, 5, 3, 130.00, '2024-03-10', 390.00, 'Presencial');
INSERT INTO ventas VALUES (6, 2, 6, 4, 95.00, '2024-03-11', 380.00, 'Online');
INSERT INTO ventas VALUES (7, 5, 1, 1, 1200.00, '2024-03-12', 1200.00, 'Online');
INSERT INTO ventas VALUES (8, 3, 2, 8, 28.00, '2024-03-13', 224.00, 'Presencial');
INSERT INTO ventas VALUES (9, 4, 4, 1, 120.00, '2024-03-14', 120.00, 'Online');
INSERT INTO ventas VALUES (10, 5, 3, 2, 450.00, '2024-03-15', 900.00, 'Online');

-- Datos inventados para mi modelo
INSERT INTO compras VALUES (1, 1, '2024-01-01', '2024-01-10', 50);
INSERT INTO compras VALUES (2, 2, '2024-01-05', '2024-01-15', 100);

INSERT INTO inventario VALUES (1, 1, '2024-03-31', 45);
INSERT INTO inventario VALUES (2, 2, '2024-03-31', 90);


