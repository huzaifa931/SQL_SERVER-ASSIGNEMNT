--EXERCISE 4 to 06 Group by 
--DDL Command
CREATE DATABASE sportswear;
CREATE DATABASE sportsclub;


USE sportsclub;


CREATE SCHEMA club;

CREATE TABLE club.runner (
    runner_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    main_distance INT NOT NULL,
    age INT NOT NULL,
    is_female BIT NOT NULL
);

INSERT INTO club.runner (runner_id, name, main_distance, age, is_female) VALUES
(1, 'Alice Johnson', 5000, 25, 1),   -- 5K female
(2, 'Bob Smith', 10000, 30, 0),      -- 10K male
(3, 'Charlie Brown', 42195, 35, 0),  -- Marathon male
(4, 'Diana White', 21097, 28, 1),    -- Half marathon female
(5, 'Ethan Green', 10000, 40, 0),    -- 10K male
(6, 'Fiona Clark', 5000, 22, 1),     -- 5K female
(7, 'George Miller', 5000, 27, 0),
(8, 'Hannah Davis', 5000, 23, 1),
(9, 'Isaac Lee', 10000, 29, 0),
(10, 'Julia Adams', 10000, 26, 1),
(11, 'Kevin Brown', 5000, 31, 0);

CREATE TABLE club.event (
    event_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    city VARCHAR(100) NOT NULL
);

INSERT INTO club.event (event_id, name, start_date, city) VALUES
(1, 'London Marathon', '2025-04-15', 'London'),
(2, 'Warsaw Runs', '2025-05-10', 'Warsaw'),
(3, 'New Year Run', '2025-01-01', 'New York'),
(4, 'Berlin Half Marathon', '2025-09-20', 'Berlin'),
(5, 'Paris 10K', '2025-07-05', 'Paris'),
(6, 'Rome 5K', '2025-08-01', 'Rome');


CREATE TABLE club.runner_event (
    runner_id INT NOT NULL,
    event_id INT NOT NULL,
    PRIMARY KEY (runner_id, event_id),
    FOREIGN KEY (runner_id) REFERENCES club.runner(runner_id),
    FOREIGN KEY (event_id) REFERENCES club.event(event_id)
);

INSERT INTO club.runner_event (runner_id, event_id) VALUES
(1, 3),  -- Alice joins New Year Run
(1, 5),  -- Alice joins Paris 10K
(2, 2),  -- Bob joins Warsaw Runs
(2, 5),  -- Bob joins Paris 10K
(3, 1),  -- Charlie joins London Marathon
(3, 2),  -- Charlie joins Warsaw Runs
(4, 1),  -- Diana joins London Marathon
(4, 4),  -- Diana joins Berlin Half Marathon
(5, 2),  -- Ethan joins Warsaw Runs
(6, 3),  -- Fiona joins New Year Run
(6, 5);  -- Fiona joins Paris 10K


 
--Exercise 04
SELECT 
	main_distance,
	COUNT(*) AS runners_number
FROM club.runner
GROUP BY main_distance
HAVING COUNT(*) > 3;

--EXERCISE 5

SELECT 
    e.name AS event_name,
    COUNT(re.runner_id) AS runner_count
FROM club.event e
LEFT JOIN club.runner_event re
    ON e.event_id = re.event_id
GROUP BY e.name
ORDER BY e.name;

--EXERCISE 6
SELECT 
    main_distance,
    COUNT(CASE WHEN age < 20 THEN 1 END) AS under_20,
    COUNT(CASE WHEN age BETWEEN 20 AND 29 THEN 1 END) AS age_20_29,
    COUNT(CASE WHEN age BETWEEN 30 AND 39 THEN 1 END) AS age_30_39,
    COUNT(CASE WHEN age BETWEEN 40 AND 49 THEN 1 END) AS age_40_49,
    COUNT(CASE WHEN age >= 50 THEN 1 END) AS over_50
FROM club.runner
GROUP BY main_distance
ORDER BY main_distance;