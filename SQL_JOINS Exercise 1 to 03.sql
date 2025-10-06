
--SQL JOINS DDL 
CREATE DATABASE sportswear;

GO;

USE sportswear;

GO;

CREATE SCHEMA clothing;

GO;

CREATE TABLE clothing.color (
	color_id INT PRIMARY KEY,
	color_name VARCHAR(50),
	extra_fee DECIMAL(10,2));

GO;

INSERT INTO clothing.color (color_id, color_name, extra_fee) VALUES
(1, 'Red',0.00),
(2, 'Blue',0.00),
(3, 'Black',0.00),
(4, 'White',0.00),
(5, 'Green',0.00),
(6, 'Yellow',0.00),
(7, 'Orange',0.50),
(8, 'Purple',0.75),
(9, 'Gold',1.50),
(10, 'Silver',1.25);

CREATE TABLE clothing.customer (
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	favorite_color_id INT,
	FOREIGN KEY(favorite_color_id) REFERENCES clothing.color(color_id)
);

INSERT INTO clothing.customer (customer_id, first_name, last_name, favorite_color_id) VALUES
(1, 'Alice',   'Johnson', 3),   -- Black
(2, 'Bob',     'Smith',   1),   -- Red
(3, 'Charlie', 'Brown',   2),   -- Blue
(4, 'Diana',   'White',   9),   -- Gold
(5, 'Ethan',   'Green',   5),   -- Green
(6, 'Fiona',   'Clark',   10),  -- Silver
(7, 'George',  'Miller',  4),   -- White
(8, 'Hannah',  'Davis',   7),   -- Orange
(9, 'Isaac',   'Lee',     8),   -- Purple
(10,'Julia',   'Adams',   6);   -- Yellow

CREATE TABLE clothing.category(
	category_id INT PRIMARY KEY,
	category_name VARCHAR(50),
	parent_id INT NULL,
    FOREIGN KEY (parent_id) REFERENCES clothing.category(category_id) 
);

INSERT INTO clothing.category (category_id, category_name, parent_id) VALUES
(1, 'Men', NULL),
(2, 'Women', NULL),
(3, 'Kids', NULL),
(4, 'Shoes', NULL),
(5, 'Accessories', NULL);

CREATE TABLE clothing.clothing (
    clothing_id INT PRIMARY KEY,
    clothing_name VARCHAR(100) NOT NULL,
    size VARCHAR(10) CHECK (size IN ('S','M','L','XL','2XL','3XL')),
    price DECIMAL(10,2) NOT NULL,
    color_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (color_id) REFERENCES clothing.color(color_id),
    FOREIGN KEY (category_id) REFERENCES clothing.category(category_id)
);

INSERT INTO clothing.clothing (clothing_id, clothing_name, size, price, color_id, category_id) VALUES
(1, 'Men T-Shirt', 'M', 19.99, 1, 1),   -- Red, Men
(2, 'Men Jeans', 'L', 39.99, 3, 1),     -- Black, Men
(3, 'Women Dress', 'S', 59.99, 2, 2),   -- Blue, Women
(4, 'Kids Hoodie', 'M', 29.99, 5, 3),   -- Green, Kids
(5, 'Running Shoes', 'XL', 79.99, 10, 4), -- Silver, Shoes
(6, 'Cap', 'M', 14.99, 7, 5),           -- Orange, Accessories
(7, 'Jacket', 'XL', 89.99, 9, 1),       -- Gold, Men
(8, 'Blouse', 'M', 34.99, 8, 2),        -- Purple, Women
(9, 'Sneakers', 'L', 64.99, 4, 4),      -- White, Shoes
(10, 'Scarf', 'S', 24.99, 6, 5);        -- Yellow, Accessories

CREATE TABLE clothing.clothing_order (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    clothing_id INT NOT NULL,
    items INT NOT NULL CHECK (items > 0),
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES clothing.customer(customer_id),
    FOREIGN KEY (clothing_id) REFERENCES clothing.clothing(clothing_id)
);

INSERT INTO clothing.clothing_order (order_id, customer_id, clothing_id, items, order_date) VALUES
(1, 1, 2, 1, '2025-09-01'),  -- Alice orders 1 Men Jeans
(2, 2, 1, 2, '2025-09-02'),  -- Bob orders 2 Men T-Shirts
(3, 3, 3, 1, '2025-09-03'),  -- Charlie orders 1 Women Dress
(4, 4, 7, 1, '2025-09-04'),  -- Diana orders 1 Jacket
(5, 5, 4, 3, '2025-09-05'),  -- Ethan orders 3 Kids Hoodies
(6, 6, 5, 1, '2025-09-06'),  -- Fiona orders 1 Running Shoes
(7, 7, 6, 2, '2025-09-07'),  -- George orders 2 Caps
(8, 8, 8, 1, '2025-09-08'),  -- Hannah orders 1 Blouse
(9, 9, 9, 2, '2025-09-09'),  -- Isaac orders 2 Sneakers
(10, 10, 10, 1, '2025-09-10'); -- Julia orders 1 Scarf









---SQL JOIN 
--Excercise 1
SELECT 
    cl.clothing_name AS clothes,
    co.color_name AS color,
    cu.last_name,
    cu.first_name
FROM clothing.clothing_order o
INNER JOIN clothing.clothing cl 
ON o.clothing_id = cl.clothing_id
INNER JOIN clothing.color co 
ON cl.color_id = co.color_id
INNER JOIN clothing.customer cu 
ON o.customer_id = cu.customer_id
WHERE cl.color_id = cu.favorite_color_id
ORDER BY co.color_name ASC;

--EXERCISE 2

SELECT 
    cu.last_name,
    cu.first_name,
    co.color_name AS favorite_color
FROM clothing.customer cu
INNER JOIN clothing.color co 
    ON cu.favorite_color_id = co.color_id
WHERE NOT EXISTS (
    SELECT 1
    FROM clothing.clothing_order o
    WHERE o.customer_id = cu.customer_id
);



--EXERCISE 3
SELECT 
    parent.category_name AS category,
    child.category_name AS subcategory
FROM clothing.category AS parent
LEFT JOIN clothing.category AS child
    ON parent.category_id = child.parent_id
WHERE parent.parent_id IS NULL;
