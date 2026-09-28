-- ==============================================================================
-- PROYECTO: ARQUITECTURA DE DATOS TRENDNOVA (E-COMMERCE FAST-FASHION)
-- SCRIPT DE ESTRUCTURA DDL Y CARGA DE DATOS DML (OLTP)
-- ==============================================================================

-- 1. CREACIÓN DE BASE DE DATOS Y ENTORNO
CREATE DATABASE TrendNova_Operacional;
USE TrendNova_Operacional;

-- ==============================================================================
-- 2. CREACIÓN DE TABLAS (DDL) - MÓDULO DE ABASTECIMIENTO Y PRODUCTOS
-- ==============================================================================
CREATE TABLE Proveedor (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_empresa VARCHAR(100) NOT NULL,
    pais_origen VARCHAR(50),
    email_contacto VARCHAR(100),
    calificacion_calidad DECIMAL(3,2)
);

CREATE TABLE Producto (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    id_proveedor INT,
    sku VARCHAR(50) UNIQUE NOT NULL,
    nombre_producto VARCHAR(150) NOT NULL,
    categoria VARCHAR(50),
    precio_venta DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

CREATE TABLE Inventario (
    id_inventario INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    cantidad_disponible INT NOT NULL,
    nivel_reorden INT NOT NULL,
    ubicacion_bodega VARCHAR(50),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Orden_Compra (
    id_oc INT PRIMARY KEY AUTO_INCREMENT,
    id_proveedor INT,
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado_recepcion VARCHAR(50) NOT NULL,
    total_costo DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

-- ==============================================================================
-- 3. CREACIÓN DE TABLAS (DDL) - MÓDULO DE E-COMMERCE Y VENTAS
-- ==============================================================================
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    rut VARCHAR(12) UNIQUE NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    comuna VARCHAR(100)
);

CREATE TABLE Orden_Venta (
    id_orden INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    fecha_orden DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado_orden VARCHAR(50) NOT NULL,
    monto_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Detalle_Orden (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_orden INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_orden) REFERENCES Orden_Venta(id_orden),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Pago (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_orden INT,
    metodo_pago VARCHAR(50) NOT NULL,
    fecha_transaccion DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_orden) REFERENCES Orden_Venta(id_orden)
);

-- ==============================================================================
-- 4. CREACIÓN DE TABLAS (DDL) - MÓDULO LOGÍSTICO (ÚLTIMA MILLA)
-- ==============================================================================
CREATE TABLE Courier (
    id_courier INT PRIMARY KEY AUTO_INCREMENT,
    nombre_empresa VARCHAR(100) NOT NULL,
    tipo_servicio VARCHAR(50),
    sla_dias_promedio INT NOT NULL
);

CREATE TABLE Despacho (
    id_despacho INT PRIMARY KEY AUTO_INCREMENT,
    id_orden INT,
    id_courier INT,
    codigo_tracking VARCHAR(100) UNIQUE,
    fecha_envio DATETIME,
    fecha_entrega_real DATETIME,
    estado_tracking VARCHAR(50),
    FOREIGN KEY (id_orden) REFERENCES Orden_Venta(id_orden),
    FOREIGN KEY (id_courier) REFERENCES Courier(id_courier)
);

-- ==============================================================================
-- 5. CREACIÓN DE TABLAS (DDL) - MÓDULO DE GOBIERNO, MERMAS Y SOPORTE
-- ==============================================================================
CREATE TABLE Auditoria_Inventario (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    fecha_auditoria DATETIME DEFAULT CURRENT_TIMESTAMP,
    cantidad_sistema INT NOT NULL,
    cantidad_fisica INT NOT NULL,
    diferencia INT NOT NULL,
    justificacion VARCHAR(255),
    estado_aprobacion VARCHAR(50),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Ticket_Soporte (
    id_ticket INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_orden INT,
    fecha_apertura DATETIME DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(150) NOT NULL,
    nivel_urgencia INT NOT NULL,
    estado_ticket VARCHAR(50) NOT NULL,
    tiempo_resolucion_minutos INT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_orden) REFERENCES Orden_Venta(id_orden)
);


-- ==============================================================================
-- 6. INYECCIÓN DE DATOS DE MUESTRA (DML - INSERT) PARA AUDITORÍA DEL DOCENTE
-- ==============================================================================

-- Insertar Proveedores
INSERT INTO Proveedor (nombre_empresa, pais_origen, email_contacto, calificacion_calidad) VALUES
('AsiaTextiles Co.', 'China', 'contact@asiatextiles.cn', 4.50),
('Bangla Threads', 'Bangladesh', 'sales@banglathreads.bd', 4.20),
('IndoGarments', 'India', 'export@indogarments.in', 4.80),
('VietStyle', 'Vietnam', 'hello@vietstyle.vn', 4.00),
('LatamFabrics', 'Peru', 'ventas@latamfabrics.pe', 4.90);

-- Insertar Productos (Catálogo)
INSERT INTO Producto (id_proveedor, sku, nombre_producto, categoria, precio_venta) VALUES
(1, 'SKU-001', 'Polera Básica Blanca', 'Vestuario', 9990.00),
(1, 'SKU-002', 'Polera Básica Negra', 'Vestuario', 9990.00),
(2, 'SKU-003', 'Jeans Slim Fit Azul', 'Vestuario', 24990.00),
(2, 'SKU-004', 'Jeans Mom Fit Celeste', 'Vestuario', 24990.00),
(3, 'SKU-005', 'Chaqueta Denim Oversize', 'Vestuario', 35990.00),
(3, 'SKU-006', 'Polerón Hoodie Gris', 'Vestuario', 19990.00),
(4, 'SKU-007', 'Zapatillas Urbanas Blancas', 'Calzado', 29990.00),
(4, 'SKU-008', 'Botines Cuero Sintético', 'Calzado', 39990.00),
(5, 'SKU-009', 'Cinturón Ecocuero Negro', 'Accesorios', 8990.00),
(5, 'SKU-010', 'Gafas de Sol Retro', 'Accesorios', 12990.00);

-- Insertar Inventario (Stock Operativo)
INSERT INTO Inventario (id_producto, cantidad_disponible, nivel_reorden, ubicacion_bodega) VALUES
(1, 150, 50, 'Rack A-1'), (2, 45, 50, 'Rack A-2'),
(3, 80, 30, 'Rack B-1'), (4, 120, 30, 'Rack B-2'),
(5, 15, 20, 'Rack C-1'), (6, 200, 40, 'Rack C-2'),
(7, 60, 25, 'Rack D-1'), (8, 40, 20, 'Rack D-2'),
(9, 300, 50, 'Rack E-1'), (10, 85, 30, 'Rack E-2');

-- Insertar Órdenes de Compra B2B (Abastecimiento)
INSERT INTO Orden_Compra (id_proveedor, fecha_emision, estado_recepcion, total_costo) VALUES
(1, '2026-05-10 10:00:00', 'Recibido', 1500000.00),
(3, '2026-06-01 11:30:00', 'En Tránsito Aduanas', 2800000.00),
(2, '2026-06-15 09:15:00', 'Pendiente de Despacho', 950000.00);

-- Insertar Clientes (Onboarding validado)
INSERT INTO Cliente (rut, nombre_completo, email, comuna) VALUES
('18123456-7', 'Juan Perez', 'juan.perez@email.com', 'Santiago Centro'),
('19234567-8', 'Maria Gonzalez', 'maria.g@email.com', 'Providencia'),
('17345678-9', 'Carlos Soto', 'carlos.soto@email.com', 'Maipu'),
('20456789-0', 'Ana Silva', 'ana.silva@email.com', 'Las Condes'),
('16567890-1', 'Luis Rojas', 'luis.r@email.com', 'La Florida'),
('15678901-2', 'Camila Tapia', 'camila.t@email.com', 'Ñuñoa'),
('14789012-3', 'Diego Morales', 'diego.m@email.com', 'Puente Alto'),
('21890123-4', 'Valentina Castro', 'val.castro@email.com', 'San Miguel'),
('13901234-5', 'Sebastian Vera', 'seba.v@email.com', 'Macul'),
('12012345-6', 'Daniela Muñoz', 'daniela.m@email.com', 'Peñalolen');

-- Insertar Órdenes de Venta (E-Commerce)
INSERT INTO Orden_Venta (id_cliente, fecha_orden, estado_orden, monto_total) VALUES
(1, '2026-06-25 14:30:00', 'Entregada', 29980.00),
(2, '2026-06-26 10:15:00', 'En Ruta', 24990.00),
(3, '2026-06-26 16:45:00', 'En Bodega', 35990.00),
(4, '2026-06-27 09:00:00', 'Pendiente', 59980.00),
(5, '2026-06-27 11:20:00', 'Devuelta', 19990.00),
(6, '2026-06-27 18:10:00', 'Entregada', 8990.00),
(7, '2026-06-28 08:30:00', 'En Ruta', 12990.00),
(8, '2026-06-28 12:00:00', 'En Bodega', 39990.00),
(9, '2026-06-28 15:20:00', 'Pendiente', 9990.00),
(10, '2026-06-28 20:00:00', 'Reembolsada', 24990.00);

-- Insertar Detalles de Órdenes
INSERT INTO Detalle_Orden (id_orden, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 2, 9990.00), (1, 10, 1, 10000.00),
(2, 3, 1, 24990.00), (3, 5, 1, 35990.00),
(4, 7, 2, 29990.00), (5, 6, 1, 19990.00),
(6, 9, 1, 8990.00),  (7, 10, 1, 12990.00),
(8, 8, 1, 39990.00), (9, 2, 1, 9990.00),
(10, 4, 1, 24990.00);

-- Insertar Pagos
INSERT INTO Pago (id_orden, metodo_pago, fecha_transaccion, estado) VALUES
(1, 'Webpay Tarjeta Crédito', '2026-06-25 14:32:00', 'Aprobado'),
(2, 'Webpay Tarjeta Débito', '2026-06-26 10:16:00', 'Aprobado'),
(3, 'MercadoPago', '2026-06-26 16:47:00', 'Aprobado'),
(4, 'Webpay Tarjeta Crédito', '2026-06-27 09:05:00', 'Pendiente'),
(5, 'Webpay Tarjeta Débito', '2026-06-27 11:22:00', 'Reversado'),
(6, 'Transferencia', '2026-06-27 18:15:00', 'Aprobado'),
(7, 'Webpay Tarjeta Crédito', '2026-06-28 08:31:00', 'Aprobado'),
(8, 'MercadoPago', '2026-06-28 12:02:00', 'Aprobado'),
(9, 'Transferencia', '2026-06-28 15:30:00', 'Pendiente'),
(10, 'Webpay Tarjeta Crédito', '2026-06-28 20:05:00', 'Reversado');

-- Insertar Couriers
INSERT INTO Courier (nombre_empresa, tipo_servicio, sla_dias_promedio) VALUES
('Chilexpress', 'Express 24h', 1),
('Starken', 'Normal Regional', 3),
('BlueExpress', 'Same Day RM', 0);

-- Insertar Despachos
INSERT INTO Despacho (id_orden, id_courier, codigo_tracking, fecha_envio, fecha_entrega_real, estado_tracking) VALUES
(1, 1, 'TRK-987654321', '2026-06-25 18:00:00', '2026-06-26 11:00:00', 'Entregado'),
(2, 2, 'TRK-987654322', '2026-06-26 15:00:00', NULL, 'En Reparto'),
(3, 3, 'TRK-987654323', NULL, NULL, 'Preparando en Bodega'),
(6, 1, 'TRK-987654324', '2026-06-28 10:00:00', '2026-06-28 16:30:00', 'Entregado'),
(7, 2, 'TRK-987654325', '2026-06-28 14:00:00', NULL, 'En Centro de Distribución');

-- Insertar Auditorías de Inventario (Gobierno de Datos)
INSERT INTO Auditoria_Inventario (id_producto, fecha_auditoria, cantidad_sistema, cantidad_fisica, diferencia, justificacion, estado_aprobacion) VALUES
(2, '2026-06-01 10:00:00', 50, 45, -5, 'Merma por falla de fábrica', 'Aprobado por Supervisor'),
(5, '2026-06-01 10:30:00', 20, 15, -5, 'Hurto en sala de ventas', 'Aprobado por Finanzas'),
(10, '2026-06-01 11:00:00', 85, 85, 0, 'Inventario Cuadrado', 'Cerrado Automático');

-- Insertar Tickets de Soporte / Quejas (SLA y Logística Inversa)
INSERT INTO Ticket_Soporte (id_cliente, id_orden, fecha_apertura, motivo, nivel_urgencia, estado_ticket, tiempo_resolucion_minutos) VALUES
(5, 5, '2026-06-29 09:00:00', 'Cambio de talla Polerón (Logística Inversa)', 1, 'Cerrado', 120),
(10, 10, '2026-06-29 10:00:00', 'Cobro Duplicado en Tarjeta', 2, 'Cerrado', 1440),
(2, 2, '2026-06-29 11:30:00', 'Retraso en entrega del Courier', 1, 'Abierto', NULL);