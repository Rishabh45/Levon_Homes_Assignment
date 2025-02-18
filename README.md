## Levon_Homes_Assignment

---
### Overview
This SQL script models a Bill of Materials (BOM) hierarchy for manufacturing assemblies, calculates raw material requirements for single or bulk production orders, and supports scalable inventory planning. It uses relational tables to map components, materials, and parent-child dependencies, enabling dynamic queries for material aggregation. Ideal for inventory management, cost estimation, and production optimization workflows.

---
### Objectives
- Model hierarchical BOM relationships to map parent-child dependencies between assemblies and components.
- Calculate raw material requirements for single or bulk production orders using dynamic SQL queries.
- Support scalable inventory planning by aggregating material needs across multiple assemblies.
- Enable efficient production workflows by identifying shared components (e.g., Sub-Assembly C) to minimize redundancy.
- Facilitate data-driven decision-making for inventory management, cost estimation, and resource allocation.

---
### Schema
```sql
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
```
