-- Creating Assemblies Table 
CREATE TABLE assemblies (
    assembly_id SERIAL PRIMARY KEY,
    assembly_name VARCHAR(50)
);

-- Creating Raw Materials Table 
CREATE TABLE raw_materials (
    material_id SERIAL PRIMARY KEY,
    material_name VARCHAR(50)
);

-- Creating Components Table
CREATE TABLE components (
    component_id SERIAL PRIMARY KEY,
    component_name VARCHAR(50),
    material_id INT,
    quantity_per_unit INT,
    FOREIGN KEY (material_id) REFERENCES raw_materials(material_id)
);

-- -- Creating BOM Structure Table
CREATE TABLE bom_structure (
    parent_component INT,
    child_component INT,
    quantity INT,
    FOREIGN KEY (parent_component) REFERENCES components(component_id),
    FOREIGN KEY (child_component) REFERENCES components(component_id)
);

-- Inserting into assemblies
INSERT INTO assemblies (assembly_name) VALUES ('Assembly A'), ('Assembly H');

-- Inserting into raw_materials
INSERT INTO raw_materials (material_name) VALUES 
('Sheet Metal'), ('Plastic Component'), ('Rubber Gasket'), ('Aluminum Frame'), ('Steel Rod');

-- Inserting into components
INSERT INTO components (component_name, material_id, quantity_per_unit) VALUES 
('Part D', 1, 2),   -- Sheet Metal
('Part E', 2, 3),   -- Plastic Component
('Part F', 3, 1),   -- Rubber Gasket
('Part G', 4, 4),   -- Aluminum Frame
('Part H', 5, 2),   -- Steel Rod
('Sub-Assembly C', 1, 1); -- Shared Component

-- Inserting into BOM Structure
-- Here, we show the hierarchical relationships, including shared parts:
-- Assembly A Structure
INSERT INTO bom_structure (parent_component, child_component, quantity) VALUES 
(1, 6, 1),  -- Assembly A -> Sub-Assembly C
(1, 2, 3),  -- Assembly A -> Part E
(1, 3, 1);  -- Assembly A -> Part F

-- Assembly H Structure
INSERT INTO bom_structure (parent_component, child_component, quantity) VALUES 
(2, 6, 1),  -- Assembly H -> Sub-Assembly C
(2, 4, 2),  -- Assembly H -> Part G
(2, 5, 1);  -- Assembly H -> Part H


SELECT * FROM assemblies;
SELECT * FROM raw_materials;
SELECT * FROM components;
SELECT * FROM bom_structure;


-- Data Analysis Queries
-- 1. Calculate Total Quantity of Raw Materials for Assembly A
-- For 10 units of Assembly A:
SELECT 
    rm.material_name,
    SUM(c.quantity_per_unit * b.quantity * 10) AS total_quantity
FROM 
    assemblies a
    JOIN bom_structure b ON a.assembly_id = b.parent_component
    JOIN components c ON b.child_component = c.component_id
    JOIN raw_materials rm ON c.material_id = rm.material_id
WHERE 
    a.assembly_name = 'Assembly A'
GROUP BY 
    rm.material_name;

-- 2. Calculate Total Quantity of Raw Materials for Assembly H
-- For 5 units of Assembly H:
SELECT 
    rm.material_name,
    SUM(c.quantity_per_unit * b.quantity * 5) AS total_quantity
FROM 
    assemblies a
    JOIN bom_structure b ON a.assembly_id = b.parent_component
    JOIN components c ON b.child_component = c.component_id
    JOIN raw_materials rm ON c.material_id = rm.material_id
WHERE 
    a.assembly_name = 'Assembly H'
GROUP BY 
    rm.material_name;

-- 3. Bulk Analysis for Multiple Quantities.
-- To perform Bulk Analysis for Multiple Quantities efficiently.
-- Step 1: Create Temporary Input Table
CREATE TEMP TABLE input_quantities (
    assembly_name VARCHAR(50),
    quantity_required INT
);

-- Step 2: Insert Sample Quantities:
--         Let's say we need:
--         10 units of Assembly A
--         5 units of Assembly H
--         20 units of Assembly A (for another order)
INSERT INTO input_quantities (assembly_name, quantity_required) VALUES 
('Assembly A', 10),
('Assembly H', 5),
('Assembly A', 20);

-- Step 3: Dynamic Query for Bulk Analysis.
SELECT 
    rm.material_name,
    SUM(c.quantity_per_unit * b.quantity * iq.quantity_required) AS total_quantity
FROM 
    input_quantities iq
    JOIN assemblies a ON iq.assembly_name = a.assembly_name
    JOIN bom_structure b ON a.assembly_id = b.parent_component
    JOIN components c ON b.child_component = c.component_id
    JOIN raw_materials rm ON c.material_id = rm.material_id
GROUP BY 
    rm.material_name
ORDER BY 
    rm.material_name;
