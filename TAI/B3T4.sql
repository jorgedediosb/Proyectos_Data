-- 1. Tabla provincias
CREATE TABLE provincias (
    codpro CHAR(3) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Insertando datos de ejemplo en provincias
INSERT INTO provincias VALUES ('001', 'Madrid'), ('002', 'Barcelona'), ('003', 'Valencia');

-- 2. Tabla pueblos
CREATE TABLE pueblos (
    codpue CHAR(5) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    codpro CHAR(3) NOT NULL,
    FOREIGN KEY (codpro) REFERENCES provincias(codpro)
);

-- Insertando datos de ejemplo en pueblos
INSERT INTO pueblos VALUES ('00101', 'Alcobendas', '001'), ('00201', 'Sabadell', '002'), ('00301', 'Gandia', '003');

-- 3. Tabla clientes
CREATE TABLE clientes (
    codcli CHAR(6) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    codpostal CHAR(5) NOT NULL,
    codpue CHAR(5) NOT NULL,
    FOREIGN KEY (codpue) REFERENCES pueblos(codpue)
);

-- Insertando datos de ejemplo en clientes
INSERT INTO clientes VALUES 
('CL001', 'Juan Perez', 'Calle Mayor, 1', '28001', '00101'),
('CL002', 'Maria Garcia', 'Av. Central, 23', '08201', '00201');

-- 4. Tabla vendedores
CREATE TABLE vendedores (
    codven CHAR(6) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150),
    codpostal CHAR(5),
    codpue CHAR(5),
    codjefe CHAR(6),
    FOREIGN KEY (codpue) REFERENCES pueblos(codpue),
    FOREIGN KEY (codjefe) REFERENCES vendedores(codven) -- auto-referencia para jefe
);

-- Insertando datos de ejemplo en vendedores
INSERT INTO vendedores VALUES 
('VEN001', 'Carlos Lopez', 'Calle Sol, 2', '28001', '00101', NULL),
('VEN002', 'Ana Martinez', 'Av. Sur, 44', '08201', '00201', 'VEN001');

-- 5. Tabla artículos
CREATE TABLE articulos (
    codart CHAR(5) PRIMARY KEY,
    descrip VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    stock_min INT NOT NULL
);

-- Insertando datos de ejemplo en artículos
INSERT INTO articulos VALUES 
('A0001', 'Producto A', 50.00, 100, 10),
('A0002', 'Producto B', 30.00, 50, 5);

-- 6. Tabla facturas
CREATE TABLE facturas (
    codfac CHAR(6) PRIMARY KEY,
    fecha DATE NOT NULL,
    codcli CHAR(6) NOT NULL,
    codven CHAR(6) NOT NULL,
    iva DECIMAL(5, 2) NOT NULL,
    dto DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (codcli) REFERENCES clientes(codcli),
    FOREIGN KEY (codven) REFERENCES vendedores(codven)
);

-- Insertando datos de ejemplo en facturas
INSERT INTO facturas VALUES 
('FAC001', '2024-10-01', 'CL001', 'VEN001', 21.00, 5.00),
('FAC002', '2024-10-02', 'CL002', 'VEN002', 21.00, 10.00);

-- 7. Tabla líneas de factura
CREATE TABLE lineas_fac (
    codfac CHAR(6),
    linea INT,
    cant INT NOT NULL,
    codart CHAR(5) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    dto DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY (codfac, linea),
    FOREIGN KEY (codfac) REFERENCES facturas(codfac),
    FOREIGN KEY (codart) REFERENCES articulos(codart)
);

-- Insertando datos de ejemplo en líneas de factura
INSERT INTO lineas_fac VALUES 
('FAC001', 1, 2, 'A0001', 50.00, 5.00),
('FAC001', 2, 1, 'A0002', 30.00, 0.00),
('FAC002', 1, 3, 'A0001', 50.00, 10.00);
